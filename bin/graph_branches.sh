#!/bin/bash

cible=$1

(echo "digraph G {"

for branch in $(git for-each-ref --format='%(refname)' refs/remotes/origin/${cible}); do
	echo -n "  \"stable-6\" -> "
	for hash in $(git log --reverse --pretty=format:%h origin/stable-6..${branch}); do
		echo -n "\"$hash\" -> "
	done
	echo "\""$(echo -n "$branch" | cut -d/ -f5)"\";"
done

echo "}") > $(echo $cible | tr "/" "_").dot