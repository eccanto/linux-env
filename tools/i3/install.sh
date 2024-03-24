#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/i3"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    sudo apt install --assume-yes light python3-i3ipc libanyevent-i3-perl libxcb-xkb-dev libstartup-notification0-dev  \
        libxcb-xinerama0-dev libxcb-randr0-dev libxcb-util-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-icccm4-dev \
        libxcb-xrm-dev libxkbcommon-x11-dev libyajl-dev libpcre2-dev libcairo2-dev librust-pangocairo-dev libev4 libev-dev

    git clone --depth=1 https://github.com/i3/i3 "${TEMPORARY_DIRECORY}"
    rm -rf ~/.config/i3/

    pushd "${TEMPORARY_DIRECORY}"
        rm -rf build/
        mkdir -p build/
        pushd build/
            meson --prefix /usr
            ninja
            sudo ninja install
        popd
    popd

    rm -rf "${TEMPORARY_DIRECORY}"
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S i3-wm
fi

mkdir -p ~/.config/i3/
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/i3/
sed -i -r "s#USER_HOME#$HOME#g" ~/.config/i3/config

sudo ln -s -f "$(realpath "${HOME}/.config/i3/i3_tab_switcher.py")" /usr/bin/i3_tab_switcher
