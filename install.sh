#!/usr/bin/env bash

set -eu

function confirm() {
    local message=$1
    local command=$2

    read -r -p "${message} [y/N] " response
    response=${response,,}
    if [[ "$response" =~ ^(yes|y)$ ]]; then
        $command
    fi
}

function install_system_requirements() {
    sudo apt update --assume-yes
    sudo apt install --assume-yes --quiet                                                                             \
        python3 python3-pip python3-venv build-essential ninja-build meson zip unzip git curl feh flameshot tty-clock \
        arandr cargo htop vlc moreutils peek gucharmap keychain

    if ! command -v node &> /dev/null; then
        curl -o- https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh | sudo bash
        sudo apt install --assume-yes nodejs
    fi

    if ! command -v lua &> /dev/null; then
        lua_temporary_direcory="$(mktemp -d)"

        pushd "${lua_temporary_direcory}"
            curl -R -O http://www.lua.org/ftp/lua-5.4.6.tar.gz
            tar zxf lua-5.4.6.tar.gz
            cd lua-5.4.6
            make all test
            sudo make install
        popd

        rm -rf "${lua_temporary_direcory}"
    fi

    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

        if [[ -f "${HOME}/.cargo/env" ]]; then
            # shellcheck disable=SC1091
            source "${HOME}/.cargo/env"
        fi

        rustup default nightly && rustup update
    fi
}

function install_wallpaper() {
    local wallpaper

    wallpaper=$(find ./wallpapers -iname "*.jpg" | fzf --preview "echo 'Set {} as wallpaper'")
    cp "${wallpaper}" ~/.wallpaper.jpg

    i3-msg restart
}

function print_help() {
    echo ""
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Configure linux environment."
    echo ""
    echo "Options:"
    echo "  -t    Tool to install."
    echo "  -l    Show list of available tools."
    echo "  -h    Show this message and exit."
    echo "  -w    Install wallpaper."
    echo ""
    echo "Github: https://github.com/eccanto/linux-env"
}

TOOL=""
INSTALL_WALLPAPER=false
while getopts t:lhw flag; do
    case "${flag}" in
        t)
            TOOL=${OPTARG}
            ;;
        h)
            print_help
            exit 0
            ;;
        w)
            INSTALL_WALLPAPER=true
            ;;
        l)
            echo ""
            echo "$(find tools -maxdepth 1 -mindepth 1 -type d | wc -l) available tools:"
            find tools -maxdepth 1 -mindepth 1 -type d -printf "  - %f\n"
            exit 0
            ;;
        *)
            print_help
            exit 1
            ;;
    esac
done

if [ -n "${TOOL}" ]; then
    if [ -d "./tools/${TOOL}" ]; then
        confirm "do you want to install the system requirements?" install_system_requirements
        confirm "do you want to install ${TOOL}?" "./tools/${TOOL}/install.sh"
    else
        echo "tool ${TOOL} not found"
        exit 1
    fi
elif [[ "${INSTALL_WALLPAPER}" == "true" ]]; then
    install_wallpaper
else
    confirm "do you want to install the system requirements?" install_system_requirements

    bash ./tools/alacritty/install.sh
    bash ./tools/i3/install.sh
    bash ./tools/i3-resurrect/install.sh
    bash ./tools/i3lock/install.sh
    bash ./tools/picom/install.sh
    bash ./tools/polybar/install.sh
    bash ./tools/rofi/install.sh
    bash ./tools/conky/install.sh
    bash ./tools/nerd_font/install.sh
    bash ./tools/zsh/install.sh
    bash ./tools/fzf/install.sh
    bash ./tools/bat/install.sh
    bash ./tools/lsd/install.sh
    bash ./tools/lazygit/install.sh
    bash ./tools/lazydocker/install.sh
    bash ./tools/btop/install.sh
    bash ./tools/bsnotifier/install.sh
    bash ./tools/dunst/install.sh
    bash ./tools/ranger/install.sh
    bash ./tools/w3m/install.sh
    bash ./tools/tmux/install.sh
    bash ./tools/neovim/install.sh
    bash ./tools/vscode/install.sh
    bash ./tools/firefox/install.sh
    bash ./tools/speedtest/install.sh
    bash ./tools/cplayer/install.sh

    install_wallpaper
fi
