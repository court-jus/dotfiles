#!/bin/bash

choices() {
    echo devenv
    echo prod
    echo custom
    echo preprod
}

choice=$(choices | dmenu)

ssh "root@player" /etc/citymeo/apply ${choice}
