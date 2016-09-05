# -*- coding: utf-8 -*-

import gdata.calendar.service

def GetAuthSubUrl():
    next = 'http://localhost'
    scope = 'https://www.google.com/calendar/feeds/'
    secure = False
    session = True
    calendar_service = gdata.calendar.service.CalendarService()
    return calendar_service.GenerateAuthSubURL(next, scope, secure, session)

token = """1%2FMyYyz2HetHbs9xRXDYY9hXvytFczEJi6jAP81ZMZ8sg"""
calendar_service = gdata.calendar.service.CalendarService()
calendar_service.auth_token = token
calendar_service.UpgradeToSessionToken()
feed = calendar_service.GetCalendarListFeed()
for i, acal in enumerate(feed.entry):
    print '\t%s. %s' % (i, acal.title.text,)
#authSubUrl = GetAuthSubUrl()
#print authSubUrl
