#!/bin/bash


echo "On origin"
for h in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    echo "Cherche [$h]"
	if git branch -r --contains=$h | grep origin &> /dev/null ; then
        echo "OK, je la supprime"
        git branch -D $h
    else
        echo "Non garde la"
    fi
done

echo "On gitlab"
for h in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    echo "Cherche [$h]"
	if git branch -r --contains=$h | grep gitlab &> /dev/null ; then
        echo "OK, je la supprime"
        git branch -D $h
    else
        echo "Non garde la"
    fi
done

