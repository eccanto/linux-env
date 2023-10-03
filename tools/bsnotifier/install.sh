#!/usr/bin/env bash

set -xeu

OS_NAME="$(. /etc/os-release; echo "${NAME}")"
OS_VERSION="$(. /etc/os-release; echo "${VERSION_ID}")"

if [[ "${OS_NAME}" != "Ubuntu" ]]; then
    echo "Unsupported OS"
    exit 1
fi

if [[ "${OS_VERSION}" == "23."* ]]; then
    if ! command -v bsnotifier &> /dev/null; then
        pipx install bsnotifier
    else
        pipx upgrade bsnotifier
    fi
else
    pip install -U bsnotifier
fi

BSNOTIFIER_PATH="$(which bsnotifier)"
sudo ln -fs "${BSNOTIFIER_PATH}" /usr/bin/bsnotifier
