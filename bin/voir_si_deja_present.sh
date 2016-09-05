#!/bin/bash

source=$1
cible=$2
max_hist=$3

for commit_distant in $(git log --pretty=format:%H $source..$cible); do
	
	cible_patch_id=$(git show $commit_distant | git patch-id | awk '{print $1}')

	git log -1 --oneline $commit_distant |cat

	for comithash in $(git log --pretty=format:%H $source | head -n$max_hist); do
		if git show ${comithash} | git patch-id | grep "^$cible_patch_id" &> /dev/null; then
			echo "$cible_patch_id trouvé : $comithash"
			break
		fi
	done

done