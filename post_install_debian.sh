#!/usr/bin/env bash

set -euo pipefail

RED="31"
GREEN="32"
BOLDRED="\e[1;${RED}m"
BOLDGREEN="\e[1;${GREEN}m"
ENDCOLOR="\e[0m"

DEPENDENCIES=./.deps
FONTS_DIR=${DEPENDENCIES}/fonts

# Hack Nerd Fonts
echo -e "${BOLDGREEN}installing Hack Nerd Fonts...${ENDCOLOR}"

mkdir -p ${FONTS_DIR}
pushd ${FONTS_DIR}
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
    mv Hack.zip /usr/local/share/fonts/
    cd /usr/local/share/fonts/
    unzip Hack.zip
    rm Hack.zip
popd

fc-cache -v

# firefox latest
if ! command -v firefox &> /dev/null; then  # TODO -> verify version!!!
    echo -e "${BOLDGREEN}installing firefox...${ENDCOLOR}"
    wget -O ~/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64"
    sudo tar xjf ~/FirefoxSetup.tar.bz2 -C /opt/
    rm ~/FirefoxSetup.tar.bz2
    sudo mv /usr/bin/firefox /usr/bin/firefox_backup
    sudo ln -s /opt/firefox/firefox /usr/bin/firefox
fi

# firejail
if ! command -v firejail &> /dev/null; then
    echo -e "${BOLDGREEN}installing firejail...${ENDCOLOR}"
    sudo apt install firejail
fi
