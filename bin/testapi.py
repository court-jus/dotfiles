#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pdb  # noqa
import ssl
import sys
import xmlrpclib
import time

api_host = "sarah.itrust.fr"
api_host = "docker_api_1"


if len(sys.argv) > 1:
    api_host = sys.argv[1]

kwargs = {}
if (
    sys.version_info.major > 2 or  # python 3.x.x
    sys.version_info.micro > 9
):
    kwargs["context"] = ssl.SSLContext(ssl.PROTOCOL_TLSv1)

p = xmlrpclib.ServerProxy(
    "https://admin:admin@{}:8000/rpc2".format(api_host, ),
    **kwargs
)

print(p.report.generateGroupReport(1, "raw"))["rt_stats"]
sys.exit(0)

hosts = {}
vulns = {}
total = None
offset = 0
while total is None or len(hosts.keys()) < total:
    data = p.host.find(*["scan == True and archived == False", 0, offset])
    total = data['count']
    offset += data['limit']
    for item in data['data']:
        hid = item['id']
        print("hid", hid)
        hosts[hid] = item
        hosts[hid]['fullstate'] = p.host.getFullState(hid, time.time())
        for vid, vuln in hosts[hid]['fullstate']['vulns'].items():
            vulns.setdefault(vuln['plugin'], []).append(hid)
    print("{}/{} hosts".format(len(hosts.keys()), total))

# Top vulns
topvulns = vulns.items()
topvulns.sort(key=lambda v: len(v[1]), reverse=True)
topvulns = topvulns[:5]
topvulns = {
    plugin: [hosts[hid]['ip'] for hid in vulnhosts]
    for plugin, vulnhosts
    in topvulns
}

# Worst hosts
worstscores = hosts.items()
worstscores.sort(key=lambda h: h[1]['fullstate']['stat']['grade'])
worstscores = [(h[1]['fullstate']['stat']['grade'], h[1]['ip']) for h in worstscores[:10]]


print("Top Vulns", topvulns)
print("Worst Scores", worstscores)
