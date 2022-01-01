#!/usr/bin/env bash

set -euo pipefail

source common.sh

# os
sudo apt update -y

mkdir -p ${DEPENDENCIES}

# bspwm
if ! command -v bspwm &> /dev/null; then
    echo -e "${BOLDGREEN}installing bspwm...${ENDCOLOR}"

    sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev \
        libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev \
        libxcb-shape0-dev libxcb-ewmh2 make gcc

    if [[ ! -d ${BSPWM_DIR} ]]; then
        echo -e "${BOLDGREEN}downloading bspwn...${ENDCOLOR}"
        git clone https://github.com/baskerville/bspwm.git ${BSPWM_DIR}
    fi

    pushd ${BSPWM_DIR}
        make
        sudo make install
        sudo apt install -y bspwm
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
    echo -e "\n# Polybar menu\nsuper + q\n    bash ${POLYBAR_CONFIG}/scripts/powermenu_alt" >> ${SXHKD_CONFIG}/sxhkdrc
fi

# polybar
if ! command -v polybar &> /dev/null; then
    echo -e "${BOLDGREEN}installing polybar...${ENDCOLOR}"

    sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev \
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

    sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
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

# rustup
if [[ -f ${HOME}/.cargo/env ]]; then
    source ${HOME}/.cargo/env
fi

if ! command -v rustup; then
    echo -e "${BOLDGREEN}installing rustup...${ENDCOLOR}"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source ${HOME}/.cargo/env
fi

# update rust
echo -e "${BOLDGREEN}updating rust...${ENDCOLOR}"
rustup default nightly && rustup update

# alacritty
if ! command -v alacritty &> /dev/null; then
    echo -e "${BOLDGREEN}installing alacritty...${ENDCOLOR}"

    sudo apt-get install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev \
        libxcb-xfixes0-dev libxkbcommon-dev python3 cargo

    if [[ ! -d ${ALACRITTY_DIR} ]]; then
        echo -e "${BOLDGREEN}downloading alacritty...${ENDCOLOR}"

        git clone https://github.com/alacritty/alacritty.git ${ALACRITTY_DIR}
    fi

    pushd ${ALACRITTY_DIR}
        cargo build --release
        infocmp alacritty &> /dev/null
        sudo cp target/release/alacritty /usr/local/bin
    popd

    cp ./alacritty/* ${ALACRITTY_CONFIG}
fi

if [[ ! -d ${ALACRITTY_CONFIG} ]]; then
    echo -e "${BOLDGREEN}configuring alacritty...${ENDCOLOR}"
    mkdir -p ${ALACRITTY_CONFIG}
    cp ./alacritty/* ${ALACRITTY_CONFIG}/
fi

# end
echo -e "${BOLDGREEN}\nfinished.${ENDCOLOR}\n"
echo -e "you must reboot the machine and then run the ${BOLDGREEN}\"bash post_install_debian.sh\"${ENDCOLOR} command to complete the installation."
