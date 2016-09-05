#!/bin/bash

author=$1
shift

workdir=$(mktemp -d)
commits_file=${workdir}/commits
output_file=${workdir}/a_documenter

git log --author=$author --reverse --oneline --no-merges $@ | awk '{print $1}' > ${commits_file}

for c in $(cat ${commits_file}); do
	doc_touchee=$(git show ${c} -- docs/manuel | wc -l)
	if [ $doc_touchee -eq 0 ]; then
		git show -s --oneline ${c} >> ${output_file}
	fi
done

cat ${output_file}
rm -rf $workdir