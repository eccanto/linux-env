#!/usr/bin/env bash

set -xeu

VERSION="1.0.0"
TEMPORARY_DIRECORY="$(mktemp -d)"

wget https://github.com/Peltoche/lsd/releases/download/v${VERSION}/lsd_${VERSION}_amd64.deb -P "${TEMPORARY_DIRECORY}"

pushd "${TEMPORARY_DIRECORY}"
    sudo dpkg -i lsd_${VERSION}_amd64.deb
popd

rm -rf "${TEMPORARY_DIRECORY}"
