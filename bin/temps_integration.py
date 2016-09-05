# -*- coding: utf-8 -*-
u"""Script permettant de grapher les données issues des temps d'intégration.

Voir http://10.31.254.25:8745/question/34/
"""

from django.db import connection


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
    cursor.execute("""select * from extraction_temps""")
    cnxs = set()
    jours = set()
    hashed = {}

    for row in cursor.fetchall():
        jour, tps_min, tps_max, tps_avg, count, cnx_id = row
        cnxs.add(cnx_id)
        jours.add(jour)
        hashed[(jour, cnx_id)] = relativedelta2seconds(tps_avg)

    def get_data(cnx):
        u"""Renvoie les données pour cette connexion."""
        s_jours = sorted(list(jours))
        result = []
        for jour in s_jours:
            result.append(
                u"""[Date.UTC({}, {}, {}), {}]"""
                .format(jour.year, jour.month, jour.day,
                        hashed.get((jour, cnx), 0))
            )
        return u", ".join(result)

    with open("/tmp/graph.js", "w") as fp:
        output = u"""
        $(function () {
            $('#container').highcharts({
            chart: {
                type: 'spline'
            },
            title: {
                text: 'Temps d\\'intégration',
            },
            xAxis: {
                type: 'datetime',
                dateTimeLabelFormats: {
                    month: '%e. %b',
                    year: '%b'
                },
                title: {
                    text: 'Date'
                }
            },
            yAxis: {
                title: {
                    text: 'Temps moyen (s)'
                },
                min: 0,
                max: 5
            },
            tooltip: {
                headerFormat: '<b>{series.name}</b><br>',
                pointFormat: '{point.x:%e. %b}: {point.y:.2f} m'
            },

            plotOptions: {
                spline: {
                    marker: {
                        enabled: false
                    }
                }
            },
            series: [{
        """
        output += u"}, {\n".join([
            u"""
            name: 'Connexion {}',
            data: [{}]
            """.format(cnx, get_data(cnx))
            for cnx in cnxs
        ])
        # name: 'Winter 2012-2013',
        # data: [
        #     [Date.UTC(1970, 9, 21), 0],
        #     [Date.UTC(1970, 10, 4), 0.28],
        # ]

        output += u"""
            }]
        })});

        """
        fp.write(output.encode("utf-8"))
