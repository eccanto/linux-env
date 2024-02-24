#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/dunst"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
DUNST_CONFIG_FILE="${SCRIPT_PATH}/settings"

sudo apt install --assume-yes libnotify-dev libwayland-dev wayland-protocols libxss-dev

git clone https://github.com/dunst-project/dunst.git "${TEMPORARY_DIRECORY}"
rm -rf ~/.config/dunst/

pushd "${TEMPORARY_DIRECORY}"
    make PREFIX=/usr
    sudo make PREFIX=/usr install
popd

rm -rf "${TEMPORARY_DIRECORY}"

mkdir -p ~/.config/dunst/
cp -r "${DUNST_CONFIG_FILE}"/* ~/.config/dunst/
