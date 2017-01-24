#!/usr/bin/env python
# -*- coding: utf-8 -*-

import gitlab3 as gitlab
from markdown2 import markdown
import os
import pdb
import sys
import subprocess
from weasyprint import HTML

TOKEN = ''
tokenfile = os.path.join(os.path.expanduser('~'), '.gitlabtoken')

with open(tokenfile, 'r') as fp:
        TOKEN = fp.readline().strip()

if not TOKEN:
    print("No token found in %s" % (tokenfile, ))
    sys.exit(1)

git = gitlab.GitLab('http://gitlab.itrust.fr', token=TOKEN)
hash_projects = {
    project.name_with_namespace: project
    for project in git.projects()
}

def get_issue(project_name, issue_id):
    project = hash_projects[project_name]
    return filter(
        lambda i: i.iid == issue_id,
        project.issues()
    )[0]



def convert_md_2_pdf(input, output=None, theme=None):
    input = markdown(input)
    if not output:
        output = '.'.join([filename.rsplit('.', 1)[0], 'pdf'])

    if theme is not None:
        BASE_DIR = os.path.abspath(os.path.dirname(__file__))
        css_file = theme
        if not os.path.exists(css_file):
            css_file = os.path.join(BASE_DIR, 'themes/'+theme+'.css')

        print css_file
        HTML(string=input).write_pdf(output, stylesheets=[css_file])
    else:
        HTML(string=input).write_pdf(output)


def issue_to_pdf(project, issue):
    filename = '/home/gl/Documents/Gitlab/issues/{}_{}.pdf'.format(
        project.replace(' ', '').replace('/', '_'), issue)
    i = get_issue(project, issue)
    convert_md_2_pdf(i.description, output=filename)


def generate_common_link_to_all(suffix):
    for p in hash_projects.values():
        print("{}/{}".format(p.web_url, suffix))


if __name__ == '__main__':
    # issue_to_pdf('ikare / ikare-meta', 9)
    generate_common_link_to_all('labels')
