#!/usr/bin/env bash

set -euo pipefail

RED="31"
GREEN="32"
BOLDRED="\e[1;${RED}m"
BOLDGREEN="\e[1;${GREEN}m"
ENDCOLOR="\e[0m"

DEPENDENCIES=./.deps
BSPWM_CONFIG=$(realpath ~/.config/bspwm)
FONTS_DIR=${DEPENDENCIES}/fonts
DEFAULT_BG=./wallpapers/mountain.jpg
WALLPAPERS_STORAGE=/usr/local/share/wallpapers

# Hack Nerd Fonts
if ! ls /usr/local/share/fonts/Hack*.ttf &> /dev/null; then
    echo -e "${BOLDGREEN}installing Hack Nerd Fonts...${ENDCOLOR}"

    mkdir -p ${FONTS_DIR}
    pushd ${FONTS_DIR}
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
        sudo mv Hack.zip /usr/local/share/fonts/
        cd /usr/local/share/fonts/
        sudo unzip Hack.zip
        sudo rm Hack.zip
    popd
    fc-cache -v
fi

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

# feh
if ! command -v feh &> /dev/null; then
    echo -e "${BOLDGREEN}installing wallpapers...${ENDCOLOR}"
    sudo apt install feh
    sudo mkdir -p ${WALLPAPERS_STORAGE}
    sudo cp ${DEFAULT_BG} ${WALLPAPERS_STORAGE}

    echo -e "\n# background\nfeh --bg-fill ${WALLPAPERS_STORAGE}/$(basename ${DEFAULT_BG})" >> ${BSPWM_CONFIG}/bspwmrc
    pkill -USR1 -x sxhkd || true
fi
