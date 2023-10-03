#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/i3lock"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
I3LOCK_EXECUTABLE="${SCRIPT_PATH}/settings/lock.sh"

sudo apt install --assume-yes autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev \
    libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev \
    libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

git clone --depth=1 https://github.com/Raymo111/i3lock-color.git "${TEMPORARY_DIRECORY}"

pushd "${TEMPORARY_DIRECORY}"
    ./build.sh
    ./install-i3lock-color.sh
popd

rm -rf "${TEMPORARY_DIRECORY}"

sudo cp "${I3LOCK_EXECUTABLE}" /usr/bin/lock
