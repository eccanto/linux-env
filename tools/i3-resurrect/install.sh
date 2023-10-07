#!/usr/bin/env bash

set -xeu

OS_NAME="$(. /etc/os-release; echo "${NAME}")"
OS_VERSION="$(. /etc/os-release; echo "${VERSION_ID}")"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

if [[ "${OS_NAME}" != "Ubuntu" ]]; then
    echo "Unsupported OS"
    exit 1
fi

rm -rf ~/.config/i3-resurrect/

if [[ "${OS_VERSION}" == "23."* ]]; then
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
