# -*- coding: utf-8 -*-

import gitlab3 as gitlab
import os
import sys
import subprocess

TOKEN = ''
WORKING_COPY = os.path.join(os.path.expanduser('~'), 'src', 'mca')
tokenfile = os.path.join(os.path.expanduser('~'), '.gitlabtoken')


def is_merged(commithash, bname):
    try:
        candidates = subprocess.check_output([
            'git', '-C', WORKING_COPY, 'branch', '-r', '--contains', commithash
        ], )
    except subprocess.CalledProcessError:
        return []
    result = []
    for branchname in candidates.strip().split('\n'):
        if branchname.strip().endswith(bname):
            continue
        result.append(branchname.strip())
    return result

with open(tokenfile, 'r') as fp:
        TOKEN = fp.readline().strip()

if not TOKEN:
    print("No token found in %s" % (tokenfile, ))
    sys.exit(1)

git = gitlab.GitLab('http://gitlab.clarisys.lan', token=TOKEN)
mca = git.project(68)

merges = dict([
    (mr.source_branch, mr.title)
    for mr in mca.merge_requests(state='opened')
])
messages_by_author = {}

for branch in mca.branches():
    bname = branch.name
    if (
        bname.startswith('stable-') or
        bname.startswith('prod-') or
        bname.startswith('testing-')
    ):
        continue

    commit = branch.commit
    mr_exists = branch.name in merges
    merged_in_another = is_merged(commit['id'], branch.name)
    author = commit['committer_email']

    if mr_exists:
        continue

    if not merged_in_another:
        messages_by_author.setdefault(author, []).append(
            u"""
%s
(%s - %s)
http://gitlab.clarisys.lan/mca/mca/commits/%s

""" %
            (branch.name, commit['id'], commit['committed_date'],
             branch.name, )
        )
    else:
        messages_by_author.setdefault(author, []).append(
            u"""
La branche %s
(%s - %s)
ne fait l'objet d'aucune merge request mais a été mergée dans d'autres
branches :
%s

Faut-il supprimer cette branche ?

http://gitlab.clarisys.lan/mca/mca/commits/%s""" %
            (branch.name, commit['id'], commit['committed_date'],
             u"\n".join(merged_in_another), branch.name, )
        )

for mail, messages in messages_by_author.items():
    with open(os.path.join('/tmp', mail), 'w') as fp:
        for message in messages:
            fp.write(message.encode('utf-8'))
        fp.write(u"\n")
