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
POLYBAR_DIR=${DEPENDENCIES}/polybar
TERMITE_DIR=${DEPENDENCIES}/termite
BSPWM_CONFIG=~/.config/bspwm
SXHKD_CONFIG=~/.config/sxhkd

# os
sudo apt update

# bspwm
echo -e "${BOLDGREEN}installing dependencies...${ENDCOLOR}"
sudo apt install build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev \
    libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev \
    libxcb-shape0-dev libxcb-ewmh2 make gcc

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
        sudo apt install bspwm
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
    cp -r ./bspwm/* ${BSPWM_CONFIG}
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

# polybar
sudo apt install cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev \
    libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto \
    libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev \
    libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev \
    libcurl4-openssl-dev libnl-genl-3-dev libuv1-dev

if [[ ! -d ${POLYBAR_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading polybar...${ENDCOLOR}"
    git clone --recursive https://github.com/polybar/polybar ${POLYBAR_DIR}
fi

if ! command -v polybar &> /dev/null; then
    echo -e "${BOLDGREEN}installing polybar...${ENDCOLOR}"
    pushd ${POLYBAR_DIR}
        rm -rf build/
        mkdir build/
        pushd build/
            cmake ..
            make -j$(nproc)
            sudo make install
        popd
    popd
fi
