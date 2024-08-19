"""
This type stub file was generated by pyright.
"""

from datetime import datetime
from typing import Optional
from icalendar.prop import vText

"""
Parse iCal data to Events.
"""

def now():  # -> datetime:
    """
    Get current time.

    :return: now as datetime with timezone
    """
    ...

class Event:
    start: datetime = ...
    end: datetime = ...
    summary: str = ...
    all_day: bool = ...
    """
    Represents one event (occurrence in case of reoccurring events).
    """
    def __init__(self) -> None:
        """
        Create a new event occurrence.
        """
        ...

    def time_left(self, time=...):
        """
        timedelta form now to event.

        :return: timedelta from now
        """
        ...

    def __lt__(self, other) -> bool:
        """
        Events are sorted by start time by default.

        :param other: other event
        :return: True if start of this event is smaller than other
        """
        ...

    def __str__(self) -> str: ...
    def copy_to(self, new_start=..., uid=...):  # -> Event:
        """
        Create a new event equal to this with new start date.

        :param new_start: new start date
        :param uid: UID of new event
        :return: new event
        """
        ...

def encode(value: Optional[vText]) -> Optional[str]: ...
def create_event(component, tz=...):  # -> Event:
    """
    Create an event from its iCal representation.

    :param component: iCal component
    :param tz: timezone for start and end times
    :return: event
    """
    ...

def normalize(dt, tz=...):  # -> datetime:
    """
    Convert date or datetime to datetime with timezone.

    :param dt: date to normalize
    :param tz: the normalized date's timezone
    :return: date as datetime with timezone
    """
    ...

def parse_events(content, start=..., end=..., default_span=...):
    """
    Query the events occurring in a given time range.

    :param content: iCal URL/file content as String
    :param start: start date for search, default today
    :param end: end date for search
    :param default_span: default query length (one week)
    :return: events as list
    """
    ...

def parse_rrule(component, tz=...):  # -> rruleset | rrule:
    """
    Extract a dateutil.rrule object from an icalendar component. Also includes
    the component's dtstart and exdate properties. The rdate and exrule
    properties are not yet supported.

    :param component: icalendar component
    :param tz: timezone for DST handling
    :return: extracted rrule or rruleset
    """
    ...

def extract_exdates(component):  # -> list[Any]:
    """
    Compile a list of all exception dates stored with a component.

    :param component: icalendar iCal component
    :return: list of exception dates
    """
    ...
