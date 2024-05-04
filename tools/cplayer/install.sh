#!/usr/bin/env bash

set -xeu

if command -v pipx &> /dev/null; then
    if ! command -v cplayer &> /dev/null; then
        pipx install cplayer
    else
        pipx upgrade cplayer
    fi
else
    pip install -U cplayer
fi
