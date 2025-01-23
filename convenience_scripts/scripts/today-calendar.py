# To be used in little calendar applet

from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from collections.abc import Sequence
from typing import override
from icalevents.icalparser import Event
from icalevents.icalevents import events
import os
from colorama import Fore, Back, Style

CALENDAR_URLS_FILE = os.path.expanduser("~/scripts/calendars.txt")
my_time_zone = datetime.now().astimezone().tzinfo


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


def now():
    return datetime.now(datetime.now().astimezone().tzinfo)


def duration(event: Event):
    return event.end - event.start


def print_event_list(events: list[Event]):
    at_day = -9999
    for event in events:
        # For some reason inverting it, event.start - now() magically makes an extra day appear. So, extra minux also works.
        delta_day = -(now() - event.start).days
        if delta_day > at_day:
            at_day = delta_day
            date = event.start.date()
            if at_day < -2:
                print(
                    Back.LIGHTBLACK_EX
                    + f"======== {at_day}日前 {date}========="
                    + Back.RESET
                )
            elif at_day == -2:
                print(
                    Back.LIGHTBLACK_EX
                    + f"======== 一昨日 {date} ========="
                    + Back.RESET
                )
            elif at_day == -1:
                print(Back.LIGHTBLACK_EX + f"========  昨日  =========" + Back.RESET)
            elif at_day == 0:
                print(Back.LIGHTBLACK_EX + f"========  今日  =========" + Back.RESET)
            elif at_day == 1:
                print(Back.LIGHTBLACK_EX + f"========  明日  =========" + Back.RESET)
            elif at_day == 2:
                print(Back.LIGHTBLACK_EX + f"======== 明後日 =========" + Back.RESET)
            elif at_day == 3:
                print(Back.LIGHTBLACK_EX + f"======== 明々後 =========" + Back.RESET)
            elif at_day > 3:
                print(
                    Back.LIGHTBLACK_EX + f"======== {at_day}日後 =========" + Back.RESET
                )
        print_event(event)
    return


def print_event(event: Event):
    s = event.start.astimezone(my_time_zone).time()
    e = event.end.astimezone(my_time_zone).time()
    from_to = (
        Style.BRIGHT
        + f"{s.hour}:{s.minute:02d} → {e.hour}:{e.minute:02d}"
        + Style.NORMAL
    )
    time_until_start = event.start - now()
    time_until_end = event.end - now()
    hours_until = (time_until_start.seconds / 3600).__floor__()
    minutes_until = ((time_until_start.seconds - hours_until * 3600) / 60).__floor__()
    # If the event is ongoing, mark it in a special color
    if time_until_start.total_seconds() < 0 and time_until_end.total_seconds() > 0:

        hours_until_end = (time_until_end.seconds / 3600).__floor__()
        minutes_until_end = (
            (time_until_end.seconds - hours_until_end) / 60
        ).__floor__()
        print(
            Fore.YELLOW
            + f"{from_to}: {event.summary} (for {hours_until_end}:{minutes_until_end:2})"
            + Fore.RESET
        )
    # If the event has already ended, mark it in a different colour.
    elif time_until_start.total_seconds() < 0:
        print(Style.DIM + f"{from_to}: {event.summary}" + Style.RESET_ALL)
    # If the event is today, give more information. denote time until,
    elif time_until_start.days < 1:
        print(
            Fore.BLUE
            + f"{from_to}: {event.summary} (in {hours_until}h{minutes_until:02d})"
            + Fore.RESET
        )
    # If it is tomorrow or later, just give rough information
    else:
        print(Fore.LIGHTBLACK_EX + f"{from_to}: {event.summary}" + Fore.RESET)


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
        untildate = datetime.now(timezone.utc) + timedelta(days=7)
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
    print_event_list(all_events)
    # groups = group_into_parallel_events(all_events)
    # print(groups)
