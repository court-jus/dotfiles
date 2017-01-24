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

echo "On redmine"
for h in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    echo "Cherche [$h]"
	if git branch -r --contains=$h | grep redmine &> /dev/null ; then
        echo "OK, je la supprime"
        git branch -D $h
    else
        echo "Non garde la"
    fi
done

