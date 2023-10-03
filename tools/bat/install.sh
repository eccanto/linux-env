#!/usr/bin/env bash

set -xeu

VERSION=0.23.0
TEMPORARY_DIRECORY="$(mktemp -d)"

wget https://github.com/sharkdp/bat/releases/download/v${VERSION}/bat_${VERSION}_amd64.deb -P "${TEMPORARY_DIRECORY}"
sudo dpkg -i "${TEMPORARY_DIRECORY}/bat_${VERSION}_amd64.deb"

rm -rf "${TEMPORARY_DIRECORY}"
