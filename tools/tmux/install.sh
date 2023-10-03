#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/tmux"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
CONFIGURATION_PATH="${SCRIPT_PATH}/settings/tmux.conf"

sudo apt install --assume-yes libevent-dev ncurses-dev bison byacc

git clone --depth=1 https://github.com/tmux/tmux.git "${TEMPORARY_DIRECORY}"
rm -rf ~/.tmux

pushd "${TEMPORARY_DIRECORY}"
    sh autogen.sh
    ./configure
    make

    sudo mv tmux /usr/bin
popd

cp "${CONFIGURATION_PATH}" ~/.tmux.conf
sudo ln -s -f ~/.tmux.conf /root/.tmux.conf

git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
