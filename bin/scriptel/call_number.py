#!/usr/bin/python
# 789234
import sys
import telnetlib

num = sys.argv[1]
num = num.replace(' ', '')
num = num.replace('.', '')
num = num.replace('-', '')

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

tn.write("uiusim dial " + num + "\n")
tn.read_until("[administrator]# ")
tn.write("uiusim headset\n")
tn.read_until("[administrator]# ")
tn.write("exit\n")
