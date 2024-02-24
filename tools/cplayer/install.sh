#!/usr/bin/env bash

set -xeu

OS_NAME="$(. /etc/os-release; echo $NAME)"
OS_VERSION="$(. /etc/os-release; echo $VERSION_ID)"

if command -v pipx &> /dev/null; then
    if ! command -v cplayer &> /dev/null; then
        pipx install cplayer
    else
        pipx upgrade cplayer
    fi
else
    pip install -U cplayer
fi
