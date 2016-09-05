# -*- coding: utf-8 -*-
u"""Script permettant de faire des stats sur les temps d'intégration."""

import numpy


def run():
    u"""Point d'entrée du script."""
    data = []
    by_file = {}
    by_sec1 = {}
    by_sec2 = {}
    skip = 3
    curfile = None
    with open('temps_integre3.txt', 'r') as fp:
        skipped = 0
        for line in fp:
            if skipped < skip:
                skipped += 1
            else:
                try:
                    filename, sec1, sec2, temps = [field for field in line.split(' ') if field]
                except ValueError:
                    continue
                if filename == '-':
                    filename = curfile
                curfile = filename
                try:
                    temps = float(temps)
                except ValueError:
                    continue
                by_file.setdefault(filename, {}).setdefault(sec1, {}).setdefault(sec2, []).append(temps)
                by_sec1.setdefault(sec1, {}).setdefault(sec2, []).append(temps)
                by_sec2.setdefault(sec2, []).append(temps)
                data.append([filename, sec1, sec2, temps])

    cat = []
    series = []
    for sec1, data in by_sec1.items():
        if sec1 == 'integre':
            continue
        for sec2, temps in data.items():
            dico = {
                'sec1': sec1,
                'sec2': sec2,
                'mi': min(temps),
                'ma': max(temps),
                'co': len(temps),
                'av': sum(temps) / len(temps),
                'me': numpy.percentile(temps, 50),
                'lo': numpy.percentile(temps, 5),
                'hi': numpy.percentile(temps, 95),
            }
            cat.append(u"'{sec1}_{sec2}'".format(**dico))
            series.append(u"[{mi},{lo},{me},{hi},{ma}]".format(**dico))

    output = u"""
        $(function () {
            $('#container').highcharts({

                chart: {
                    type: 'boxplot'
                },

                title: {
                    text: 'Highcharts Box Plot Example'
                },

                legend: {
                    enabled: false
                },

                xAxis: {
                    categories: ["""
    output += u", ".join(cat)
    output += u"""],
                    title: {
                    }
                },

                yAxis: {
                    title: {
                    },
                },

                series: [{
                    data: ["""
    output += u", ".join(series)
    output += """],
                    tooltip: {
                        headerFormat: '<em>Experiment No {point.key}</em><br/>'
                    }
                }]

            });
        });
    """
    with open('/tmp/graph.js', 'w') as fp:
        fp.write(output.encode('utf-8'))
