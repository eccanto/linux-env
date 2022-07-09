#!/usr/bin/env bash

set -euo pipefail

source common.sh

# os
sudo apt update -y
sudo apt install -y python3-pip curl

mkdir -p ${DEPENDENCIES}

# bspwm
if [[ ! -d ${BSPWM_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading bspwm...${ENDCOLOR}"
    git clone https://github.com/baskerville/bspwm.git ${BSPWM_DIR}
fi

if ! command -v bspwm &> /dev/null; then
    echo -e "${BOLDGREEN}installing bspwm...${ENDCOLOR}"

    sudo apt install -y build-essential git vim xcb libxcb-util0-dev libxcb-ewmh-dev libxcb-randr0-dev \
        libxcb-icccm4-dev libxcb-keysyms1-dev libxcb-xinerama0-dev libasound2-dev libxcb-xtest0-dev \
        libxcb-shape0-dev libxcb-ewmh2 make gcc

    pushd ${BSPWM_DIR}
        make
        sudo make install
        sudo apt install -y bspwm
    popd
fi

gen_backup ${BSPWM_CONFIG}

echo -e "${BOLDGREEN}configuring bspwm...${ENDCOLOR}"
mkdir -p ${BSPWM_CONFIG}
cp -r ${BSPWM_DIR}/* ${BSPWM_CONFIG}
cp -r ./bspwm/* ${BSPWM_CONFIG}

# sxhkd
if [[ ! -d ${SXHKD_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading sxhkd...${ENDCOLOR}"
    git clone https://github.com/baskerville/sxhkd.git ${SXHKD_DIR}
fi

if ! command -v sxhkd &> /dev/null; then
    echo -e "${BOLDGREEN}installing sxhkd...${ENDCOLOR}"

    pushd ${SXHKD_DIR}
        make
        sudo make install
    popd
fi

gen_backup ${SXHKD_CONFIG}

echo -e "${BOLDGREEN}configuring sxhkd...${ENDCOLOR}"
mkdir -p ${SXHKD_CONFIG}
cp ./sxhkd/sxhkdrc ${SXHKD_CONFIG}

echo -e "\n# Custom move/resize\nalt + super + {Left,Down,Up,Right}\n    ${BSPWM_CONFIG}/scripts/bspwm_resize {west,south,north,east}" >> ${SXHKD_CONFIG}/sxhkdrc
echo -e "\n# Polybar menu\nsuper + q\n    bash ${POLYBAR_CONFIG}/scripts/powermenu_alt" >> ${SXHKD_CONFIG}/sxhkdrc

# polybar
if [[ ! -d ${POLYBAR_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading polybar...${ENDCOLOR}"

    git clone --recursive https://github.com/polybar/polybar ${POLYBAR_DIR}
fi

if ! command -v polybar &> /dev/null; then
    echo -e "${BOLDGREEN}installing polybar...${ENDCOLOR}"

    sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev \
        libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto \
        libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev \
        libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev \
        libcurl4-openssl-dev libnl-genl-3-dev libuv1-dev python3-xcbgen puredata-core

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

gen_backup ${POLYBAR_CONFIG}

echo -e "${BOLDGREEN}configuring polybar...${ENDCOLOR}"
mkdir -p ${POLYBAR_CONFIG}

cp -r ./polybar/* ${POLYBAR_CONFIG}
echo "${POLYBAR_CONFIG}/launch.sh" >> ${BSPWM_CONFIG}/bspwmrc

echo -e "${BOLDGREEN}configuring polybar fonts...${ENDCOLOR}"
sudo cp -r ./polybar/fonts/* /usr/share/fonts/truetype/

fc-cache -v
pkill -USR1 -x sxhkd || true

# Picom
if [[ ! -d ${PICOM_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading picom...${ENDCOLOR}"

    git clone https://github.com/ibhagwan/picom.git ${PICOM_DIR}
    pushd ${PICOM_DIR}
        git submodule update --init --recursive
    popd
fi

if ! command -v picom &> /dev/null; then
    echo -e "${BOLDGREEN}installing picom...${ENDCOLOR}"

    sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev \
        libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev \
        libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev \
        libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev \
        uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev

    pushd ${PICOM_DIR}
        meson --buildtype=release . build
        ninja -C build
        sudo ninja -C build install
    popd
fi

gen_backup ${PICOM_CONFIG}

echo -e "${BOLDGREEN}configuring picom...${ENDCOLOR}"
mkdir -p ${PICOM_CONFIG}
cp ./picom/* ${PICOM_CONFIG}

echo 'picom --experimental-backends -b' >> ${BSPWM_CONFIG}/bspwmrc
echo 'bspc config border_width 0' >> ${BSPWM_CONFIG}/bspwmrc

MONITOR_CNF='
# monitor
monitors=( "HDMI-1" "HDMI-0" "DVI-D-1" "DVI-0" "DVI-1" "VGA1" "LVDS1" "LVDS-1" )
# (Order is important. More important monitors first. (Like if VGA1 is attached to
#  laptop, it should be the main monitor, not LVDS1, so VGA1 is before LVDS1.))
i=1
for m in ${monitors[@]}; do
    if bspc query -M | grep "$m"; then
        bspc monitor $m -d $i-{1..9}
        if [[ "$i" -eq 1 ]]; then
            xrandr --output $m --primary
        fi
        let i++
    fi
done
'

echo "${MONITOR_CNF}" >> ${BSPWM_CONFIG}/bspwmrc

# cargo
if ! command -v cargo; then
    sudo apt-get install -y cargo
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
fi

if [[ ! -d ${ALACRITTY_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading alacritty...${ENDCOLOR}"

    git clone https://github.com/alacritty/alacritty.git ${ALACRITTY_DIR}
fi

if ! command -v alacritty &> /dev/null; then
    pushd ${ALACRITTY_DIR}
        cargo build --release
        infocmp alacritty &> /dev/null
        sudo cp target/release/alacritty /usr/local/bin
    popd
fi

gen_backup ${ALACRITTY_CONFIG}

echo -e "${BOLDGREEN}configuring alacritty...${ENDCOLOR}"
mkdir -p ${ALACRITTY_CONFIG}
cp ./alacritty/* ${ALACRITTY_CONFIG}/

# nvlc (command line VLC media player)
if ! command -v nvlc &> /dev/null; then
    echo -e "${BOLDGREEN}installing nvlc (vlc)...${ENDCOLOR}"

    sudo apt install -y vlc
fi

# btop
if ! command -v btop &> /dev/null; then
    echo -e "${BOLDGREEN}installing btop...${ENDCOLOR}"

    mkdir -p ${BTOP_DIR}
    wget https://github.com/aristocratos/btop/releases/download/v1.1.4/btop-x86_64-linux-musl.tbz -P ${BTOP_DIR}
    pushd ${BTOP_DIR}
        tar -xvjf btop-x86_64-linux-musl.tbz
        bash install.sh
    popd
fi

# speedtest-cli
if ! command -v speedtest &> /dev/null; then
    echo -e "${BOLDGREEN}installing speedtest...${ENDCOLOR}"

    pip install speedtest-cli
fi

# dockly
if ! command -v dockly &> /dev/null; then
    echo -e "${BOLDGREEN}installing dockly...${ENDCOLOR}"

    if ! command -v npm &> /dev/null; then
        curl -o- https://deb.nodesource.com/setup_17.x -o nodesource_setup.sh | sudo bash
        sudo apt-get install -y nodejs npm
    fi

    sudo npm install -g dockly
fi

# lazygit
if ! command -v lazygit &> /dev/null; then
    echo -e "${BOLDGREEN}installing lazygit...${ENDCOLOR}"

    mkdir -p ${LAZYGIT_DIR}
    wget https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz -P ${LAZYGIT_DIR}
    pushd ${LAZYGIT_DIR}
        tar -xf lazygit_0.34_Linux_x86_64.tar.gz
        sudo cp lazygit /usr/local/bin
    popd
fi

# tmux
if ! command -v tmux &> /dev/null; then
    echo -e "${BOLDGREEN}installing tmux...${ENDCOLOR}"

    sudo apt install -y libevent-dev bison byacc

    if [[ ! -d ${TMUX_DIR} ]]; then
        git clone https://github.com/tmux/tmux.git ${TMUX_DIR}
    fi

    pushd ${TMUX_DIR}
        git checkout 3.2

        sh autogen.sh
        ./configure
        make

        sudo mv tmux /usr/bin
    popd
fi

if [[ ! -f "${TMUX_CONFIG}" ]]; then
    echo -e "${BOLDGREEN}configuring tmux...${ENDCOLOR}"

    cp ./tmux/tmux.conf "${TMUX_CONFIG}"
    sudo ln -s -f "${TMUX_CONFIG}" /root/.tmux.conf
fi

# end
echo -e "${BOLDGREEN}\nfinished.${ENDCOLOR}\n"
echo -e "you must reboot the machine and then run the ${BOLDGREEN}\"bash step_2_install_debian.sh\"${ENDCOLOR} command to complete the installation."
