#!/usr/bin/env bash

set -xeu

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS="${SCRIPT_PATH}/settings"

rm -rf ~/.fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

pushd ~/.fzf
    ./install
    sudo ln -s -f "$(realpath bin/fzf)" /usr/bin/fzf
popd

sudo pacman -S perl-image-exiftool

sudo cp "${SETTINGS}"/fzf_preview /usr/bin/fzf_preview
