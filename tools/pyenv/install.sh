#!/usr/bin/env bash

set -xeu

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    sudo apt install libssl-dev python3-tk libreadline-dev libsqlite3-dev tk-dev
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S tk
fi
