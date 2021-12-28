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

PICOM_DIR=${DEPENDENCIES}/picom
BSPWM_CONFIG=$(realpath ~/.config/bspwm)
SXHKD_CONFIG=$(realpath ~/.config/sxhkd)
POLYBAR_CONFIG=$(realpath ~/.config/polybar)
PICOM_CONFIG=$(realpath ~/.config/picom)
TERMITE_CONFIG=$(realpath ~/.config/termite)

# os
sudo apt update

mkdir -p ${DEPENDENCIES}

# bspwm
if ! command -v bspwm &> /dev/null; then
    echo -e "${BOLDGREEN}installing bspwm...${ENDCOLOR}"

    sudo apt install build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev \
        libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev \
        libxcb-shape0-dev libxcb-ewmh2 make gcc

    if [[ ! -d ${BSPWM_DIR} ]]; then
        echo -e "${BOLDGREEN}downloading bspwn...${ENDCOLOR}"
        git clone https://github.com/baskerville/bspwm.git ${BSPWM_DIR}
    fi

    pushd ${BSPWM_DIR}
        make
        sudo make install
        sudo apt install bspwm
    popd
fi

if [[ ! -d ${BSPWM_CONFIG} ]]; then
    echo -e "${BOLDGREEN}configuring bspwm...${ENDCOLOR}"
    mkdir -p ${BSPWM_CONFIG}
    cp -r ${BSPWM_DIR}/* ${BSPWM_CONFIG}
    cp -r ./bspwm/* ${BSPWM_CONFIG}
fi

# sxhkd
if ! command -v sxhkd &> /dev/null; then
    echo -e "${BOLDGREEN}installing sxhkd...${ENDCOLOR}"

    if [[ ! -d ${SXHKD_DIR} ]]; then
        echo -e "${BOLDGREEN}downloading sxhkd...${ENDCOLOR}"
        git clone https://github.com/baskerville/sxhkd.git ${SXHKD_DIR}
    fi

    pushd ${SXHKD_DIR}
        make
        sudo make install
    popd
fi

if [[ ! -d ${SXHKD_CONFIG} ]]; then
    echo -e "${BOLDGREEN}configuring sxhkd...${ENDCOLOR}"
    mkdir -p ${SXHKD_CONFIG}
    cp ./sxhkd/sxhkdrc ${SXHKD_CONFIG}

    echo -e "\n# Custom move/resize\nalt + super + {Left,Down,Up,Right}\n    ${BSPWM_CONFIG}/scripts/bspwm_resize {west,south,north,east}" >> ${SXHKD_CONFIG}/sxhkdrc
fi

# polybar
if ! command -v polybar &> /dev/null; then
    echo -e "${BOLDGREEN}installing polybar...${ENDCOLOR}"

    sudo apt install cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev \
        libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto \
        libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev \
        libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev \
        libcurl4-openssl-dev libnl-genl-3-dev libuv1-dev

    if [[ ! -d ${POLYBAR_DIR} ]]; then
        echo -e "${BOLDGREEN}downloading polybar...${ENDCOLOR}"
        git clone --recursive https://github.com/polybar/polybar ${POLYBAR_DIR}
    fi

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

if [[ ! -d ${POLYBAR_CONFIG}/scripts ]]; then
    echo -e "${BOLDGREEN}configuring polybar...${ENDCOLOR}"

    mkdir -p ${POLYBAR_CONFIG}

    echo -e "${BOLDGREEN}configuring polybar settings...${ENDCOLOR}"
    cp -r ./polybar/* ${POLYBAR_CONFIG}
    echo "${POLYBAR_CONFIG}/launch.sh" >> ${BSPWM_CONFIG}/bspwmrc

    echo -e "${BOLDGREEN}configuring polybar fonts...${ENDCOLOR}"
    sudo cp -r ./polybar/fonts/* /usr/share/fonts/truetype/

    fc-cache -v
    pkill -USR1 -x sxhkd || true
fi

# Picom
if ! command -v picom &> /dev/null; then
    echo -e "${BOLDGREEN}installing picom...${ENDCOLOR}"

    sudo apt install meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
        libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev \
        libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev \
        libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev \
        uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev

    if [[ ! -d ${PICOM_DIR} ]]; then
        echo -e "${BOLDGREEN}downloading picom...${ENDCOLOR}"
        git clone https://github.com/ibhagwan/picom.git ${PICOM_DIR}
        pushd ${PICOM_DIR}
            git submodule update --init --recursive
        popd
    fi

    pushd ${PICOM_DIR}
        meson --buildtype=release . build
        ninja -C build
        sudo ninja -C build install
    popd
fi

if [[ ! -d ${PICOM_CONFIG} ]]; then
    echo -e "${BOLDGREEN}configuring picom...${ENDCOLOR}"
    mkdir -p ${PICOM_CONFIG}
    cp ./picom/* ${PICOM_CONFIG}

    echo 'picom --experimental-backends -b' >> ${BSPWM_CONFIG}/bspwmrc
    echo 'bspc config border_width 0' >> ${BSPWM_CONFIG}/bspwmrc
fi

# termite
if ! command -v termite &> /dev/null; then
    echo -e "${BOLDGREEN}installing termite...${ENDCOLOR}"

    git clone https://github.com/ls4154/termite-ubuntu.git ${TERMITE_DIR}
    pushd ${TERMITE_DIR}
        bash build.sh
    popd
fi

if [[ ! -d ${TERMITE_CONFIG} ]]; then
    echo -e "${BOLDGREEN}configuring termite...${ENDCOLOR}"
    mkdir -p ${TERMITE_CONFIG}
    cp ./termite/* ${TERMITE_CONFIG}
fi

# end
echo -e "${BOLDGREEN}\nfinished.${ENDCOLOR}\n"
echo -e "you must reboot the machine and then run the ${BOLDGREEN}\"bash post_install_debian.sh\"${ENDCOLOR} command to complete the installation."
