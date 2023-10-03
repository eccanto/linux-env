#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/polybar"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
POLYBAR_SETTINGS="${SCRIPT_PATH}/settings"

sudo apt install --assume-yes cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev \
    libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev              \
    libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev    \
    libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev libuv1-dev python3-xcbgen

if command -v pyenv &> /dev/null; then
    pyenv global system
fi

git clone --depth=1 --recursive https://github.com/polybar/polybar "${TEMPORARY_DIRECORY}"
rm -rf ~/.config/polybar

pushd "${TEMPORARY_DIRECORY}"
    rm -rf build/
    mkdir build/
    pushd build/
        cmake ..
        make -j"$(nproc)"
        sudo make install
    popd
popd

rm -rf "${TEMPORARY_DIRECORY}"

mkdir -p ~/.config/polybar/
cp -r "${POLYBAR_SETTINGS}"/* ~/.config/polybar/
