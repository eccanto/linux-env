#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)"

wget "https://download.mozilla.org/?product=firefox-latest&os=linux64" -O "${TEMPORARY_DIRECORY}/FirefoxSetup.tar.bz2"

pushd "${TEMPORARY_DIRECORY}"
    sudo tar xjf FirefoxSetup.tar.bz2 -C /opt/
    sudo mv /usr/bin/firefox /usr/bin/firefox_backup || true
    sudo ln -s /opt/firefox/firefox /usr/bin/firefox
popd

rm -rf "${TEMPORARY_DIRECORY}"
