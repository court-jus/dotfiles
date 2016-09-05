#!/bin/bash

DEFAULT_BR="branches/version-3.2"

svn up
if svn st --ignore-externals | grep -v "^X" | grep . ; then
    echo "Modifications locales. Merge automatique interdit"
    read -p "Reverter ? [O/n]" reponse
    if [ "$reponse" == "o" ] || [ "$reponse" == "O" ] || [ "$reponse" == "" ]; then
        svn revert -R .
    else
        exit
    fi
elif [ $# -lt 1 ] ; then
    echo "Pas de numero de commit fourni en parametre"
    exit
elif [ $# -lt 2 ] ; then
    echo "Pas de depot fourni, on suppose que c'est $DEFAULT_BR"
    commit=$1
    branche=$DEFAULT_BR
else
    commit=$1
    branche=$2
fi
svn merge -c $1 svn+ssh://rocco/svn/MCA3/$branche
if svn st --ignore-externals | grep -v "^X" | grep . ; then
    read -p "Voir le diff ? [o/N]" reponse
    if [ "$reponse" == "o" ] || [ "$reponse" == "O" ] ; then
        svn diff
    fi

    read -p "Commiter ? [O/n]" reponse
    if [ "$reponse" == "o" ] || [ "$reponse" == "O" ] || [ "$reponse" == "" ]; then
        svn ci -m report
    fi
else
    echo "Bah rien n'a change, vous etes sur qu'il existe votre commit numero $commit ?"
fi
