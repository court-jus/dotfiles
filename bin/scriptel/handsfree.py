#!/usr/bin/python
# 789234
import getpass
import sys
import telnetlib

HOST = "telephone"
user = "administrator"
password = "789234"

tn = telnetlib.Telnet(HOST)

tn.read_until("Login: ")
tn.write(user)
tn.write("\r")
if password:
    tn.read_until("Password: ")
    tn.write(password)
    tn.write("\r")

tn.read_until("[administrator]# ")

tn.write("uiusim handsfree\n")
tn.read_until("[administrator]# ")
tn.write("exit\n")


