#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/neofetch"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

git clone --depth=1 https://github.com/dylanaraps/neofetch "${TEMPORARY_DIRECORY}"
rm -rf ~/.config/neofetch/

pushd "${TEMPORARY_DIRECORY}"
    sudo make install
popd

rm -rf "${TEMPORARY_DIRECORY}"

mkdir -p ~/.config/neofetch/
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/neofetch/
sed -i -r "s#USER_HOME#$HOME#g" ~/.config/neofetch/config.conf
