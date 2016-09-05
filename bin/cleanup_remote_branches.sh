#!/bin/bash

git fetch --prune
git fetch --all

for h in $(git for-each-ref --format='%(refname:short)' refs/remotes/origin/); do
	if git branch -r --contains=$h | grep origin | grep -v "^  $h" &> /dev/null ; then
        echo "gwh $h"
        echo "git push origin :$(echo $h | sed -e "s/^origin\///")"
    fi
done

