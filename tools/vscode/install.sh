#!/usr/bin/env bash

set -xeu

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

source "${SCRIPT_PATH}/../../common.sh"

function install_extensions() {
    echo "installing vscode extensions..."

    xargs -n 1 code --install-extension < "${VSCODE_SETTINGS}/extensions.txt"
}

TEMPORARY_DIRECORY="$(mktemp -d)"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
VSCODE_SETTINGS="${SCRIPT_PATH}/settings"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O "${TEMPORARY_DIRECORY}/vscode-latest.deb"

    pushd "${TEMPORARY_DIRECORY}"
        sudo dpkg -i vscode-latest.deb
    popd

    rm -rf "${TEMPORARY_DIRECORY}"
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S code
fi

mkdir -p ~/.config/Code/User/
cp "${VSCODE_SETTINGS}/settings.json" "${VSCODE_SETTINGS}/keybindings.json" ~/.config/Code/User/

confirm "do you want to install the vscode extensions?" install_extensions
