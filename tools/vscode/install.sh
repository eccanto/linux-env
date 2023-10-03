#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
VSCODE_SETTINGS="${SCRIPT_PATH}/settings"

wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O "${TEMPORARY_DIRECORY}/vscode-latest.deb"

pushd "${TEMPORARY_DIRECORY}"
    sudo dpkg -i vscode-latest.deb
popd

rm -rf "${TEMPORARY_DIRECORY}"

mkdir -p ~/.config/Code/User/
cp "${VSCODE_SETTINGS}/settings.json" "${VSCODE_SETTINGS}/keybindings.json" ~/.config/Code/User/
xargs -n 1 code --install-extension < "${VSCODE_SETTINGS}/extensions.txt"
