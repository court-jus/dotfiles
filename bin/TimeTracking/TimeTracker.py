#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import time
import os
import sys
import shelve
import sqlite3
from optparse import OptionParser

DELAY=1
DATABASE = os.path.join(os.path.expanduser('~'), 'var', 'TimeTracking', 'data.db')
def quartime(d):
    mn = d.minute
    hr = d.hour
    nmn = 15 * int(mn / 15) + (15 if mn % 15 > 7.5 else 0)
    if nmn == 60:
        hr += 1
        nmn = 0
    return datetime.datetime(d.year, d.month, d.day, hr, nmn)

############
# SQLITE Types from/to python
############
def adapt_datetime(dt):
    return time.mktime(dt.timetuple())
def convert_datetime(s):
    return datetime.datetime.fromtimestamp(float(s))
sqlite3.register_adapter(datetime.datetime, adapt_datetime)
sqlite3.register_converter("datetime", convert_datetime)
############

class TimeTracker(object):
    def __init__(self, sqlite = False):
        self.tasks = []
        self.current = None
        self.history = []
        self.conn = None
        if sqlite:
            self.conn = sqlite3.connect(DATABASE, detect_types=sqlite3.PARSE_DECLTYPES)
            if False:
                self.init_db()
                self.load_from_shelve()
                self.save_to_db()
            self.load_from_db()
        else:
            self.load_from_shelve()

    def load_from_shelve(self):
        s = shelve.open(os.path.join(os.path.expanduser('~'), 'var', 'TimeTracking', 'data.shlv'))
        for i, t in enumerate(s.get('tasks', [])):
            self.tasks.append(Task(i, t))
        for h in s.get('history', []):
            self.history.append(h)
        self.current = s.get('current')
        print self.history
        s.close()

    def init_db(self):
        c = self.conn.cursor()
        c.execute("""create table task (name text)""")
        c.execute("""create table history (task_id integer, start datetime, end datetime, current boolean default false, foreign key(task_id) references task(rowid))""")
        c.execute("""create table note (history_id integer, note text, date datetime, foreign key(history_id) references history(rowid))""")
        c.execute("""create table todo (note text, date datetime, done boolean default false)""")
        self.conn.commit()
        c.close()

    def load_from_db(self):
        c = self.conn.cursor()
        # Current
        c.execute("select t.name, h.start from task as t join history as h on (h.task_id = t.rowid) where h.current")
        current = c.fetchone()
        c.execute("select note from note where history_id = (select rowid from history where current)")
        self.current = [current[0], current[1], [n[0] for n in c.fetchall()]]
        # Tasks
        c.execute("select name from task")
        self.tasks = [Task(i, t[0]) for i, t in enumerate(c.fetchall())]
        # History
        c.execute("select h.rowid, t.name, h.start from task as t join history as h on (h.task_id = t.rowid) where not h.current")
        history = c.fetchall()
        for h in history:
            c.execute("select note from note where history_id = ?", (h[0],))
            notes = [n[0] for n in c.fetchall()]
            self.history.append([h[1], h[2], notes])
        self.conn.commit()
        c.close()

    def save(self):
        s = shelve.open(os.path.join(os.path.expanduser('~'), 'var', 'TimeTracking', 'data.shlv'))
        s['tasks'] = [t.name for t in self.tasks]
        s['history'] = self.history[:]
        s['current'] = self.current
        s.close()

    def save_to_db(self):
        c = self.conn.cursor()
        for t in self.tasks:
            c.execute("insert into task (name) values (?)", (t.name,))
        for h in self.history:
            if h:
                c.execute("insert into history(task_id, start) values ((select rowid from task where name = ?), ?)", (h[0], h[1],))
                rowid = c.lastrowid
                for note in h[2]:
                    c.execute("insert into note(history_id, note) values (?, ?)", (rowid, note,))
        if self.current:
            c.execute("insert into history(task_id, start, current) values ((select rowid from task where name = ?), ?, 1)", (self.current[0], self.current[1],))
            for note in self.current[2]:
                c.execute("insert into note (history_id, note) values ((select rowid from history where current), ?)", (note,))
        self.conn.commit()
        c.close()

    def run(self):
        while True:
            os.system('clear')
            sys.stdout.write(unicode(self))
            sys.stdout.flush()
            time.sleep(1)
            self.reload()

    def setCurrent(self, numero):
        self.history.append(self.current)
        self.current = [self.tasks[numero].name, datetime.datetime.now(), []]
        if self.conn:
            c = self.conn.cursor()
            c.execute("update history set end = ?, current = ? where current", (datetime.datetime.now(), False,))
            c.execute("insert into history(task_id, start, current) values ((select rowid from task where name = ?), ?, ?)", (self.tasks[numero].name, datetime.datetime.now(), True,))
            self.conn.commit()
            c.close()
        self.save()

    def addNote(self, note):
        self.current[2].append(note)
        if self.conn:
            c = self.conn.cursor()
            c.execute("insert into note(history_id, note) values ((select rowid from history where current), ?)", (note,))
            self.conn.commit()
            c.close()
        self.save()

    def addTask(self, taskname):
        self.tasks.append(Task(len(tt.tasks), taskname))
        if self.conn:
            c = self.conn.cursor()
            c.execute("insert into task(name) values (?)", (taskname,))
            self.conn.commit()
            c.close()
        self.save()

    def reload(self):
        self.tasks = []
        self.history = []
        self.current = None
        if self.conn:
            self.load_from_db()
        else:
            self.load_from_shelve()

    def weekshow(self, monday = None):
        if monday is None:
            monday = (datetime.datetime.now() - datetime.timedelta(days = datetime.datetime.now().weekday())).date()
        friday = monday + datetime.timedelta(days = 4)
        weekhistory = [H for H in self.history if H and H[1].date() >= monday and H[1].date() <= friday]
        def cstm_sort(a, b):
            return cmp(a[1], b[1])
        weekhistory.sort(cstm_sort)
        current_day = monday
        current_item = None
        previous_item = [None, None]
        booking_data = {}
        def calculate_booking(cur, prev):
            if prev[1] is None:
                prev = [None, datetime.datetime(*monday.timetuple()[:-2]) + datetime.timedelta(hours = 9)]
            ncur = quartime(cur[1])
            nprev = quartime(prev[1])
            if ncur - nprev < datetime.timedelta(minutes = 15):
                return None
            return [prev[0], nprev, ncur]

        for current_item in weekhistory:
            notes = []
            if len(current_item) > 2 and current_item[2]:
                notes = current_item[2]
            booking = calculate_booking(current_item, previous_item)
            if booking:
                booking_data.setdefault(booking[0],[]).append([booking[1:], notes])
            else:
                current_item = (current_item[0],previous_item[1]) # on prend le delta "pour nous"
            previous_item = current_item
        def activity_display(activity, notes):
            if notes:
                pass
        for task, activities in booking_data.iteritems():
            print "    #", task
            print "    booking "
            l = []
            for activity, notes in activities:
                s = []
                if notes:
                    s.extend([u"# %s" % (n,) for n in notes])
                s.append(u" - ".join([dtime.strftime("%Y-%m-%d-%H:%M") for dtime in activity]))
                l.append(u"\n        ".join(s))
                #print ",\n".join([
                #    " - ".join([dtime.strftime("%Y-%m-%d-%H:%M") for dtime in activity])
                #    for activity in activities])
            print "       ",
            print ",\n        ".join(l), "{ sloppy 1 }"

    def menushow(self):
        print "Dynamic {"
        #echo " Entry = \"$output\" { Actions = \"Exec xmessage $output\" }"
        for index, task in enumerate(self.tasks):
            print """    Entry = "%i - %s" { Actions = "Exec $HOME/bin/TimeTracking/TimeTracker.py --choose=%i" }""" % (index + 1, task.name, index + 1)
        print "}"

    def __unicode__(self):
        tasks_disp = u" ".join([coloriser(u"%s %3s" % (t,len(self.current[2]) if self.current and t.name == self.current[0] else ''), ("rougec" if self.current and t.name == self.current[0] else "vertc")) for t in self.tasks])
        current_disp = ""
        if self.current:
            current_disp = self.current[1].strftime('%H:%M')
        return u"%s - %s - %s - %s" % (datetime.datetime.now().strftime("%d/%m"), current_disp, datetime.datetime.now().strftime('%H:%M'), tasks_disp)

