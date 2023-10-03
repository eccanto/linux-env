#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/w3m"

sudo apt install --assume-yes libgc-dev

git clone --depth=1 https://github.com/tats/w3m.git "${TEMPORARY_DIRECORY}"

pushd "${TEMPORARY_DIRECORY}"
    mkdir build
    cd build
    ../configure
    make
    sudo mv w3m /usr/bin/w3m
popd

rm -rf "${TEMPORARY_DIRECORY}"
