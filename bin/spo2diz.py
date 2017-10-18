#!/usr/bin/env python
import requests
import json
import sys

while True:
    sys.stdout.write("> link >  ")
    text = raw_input()
    r = requests.post(
        "http://mattermost.itrust.fr:3000/convert",
        {
        "token" : "9p4miqfrqi8pffkb6mz6cjithr",
        "text": text
        }
    )

    if r.status_code == 200:
        print r.json().get("text", "failed")
    else:
        print "Failed"
