# To be used in little calendar applet

from dataclasses import dataclass
from datetime import datetime, timedelta
from collections.abc import Sequence
from typing import override
from icalevents.icalparser import Event
from icalevents.icalevents import events
import os

CALENDAR_URLS_FILE = os.path.expanduser("~/.config/eww/calendars.txt")


# A container for multiple colums of events. Used for displaying events that are at the same time.
@dataclass
class ParallelEvents:
    events: list[Event]

    def get_start_time(self) -> datetime:
        time: datetime = datetime.fromisoformat("2000-01-01T00:00:00Z")
        for event in self.events:
            if event.start < time:
                time = event.start
        return time

    def get_end_time(self) -> datetime:
        # Todo: update this number before the year 3000.
        time: datetime = datetime.fromisoformat("2099-01-01T00:00:00Z")
        for event in self.events:
            if event.end < time:
                time = event.end
        return time

    @override
    def __repr__(self) -> str:
        return self.__str__()

    @override
    def __str__(self) -> str:
        buf = "Group {} - {}\n".format(self.get_start_time(), self.get_end_time())
        for event in self.events:
            buf += "    - {}\n".format(event)
        return buf


def group_into_parallel_events(all_events: Sequence[Event]) -> Sequence[ParallelEvents]:
    groups: Sequence[ParallelEvents] = []
    # A group can be closed when the last parallel event ends.
    group = ParallelEvents([])
    for event in all_events:
        # All-day events are handled differently. Also, they don't have timezone data
        if event.all_day:
            continue
        # If the event we're querying now starts after all the items in the group have ended, there is no overlap. It doesn't have to be part of this group. Since everything is sorted, this means we can close the group and start a new one.
        if event.start > group.get_end_time():
            groups.append(group)
            group = ParallelEvents([])

        group.events.append(event)

    return groups


def duration(event: Event):
    return event.end - event.start


if __name__ == "__main__":
    with open(CALENDAR_URLS_FILE) as fp:
        calendar_urls = fp.readlines()

    all_events: list[Event] = []
    for conf in calendar_urls:
        # conf is: | name | colour | url |
        x = conf.rstrip("\n").split(" ")
        if len(x) != 3:
            print("Configuration lines must be 3 entries each!")
            exit(0)
        today = datetime.today()
        untildate = datetime.now() + timedelta(days=7)
        (name, colour, url) = x
        print("Getting events for {name}".format(name=name))
        es = events(url=url, start=datetime.today(), end=untildate)
        all_events += es
    # Sort by start time. Make longer events more prioritised by cutting a tiny bit away.
    all_events.sort(
        key=lambda event: (
            event.start.timestamp() - (event.end - event.start).total_seconds() * 1e-6
        )
    )
    groups = group_into_parallel_events(all_events)
    print(groups)
