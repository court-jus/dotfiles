#!/usr/bin/env python

import xmlrpclib
import ssl
import sys

kwargs = {}
if (
    sys.version_info.major > 2 or  # python 3.x.x
    sys.version_info.micro > 9
):
    kwargs["context"] = ssl.SSLContext(ssl.PROTOCOL_TLSv1)

p = xmlrpclib.ServerProxy(
    "https://admin:admin@docker_api_1:8000/rpc2",
    **kwargs
)
me = p.user.me()
print("OK, welcome {}".format(me['login']))
