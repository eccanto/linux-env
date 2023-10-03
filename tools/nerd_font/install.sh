#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)"

git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts "${TEMPORARY_DIRECORY}"

pushd "${TEMPORARY_DIRECORY}"
    git sparse-checkout add patched-fonts/Hack
    sudo ./install.sh -S
popd

rm -rf "${TEMPORARY_DIRECORY}"
