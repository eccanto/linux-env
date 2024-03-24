#!/usr/bin/env bash

set -xeu

VERSION=v11.2

TEMPORARY_DIRECORY="$(mktemp -d)/picom"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    sudo apt install --assume-yes meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev  \
        libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev             \
        libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev \
        libevdev-dev uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev libpcre3-dev libxcb-dpms0-dev libepoxy-dev

    git clone --depth=1 --branch "${VERSION}" https://github.com/yshui/picom.git "${TEMPORARY_DIRECORY}"
    rm -rf ~/.config/picom

    pushd "${TEMPORARY_DIRECORY}"
        git submodule update --init --recursive

        meson --buildtype=release . build
        meson configure -Dprefix=/usr build
        ninja -C build
        sudo ninja -C build install
    popd

    rm -rf "${TEMPORARY_DIRECORY}"
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S picom
fi

mkdir -p ~/.config/picom/
cp "${SETTINGS_DIRECTORY}"/* ~/.config/picom/
