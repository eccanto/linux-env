#!/usr/bin/env bash

set -xeu

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    VERSION="0.40.2"
    TEMPORARY_DIRECORY="$(mktemp -d)"

    wget https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_Linux_x86_64.tar.gz \
        -P "${TEMPORARY_DIRECORY}"

    pushd "${TEMPORARY_DIRECORY}"
        tar -xf lazygit_${VERSION}_Linux_x86_64.tar.gz
        sudo cp lazygit /usr/bin
    popd

    rm -rf "${TEMPORARY_DIRECORY}"
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S lazygit
fi
