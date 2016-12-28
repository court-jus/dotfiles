#!/usr/bin/env python

import pdb  # noqa
import ssl
import sys
import xmlrpclib

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

print(p.user.me())
print(p.host.find("in_group(16) and updated_at > '20161225'"))
print(xmlrpclib.dumps(("in_group(16) and updated_at > '20161225'",),"host.find"))
