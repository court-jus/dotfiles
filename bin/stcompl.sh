#!/bin/bash

KEY=$(cat ~/.config/syncthing_api_key)
FOLDER="default"
DEVICE=$(cat ~/.config/syncthing_device_id)
HEADER="X-API-Key: ${KEY}"

completion=$(curl -H "${HEADER}" http://127.0.0.1:8080/rest/db/completion\?folder\=${FOLDER}\&device\=${DEVICE} 2> /dev/null | jq ".completion" | cut -c-5)

echo "${completion}%"
