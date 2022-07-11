#!/usr/bin/env bash

set -euo pipefail

RED="31"
GREEN="32"
BOLDRED="\e[1;${RED}m"
BOLDGREEN="\e[1;${GREEN}m"
ENDCOLOR="\e[0m"

DEPENDENCIES=./.deps
ALACRITTY_DIR=${DEPENDENCIES}/alacritty
POLYBAR_DIR=${DEPENDENCIES}/polybar
POWERLEVEL10K_DIR=${DEPENDENCIES}/powerlevel10k
NEOVIM_DIR=${DEPENDENCIES}/neovim
FONTS_DIR=${DEPENDENCIES}/fonts
BTOP_DIR=${DEPENDENCIES}/btop
NVIM_DIR=${DEPENDENCIES}/nvim
TMUX_DIR=${DEPENDENCIES}/tmux
LAZYGIT_DIR=${DEPENDENCIES}/lazygit
I3_GAPS=${DEPENDENCIES}/i3-gaps
XCB_DIR=${DEPENDENCIES}/xcb

ALACRITTY_CONFIG=$(realpath ~/.config/alacritty)
ROFI_CONFIG=$(realpath ~/.config/rofi)
RANGER_CONFIG=$(realpath ~/.config/ranger)
TMUX_CONFIG=$(realpath ~/.tmux.conf)
I3_CONFIG=$(realpath ~/.config/i3)
NITROGEN_CONFIG=$(realpath ~/.config/nitrogen)
POLYBAR_CONFIG=$(realpath ~/.config/polybar)

DEFAULT_BG=./wallpapers/bg_1.jpg
WALLPAPERS_STORAGE=/usr/local/share/wallpapers

function generate_backup() {
    local path=$1

    if [[ -d "${path}" ]]; then
        echo -e "${BOLDGREEN}generating backup "${path}"...${ENDCOLOR}"}

        local dirname=$(dirname ${path})
        local basename=$(basename ${path})
        local index=$(find ${dirname} -maxdepth 1 -iname "${basename}*" | wc -l)
        cp -r ${path} ${path}.bak.${index}
    fi
}

function install_required_packages() {
    sudo apt update -y
    sudo apt install -y \
        libcanberra-gtk-module libcanberra-gtk3-module libjsoncpp-dev build-essential                                \
        xcb libxcb-composite0-dev libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev \
        libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev  \
        libxcb-xrm0 libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev dh-autoreconf unzip git \
        libxcb-xrm-dev x11-xserver-utils compton nitrogen rofi binutils gcc make cmake pkg-config fakeroot python3   \
        python3-xcbgen xcb-proto libxcb-ewmh-dev wireless-tools libiw-dev libasound2-dev libpulse-dev libxcb-shape0  \
        libxcb-shape0-dev libcurl4-openssl-dev libmpdclient-dev pavucontrol python3-pip rxvt-unicode compton         \
        ninja-build meson python3 curl
}

function install_package() {
    local readonly package_name=$1

    echo -e "${BOLDGREEN}installing ${package_name}...${ENDCOLOR}"

    sudo apt install -y "${package_name}"
}

function install_pip_package() {
    local readonly package_name=$1

    echo -e "${BOLDGREEN}installing ${package_name}...${ENDCOLOR}"

    pip install "${package_name}"
}

function install_i3_gaps() {
    echo -e "${BOLDGREEN}installing i3 gaps...${ENDCOLOR}"

    if [[ ! -d "${I3_GAPS}" ]]; then
        git clone https://github.com/Airblader/i3 ${I3_GAPS}
    fi

    pushd "${I3_GAPS}"
        rm -rf build/
        mkdir -p build
        pushd build
            meson --prefix /usr/local
            ninja
            sudo ninja install
        popd
    popd
}

function install_polybar() {
    echo -e "${BOLDGREEN}installing polybar...${ENDCOLOR}"

    sudo apt install cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev \
        libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto \
        libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev \
        libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev \
        libcurl4-openssl-dev libnl-genl-3-dev libuv1-dev

    if [[ ! -d "${POLYBAR_DIR}" ]]; then
        echo -e "${BOLDGREEN}downloading polybar...${ENDCOLOR}"
        git clone --recursive https://github.com/polybar/polybar "${POLYBAR_DIR}"
    fi

    pushd "${POLYBAR_DIR}"
        rm -rf build/
        mkdir build/
        pushd build/
            cmake ..
            make -j$(nproc)
            sudo make install
        popd
    popd
}

function install_rust() {
    echo -e "${BOLDGREEN}installing rustup...${ENDCOLOR}"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source ${HOME}/.cargo/env

    echo -e "${BOLDGREEN}updating rust...${ENDCOLOR}"
    rustup default nightly && rustup update
}

