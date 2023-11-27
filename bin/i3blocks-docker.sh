#!/bin/bash

webapp_up() {
    sudo nmap -sS $(docker_ip webapp) -p 8000 | grep "^8000/tcp open" > /dev/null 2>&1
}

dck_is_running() {
    running=$(docker inspect --format='{{.State.Running}}' "$1")
    [ "${running}" = "true" ]
}

docker_status() {
    for container in "webapp" "frontend" "worker"
    do
        container_name="devenv_${container}_1"
        color="red"
        if dck_is_running ${container_name}
        then
            color="lightgreen"
        fi
        echo -n "<span font_desc='Fira Code Regular' foreground='${color}'>⬤</span>"
    done
}

while true
do
    output=""
    sleep 3
    echo
    if webapp_up
    then
        output="${output}<span font_desc='Fira Code Regular' foreground='green'>🌐</span>"
    else
        output="${output}<span font_desc='Fira Code Regular' foreground='red'>⬤</span>"
    fi
    echo "${output}$(docker_status)"
done
