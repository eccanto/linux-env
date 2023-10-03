#!/usr/bin/env bash

set -xeu

rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

pushd ~/.fzf
    ./install
    sudo ln -s -f "$(realpath bin/fzf)" /usr/bin/fzf
popd
