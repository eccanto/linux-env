#!/usr/bin/env bash

set -xeu

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    VERSION=0.23.0
    TEMPORARY_DIRECORY="$(mktemp -d)"

    wget https://github.com/sharkdp/bat/releases/download/v${VERSION}/bat_${VERSION}_amd64.deb -P "${TEMPORARY_DIRECORY}"
    sudo dpkg -i "${TEMPORARY_DIRECORY}/bat_${VERSION}_amd64.deb"

    rm -rf "${TEMPORARY_DIRECORY}"
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S bat
fi
