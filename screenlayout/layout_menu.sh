#!/bin/bash

WORKDIR=${HOME}/.screenlayout/

whattodo_choices() {
    echo "activate"
    echo "set default"
    echo "edit"
}
whattodo() {
    whattodo_choices | dmenu
}

todo=$(whattodo)

layouts() {
    find ${WORKDIR} -type f -not -name ".*" -not -name "*layout_menu.sh" -printf "%f\n" | sed -e "s/\.sh$//g" | sort
}

layout=$(layouts | dmenu)

if [ "${todo}" == "set default" ]; then
    ln -sf ${WORKDIR}/${layout}.sh ${WORKDIR}/default_layout.sh
elif [ "${todo}" == "edit" ]; then
    arandr ${WORKDIR}/${layout}.sh
fi
. ${WORKDIR}/${layout}.sh
