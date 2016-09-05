#!/usr/bin/env python
# -*- coding: utf-8 -*-

from xml.dom.minidom import parseString
import subprocess, datetime, pprint
import sys

def svn_wrapper(commande, document, tagname, attribute, xml = True):
    assert xml != less
    cmd = ["svn"]
    cmd.extend(commande)
    if xml:
        cmd.append("--xml")
    svninfo = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
    if xml:
        dom = parseString(svninfo)
        assert dom.documentElement.tagName == document
        entry = dom.getElementsByTagName(tagname)
        assert len(entry) == 1
        entry = entry[0]
        return entry.getAttribute(attribute)
    return svninfo

def getText(nodelist):
    rc = u""
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            rc = rc + node.data
    return rc

def xmllogentry2dict(node):
    revision = node.getAttribute('revision')
    subentries = node.getElementsByTagName('logentry')
    sublogs = []
    if subentries:
        sublogs = [xmllogentry2dict(subnode) for subnode in subentries]
    date = getText(node.getElementsByTagName('date')[0].childNodes)
    date = date.split('.')[0]
    date = datetime.datetime.strptime(date, '%Y-%m-%dT%H:%M:%S')
    return {
        'revision' : revision,
        'author'   : getText(node.getElementsByTagName('author')[0].childNodes),
        'msg'      : getText(node.getElementsByTagName('msg')[0].childNodes),
        'date'     : date,
        'sublogs'  : sublogs,
        }

def dictlog2wiki(log, level = 0):
    lines = []
    for logentry in log:
        msglines = [line.strip() for line in logentry['msg'].split('\n') if line.strip()]
        lines.append(u"%s * (%s) %s" % (u" " * level, logentry['revision'], msglines[0]))
        if len(msglines) > 1:
            lines.extend([u"%s * %s" % (u" " * (level+1), msg) for msg in msglines[1:]])
        if logentry['sublogs']:
            lines.extend(dictlog2wiki(logentry['sublogs'], level + 1))
    lines.reverse()
    return lines

def svn_log(start_revision, end_revision):
    cmd = ["svn", "log","-g","--revision",]
    cmd.append("%s:%s" % (start_revision, end_revision,))
    cmd.append("--xml")
    svninfo = subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0]
    dom = parseString(svninfo)
    assert dom.documentElement.tagName == 'log'
    log = []
    sublevel_logentries = []
    for node in dom.getElementsByTagName('logentry'):
        revision = node.getAttribute('revision')
        if revision not in sublevel_logentries:
            thislog = xmllogentry2dict(node)
            log.append(thislog)
            if thislog['sublogs']:
                sublevel_logentries.extend([sublog['revision'] for sublog in thislog['sublogs']])
    return log

if __name__ == "__main__":
    try:
        log = svn_log(sys.argv[1],'HEAD')
    except IndexError:
        print "Usage : %s REVNUMBER" % (sys.argv[0],)
    else:
        print u"\n".join(dictlog2wiki(log)).encode('utf-8')
