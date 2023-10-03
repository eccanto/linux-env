#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/neovim"

git clone --depth=1 https://github.com/eccanto/nvim-config.git "${TEMPORARY_DIRECORY}"
rm -rf ~/.config/nvim/
sudo rm -rf /root/.config/nvim/

pushd "${TEMPORARY_DIRECORY}"
    bash install.sh
popd

rm -rf "${TEMPORARY_DIRECORY}"
