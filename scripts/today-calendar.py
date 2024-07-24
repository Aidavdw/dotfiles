from ics import Calendar
import requests
import sys

CALENDAR_URLS_FILE = 'scripts/calendars.txt'

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def update_calendar(conf: str):
    # conf is: | name | colour | url |
    x = conf.split(' ')
    if len(x) != 3:
        eprint("Configuration lines must be 3 entries each!")
        return
    (name, colour, url ) = x
    ics = requests.get(url).text
    c = Calendar(ics)
    timeline = c.timeline
    for event in timeline.today():
        print(event)


if __name__=="__main__":
    with open(CALENDAR_URLS_FILE) as fp:
        calendar_urls = fp.readlines()

    for conf in calendar_urls:
        update_calendar(conf)