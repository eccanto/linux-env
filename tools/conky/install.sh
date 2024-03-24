#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    sudo apt install --assume-yes cmake libimlib2-dev

    git clone --depth=1 https://github.com/brndnmtthws/conky.git "${TEMPORARY_DIRECORY}"
    rm -rf ~/.config/conky

    pushd "${TEMPORARY_DIRECORY}"
        mkdir build
        cd build
        cmake -DCMAKE_INSTALL_PREFIX=/usr ..
        sudo make install
    popd

    rm -rf "${TEMPORARY_DIRECORY}"
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S conky
fi

mkdir -p ~/.config/conky/
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/conky
