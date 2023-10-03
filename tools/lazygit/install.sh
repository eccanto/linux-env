#!/usr/bin/env bash

set -xeu

VERSION="0.40.2"
TEMPORARY_DIRECORY="$(mktemp -d)"

wget https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_Linux_x86_64.tar.gz \
    -P "${TEMPORARY_DIRECORY}"

pushd "${TEMPORARY_DIRECORY}"
    tar -xf lazygit_${VERSION}_Linux_x86_64.tar.gz
    sudo cp lazygit /usr/bin
popd

rm -rf "${TEMPORARY_DIRECORY}"