class Task(object):
    def __init__(self, index, name):
        self.name = name
        self.index = index

    def __unicode__(self):
        return u"%2.2d %-10.10s" % (self.index + 1, self.name)


if __name__ == "__main__":
    p = OptionParser()
    p.add_option("--run", action="store_true", default=False, dest="run", help="Run")
    p.add_option("--choose", action="store", type="int", dest="numero", help="Choose task number")
    p.add_option("--show", action="store_true", dest="show", help="Show data for the current week")
    p.add_option("--monday", action="store", dest="monday", help="Show data for the week starting at this monday (format : dd/mm/yyyy)")
    p.add_option("--menu", action="store_true", dest="menu", help="Generates a menu for pekwm 'Dynamic menu' system")
    p.add_option("--note", action="store", dest="note", help="Add a note to current task")
    p.add_option("--nosqlite", action="store_false", dest="use_sqlite", default=True, help="USE SQLite")
    (O, A) = p.parse_args()

    tt = TimeTracker(sqlite = O.use_sqlite)
    if O.run:
        tt.run()
    elif O.numero is not None:
        tt.setCurrent(O.numero - 1)
    elif O.show:
       tt.weekshow()
    elif O.monday:
        tt.weekshow(monday = datetime.datetime.strptime(O.monday, '%d/%m/%Y').date())
    elif O.menu:
        tt.menushow()
    elif O.note:
        tt.addNote(O.note.decode("UTF-8"))
    elif A:
        tt.addTask(A[0])
