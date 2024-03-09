#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)"

git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git "${TEMPORARY_DIRECORY}"

pushd "${TEMPORARY_DIRECORY}"
    git sparse-checkout add patched-fonts/Hack
    sudo ./install.sh -S

    git sparse-checkout add patched-fonts/NerdFontsSymbolsOnly
    sudo ./install.sh -S
popd

rm -rf "${TEMPORARY_DIRECORY}"
