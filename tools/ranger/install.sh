#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/ranger"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

sudo apt install --assume-yes dialog

git clone --depth=1 https://github.com/ranger/ranger.git "${TEMPORARY_DIRECORY}"
sudo rm -rf ~/.config/ranger/
sudo rm -rf /root/.config/ranger

pushd "${TEMPORARY_DIRECORY}"
    sudo make install
popd

sudo rm -rf "${TEMPORARY_DIRECORY}"

ranger --copy-config all
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/ranger/
sudo mkdir -p /root/.config
sudo ln -s -f "$(realpath ~/.config/ranger)" /root/.config/ranger

# install plugins
mkdir -p ~/.config/ranger/plugins
if [[ ! -d ~/.config/ranger/plugins/ranger_devicons ]]; then
    git clone --depth=1 https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
fi
