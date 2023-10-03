#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/rofi"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

sudo apt-get install --assume-yes libgtk2.0-dev flex

git clone --depth=1 https://github.com/davatorium/rofi.git "${TEMPORARY_DIRECORY}"
rm -rf ~/.config/rofi/

pushd "${TEMPORARY_DIRECORY}"
    meson setup build
    ninja -C build
    sudo ninja -C build install
popd

mkdir -p ~/.config/rofi/
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/rofi/
sed -i -r "s#USER_HOME#$HOME#g" ~/.config/rofi/config.rasi

echo "run 'rofi-theme-selector' and select nord theme and press 'Alt + a'"