function install_alacritty() {
    echo -e "${BOLDGREEN}installing alacritty...${ENDCOLOR}"

    sudo apt-get install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev \
        autotools-dev automake libncurses-dev

    if [[ ! -d ${ALACRITTY_DIR} ]]; then
        echo -e "${BOLDGREEN}downloading alacritty...${ENDCOLOR}"

        git clone https://github.com/alacritty/alacritty.git ${ALACRITTY_DIR}
    fi

    pushd ${ALACRITTY_DIR}
        cargo build --release
        #infocmp alacritty &> /dev/null
        sudo cp target/release/alacritty /usr/local/bin
    popd
}

function install_btop() {
    echo -e "${BOLDGREEN}installing btop...${ENDCOLOR}"

    mkdir -p "${BTOP_DIR}"
    wget https://github.com/aristocratos/btop/releases/download/v1.1.4/btop-x86_64-linux-musl.tbz -P "${BTOP_DIR}"
    pushd "${BTOP_DIR}"
        tar -xvjf btop-x86_64-linux-musl.tbz
        bash install.sh
    popd
}

function install_dockly() {
    echo -e "${BOLDGREEN}installing dockly...${ENDCOLOR}"

    if ! command -v npm &> /dev/null; then
        curl -o- https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh | sudo bash
        sudo apt-get install -y nodejs
    fi

    sudo npm install -g dockly
}

function install_lazygit() {
    echo -e "${BOLDGREEN}installing lazygit...${ENDCOLOR}"

    mkdir -p "${LAZYGIT_DIR}"
    wget https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz -P "${LAZYGIT_DIR}"
    pushd "${LAZYGIT_DIR}"
        tar -xf lazygit_0.34_Linux_x86_64.tar.gz
        sudo cp lazygit /usr/local/bin
    popd
}

function install_tmux() {
    echo -e "${BOLDGREEN}installing tmux...${ENDCOLOR}"

    sudo apt install -y libevent-dev bison byacc

    if [[ ! -d "${TMUX_DIR}" ]]; then
        git clone https://github.com/tmux/tmux.git "${TMUX_DIR}"
    fi

    pushd "${TMUX_DIR}"
        git checkout 3.2

        sh autogen.sh
        ./configure
        make

        sudo mv tmux /usr/bin
    popd
}

function install_firefox() {
    echo -e "${BOLDGREEN}installing firefox...${ENDCOLOR}"
    wget -O ~/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64"
    sudo tar xjf ~/FirefoxSetup.tar.bz2 -C /opt/
    rm ~/FirefoxSetup.tar.bz2
    sudo mv /usr/bin/firefox /usr/bin/firefox_backup
    sudo ln -s /opt/firefox/firefox /usr/bin/firefox
}

function install_powerlevel10k() {
    echo -e "${BOLDGREEN}installing powerlevel10k...${ENDCOLOR}"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${POWERLEVEL10K_DIR}"
    sudo rm -rf /usr/local/share/powerlevel10k/
    sudo cp -r "${POWERLEVEL10K_DIR}" /usr/local/share/powerlevel10k
    echo "source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
}

function install_bat() {
    echo -e "${BOLDGREEN}installing bat...${ENDCOLOR}"

    wget https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb -P ${DEPENDENCIES}
    sudo dpkg -i ${DEPENDENCIES}/bat_0.18.3_amd64.deb
}

function install_lsd() {
    echo -e "${BOLDGREEN}installing lsd...${ENDCOLOR}"

    wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -P ${DEPENDENCIES}
    sudo dpkg -i ${DEPENDENCIES}/lsd_0.20.1_amd64.deb
}

function install_ueberzug() {
    echo -e "${BOLDGREEN}installing ueberzug...${ENDCOLOR}"

    sudo apt install -y libxext-dev

    pip install -U ueberzug
    sudo pip install -U ueberzug
}

function install_xcb_util_xrm() {
    echo -e "${BOLDGREEN}installing xcb...${ENDCOLOR}"

    git clone --recursive https://github.com/Airblader/xcb-util-xrm.git "${XCB_DIR}"
    pushd "${XCB_DIR}"
        ./autogen.sh
        make
        sudo make install
    popd
}

function install_fonts_awesome() {
    echo -e "${BOLDGREEN}installing fonts awesome...${ENDCOLOR}"

    sudo mkdir -p /usr/share/fonts/opentype
    sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp

    mkdir -p "${FONTS_DIR}"
    pushd "${FONTS_DIR}"
        wget https://use.fontawesome.com/releases/v5.0.13/fontawesome-free-5.0.13.zip
        unzip fontawesome-free-5.0.13.zip
        pushd fontawesome-free-5.0.13
            sudo cp use-on-desktop/* /usr/share/fonts
            sudo fc-cache -f -v
        popd
    popd
}
