#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/rofi"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    VERSION=1.7.5
    sudo apt-get install --assume-yes libgtk2.0-dev flex bison

    git clone --depth=1 --branch "${VERSION}" https://github.com/davatorium/rofi.git "${TEMPORARY_DIRECORY}"

    rm -rf ~/.config/rofi/

    pushd "${TEMPORARY_DIRECORY}"
        git checkout "${VERSION}"

        meson setup build
        ninja -C build
        sudo ninja -C build install
    popd

    rm -rf "${TEMPORARY_DIRECORY}"
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S rofi
fi

mkdir -p ~/.config/rofi/
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/rofi/
sed -i -r "s#USER_HOME#$HOME#g" ~/.config/rofi/config.rasi

echo "run 'rofi-theme-selector' and select nord theme and press 'Alt + a'"
