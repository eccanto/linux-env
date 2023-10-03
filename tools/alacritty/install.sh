#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/alacritty"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

sudo apt-get install --assume-yes cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev \
    libxkbcommon-dev autotools-dev automake libncurses-dev

git clone --depth=1 https://github.com/alacritty/alacritty.git "${TEMPORARY_DIRECORY}"
rm -rf ~/.config/alacritty/

pushd "${TEMPORARY_DIRECORY}"
    cargo build --release
    sudo rm -f /usr/local/bin/alacritty
    sudo cp target/release/alacritty /usr/local/bin
popd

rm -rf "${TEMPORARY_DIRECORY}"

mkdir -p ~/.config/alacritty/
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/alacritty/
