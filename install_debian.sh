#!/usr/bin/env bash

set -euo pipefail

RED="31"
GREEN="32"
BOLDRED="\e[1;${RED}m"
BOLDGREEN="\e[1;${GREEN}m"
ENDCOLOR="\e[0m"

DEPENDENCIES=./.deps
BSPWM_DIR=${DEPENDENCIES}/bspwm
SXHKD_DIR=${DEPENDENCIES}/sxhkd
TERMITE_DIR=${DEPENDENCIES}/termite
BSPWM_CONFIG=~/.config/bspwm
SXHKD_CONFIG=~/.config/sxhkd


echo -e "${BOLDGREEN}installing dependencies...${ENDCOLOR}"
sudo apt-get install git gcc make xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev \
    libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libxcb-ewmh2 libxcb-shape0-dev

mkdir -p ${DEPENDENCIES}

if [[ ! -d ${BSPWM_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading bspwn...${ENDCOLOR}"
    git clone https://github.com/baskerville/bspwm.git ${BSPWM_DIR}
fi

if [[ ! -d ${SXHKD_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading sxhkd...${ENDCOLOR}"
    git clone https://github.com/baskerville/sxhkd.git ${SXHKD_DIR}
fi

if ! command -v bspwm &> /dev/null; then
    echo -e "${BOLDGREEN}installing bspwm...${ENDCOLOR}"
    pushd ${BSPWM_DIR}
        make
        sudo make install
    popd
fi

if ! command -v sxhkd &> /dev/null; then
    echo -e "${BOLDGREEN}installing sxhkd...${ENDCOLOR}"
    pushd ${SXHKD_DIR}
        make
        sudo make install
    popd
fi

if [[ ! -d ${BSPWM_CONFIG} ]]; then
    echo -e "${BOLDGREEN}configuring bspwm...${ENDCOLOR}"
    mkdir -p ${BSPWM_CONFIG}
    cp ./bspwm/bspwmrc ${BSPWM_CONFIG}
fi

if [[ ! -d ${SXHKD_CONFIG} ]]; then
    echo -e "${BOLDGREEN}configuring sxhkd...${ENDCOLOR}"
    mkdir -p ${SXHKD_CONFIG}
    cp ./sxhkd/sxhkdrc ${SXHKD_CONFIG}
fi

if ! command -v termite &> /dev/null; then
    echo -e "${BOLDGREEN}installing termite...${ENDCOLOR}"
    git clone https://github.com/ls4154/termite-ubuntu.git ${TERMITE_DIR}
    pushd ${TERMITE_DIR}
        bash build.sh
    popd
fi
