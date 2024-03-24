#!/usr/bin/env bash

set -xeu

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

rm -rf ~/.config/i3-resurrect/

if command -v pipx &> /dev/null; then
    if ! command -v i3-resurrect &> /dev/null; then
        pipx install i3-resurrect
    else
        pipx upgrade i3-resurrect
    fi
else
    pip install -U i3-resurrect
fi

mkdir -p ~/.config/i3-resurrect/
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/i3-resurrect/
