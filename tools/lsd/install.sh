#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    VERSION="1.0.0"
    wget https://github.com/Peltoche/lsd/releases/download/v${VERSION}/lsd_${VERSION}_amd64.deb -P "${TEMPORARY_DIRECORY}"

    pushd "${TEMPORARY_DIRECORY}"
        sudo dpkg -i lsd_${VERSION}_amd64.deb
    popd

    rm -rf "${TEMPORARY_DIRECORY}"
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S lsd
fi
