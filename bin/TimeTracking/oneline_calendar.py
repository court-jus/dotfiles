#!/usr/bin/env python
# -*- coding: utf-8 -*-

try:
    from xml.etree import ElementTree
except ImportError:
    from elementtree import ElementTree

import gdata.calendar.service
import gdata.service
import gdata.calendar
import sys
import os
import datetime
import time as _time

STDOFFSET = datetime.timedelta(seconds = -_time.timezone)
if _time.daylight:
    DSTOFFSET = datetime.timedelta(seconds = -_time.altzone)
else:
    DSTOFFSET = STDOFFSET

DSTDIFF = DSTOFFSET - STDOFFSET

from TimeTracker import coloriser

MAGIC_COOKIE = "7c1fa22ccc52c25062d241fda33576db"
USERNAME = 'ghislain.leveque@clarisys.fr'
TIME_FORMAT = '%Y-%m-%dT%H:%M:%S.000'

def DateRangeQuery(calendar_service, start_date, end_date):
    query = gdata.calendar.service.CalendarEventQuery(USERNAME, "private-%s" % (MAGIC_COOKIE,), "full")
    query.start_min = start_date
    query.start_max = end_date
    feed = calendar_service.CalendarQuery(query)
    return feed

def timedelta2str(value):
    if value is None:
        return None
    if not isinstance(value, datetime.timedelta):
        return "0"
    if value.days == 0 and value.seconds == 0:
        return "0"
    days = value.days
    years = 0
    result = []
    if days >= 365:
        years = days/365
        days = days%365
        result.append("%sA" % years)
    if days:
        result.append("%sJ" % days)
    if value.seconds != 0:
        sec = value.seconds
        hours = sec/3600
        sec = sec%3600
        min = sec/60
        sec = sec%60
        result.append("%i:%02.2i" % (hours, min))
    return " ".join(result)

def myrepr(event):
    st, et, ti = event
    now = datetime.datetime.now()
    if st < now:
        if et < now:
            ti = coloriser(ti, "bleu")
        else:
            ti = coloriser(ti, "rougec")
    else:
        ti = u"%s (in %s)" % (ti, timedelta2str(st - now))
        ti = coloriser(ti, "vertc")
    return u"%s" % (ti,)

def showall(events):
    os.system("clear")
    #cdate = (datetime.datetime.now().date() - datetime.timedelta(days = 1))
    cdate = datetime.datetime.now().date()
    dates = []
    cdates = []
    for event in events:
        if event[0].date() != cdate:
            dates.append(cdates)
            cdates = []
            cdate = event[0].date()
        cdates.append(myrepr(event))
    dates.append(cdates)
    sys.stdout.write(u"\n\n".join([
        u"\n".join([E for E in Es])
        for Es in dates if Es]))
    sys.stdout.write("\n")
    sys.stdout.flush()

class LocalTimezone(datetime.tzinfo):
    def utcoffset(self, dt):
        if self._isdst(dt):
            return DSTOFFSET
        return STDOFFSET

    def dst(self, dt):
        if self._isdst(dt):
            return DSTDIFF
        return datetime.timedelta(0)

    def tzname(self, dt):
        return _time.tzname[self._isdst(dt)]

    def _isdst(self, dt):
        tt = (dt.year, dt.month, dt.day,
              dt.hour, dt.minute, dt.second,
              dt.weekday(), 0, 0)
        stamp = _time.mktime(tt)
        tt = _time.localtime(stamp)
        return tt.tm_isdst > 0

if __name__ == "__main__":
    Local = LocalTimezone()
    myevents = []
    yest = (datetime.datetime.now().date() - datetime.timedelta(days = 1)).strftime('%Y-%m-%d')
    today = datetime.datetime.now().date().strftime('%Y-%m-%d')
    tomo = (datetime.datetime.now().date() + datetime.timedelta(days = 28)).strftime('%Y-%m-%d')
    feed = DateRangeQuery(gdata.calendar.service.CalendarService(), today, tomo)
    for i, an_event in enumerate(feed.entry):
        for a_when in an_event.when:
            st_time_string = a_when.start_time.split('+')[0]
            ed_time_string = a_when.end_time.split('+')[0]
            try:
                st_time = datetime.datetime.strptime(st_time_string, TIME_FORMAT)
            except ValueError:
                st_time = datetime.datetime.strptime(st_time_string, '%Y-%m-%d')
            try:
                ed_time = datetime.datetime.strptime(ed_time_string, TIME_FORMAT)
            except ValueError:
                ed_time = datetime.datetime.strptime(ed_time_string, '%Y-%m-%d')
            myevents.append((st_time, ed_time, an_event.title.text.decode('UTF-8')))
    def myevent_sort(a,b):
        return cmp(a[0], b[0])
    myevents.sort(myevent_sort)
    showall(myevents)
