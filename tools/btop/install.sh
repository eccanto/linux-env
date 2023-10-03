#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/btop"

git clone --depth=1 https://github.com/aristocratos/btop.git "${TEMPORARY_DIRECORY}"
sudo rm -rf /usr/local/bin/btop

pushd "${TEMPORARY_DIRECORY}"
    make
    sudo PREFIX=/usr make install
popd

rm -rf "${TEMPORARY_DIRECORY}"
