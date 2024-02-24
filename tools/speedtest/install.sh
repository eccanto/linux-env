#!/usr/bin/env bash

set -xeu

OS_NAME="$(. /etc/os-release; echo $NAME)"
OS_VERSION="$(. /etc/os-release; echo $VERSION_ID)"

if command -v pipx &> /dev/null; then
    if ! command -v speedtest-cli &> /dev/null; then
        pipx install speedtest-cli
    else
        pipx upgrade speedtest-cli
    fi
else
    pip install -U speedtest-cli
fi
