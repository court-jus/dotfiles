#!/usr/bin/env python

import datetime
import psycopg2
import pytz

conn = psycopg2.connect("dbname=ikareapi user=ikareapi password=ikareapi host=docker_bdd_1")
curs = conn.cursor()

curs.execute("drop table if exists test")
curs.execute("create table test (ts timestamptz)")
curs.execute("insert into test (ts) values (now())")
curs.execute("insert into test (ts) values (now()::timestamp)")
curs.execute("insert into test (ts) values (now()::timestamptz)")

curs.execute("select ts from test")
for line in curs.fetchall():
    print line[0]
# curs.execute("select extract('hour' from (ts at time zone 'Europe/Paris')) from test")
# print curs.fetchone()[0]
print datetime.datetime.now()
print datetime.datetime.now() - line[0]
# print datetime.datetime.now(tz=pytz.utc).hour
