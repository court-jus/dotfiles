# -*- coding: utf-8 -*-

from collections import OrderedDict
import datetime
from django.db import connection
import numpy
import time


def relativedelta2seconds(r):
    u"""Conversion d'un relative delta en floatant."""
    if r is None:
        return 0
    return (
        r.days * 24 * 60 * 60 +
        r.hours * 60 * 60 +
        r.minutes * 60 +
        r.seconds +
        r.microseconds / 1000000.
    )


def run():
    u"""Point d'entrée du script."""
    cursor = connection.cursor()
    cursor.execute("""select * from temps_integration""")
    data = OrderedDict()
    delta = 15 * 60

    for row in cursor.fetchall():
        start, end = row
        week_st = time.mktime(
            ((start - datetime.timedelta(
                seconds=start.second,
                microseconds=start.microsecond,
            ))).timetuple()
        )
        week_st = int(week_st / delta)
        dur = (end - start).total_seconds()
        if week_st not in data:
            data[week_st] = []
        data[week_st].append(dur)

    cat = []
    series = []
    for x, all_y in data.iteritems():
        dico = {
            'x': x * delta*1000,
            'mi': min(all_y),
            'ma': max(all_y),
            'co': len(all_y),
            'av': sum(all_y) / len(all_y),
            'me': numpy.percentile(all_y, 50),
            'lo': numpy.percentile(all_y, 5),
            'hi': numpy.percentile(all_y, 95),
        }
        series.append(u"{{x: {x}, low: {mi}, q1: {lo}, median: {me}, q3: {hi}, high: {ma}}}".format(**dico))

    output = u"""
        $(function () {
            $('#container').highcharts({

                chart: {
                    type: 'boxplot',
                    zoomType: 'x'
                },

                legend: {
                    enabled: false
                },

                xAxis: {
                    type: 'datetime',
                },

                yAxis: {
                    max: 50,
                },

                series: [{
                    data: ["""
    output += u", ".join(series)
    output += """]
                }]

            });
        });
    """
    with open('/tmp/graph.js', 'w') as fp:
        fp.write(output.encode('utf-8'))
