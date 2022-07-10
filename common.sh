#!/usr/bin/env bash

set -euo pipefail

RED="31"
GREEN="32"
BOLDRED="\e[1;${RED}m"
BOLDGREEN="\e[1;${GREEN}m"
ENDCOLOR="\e[0m"

DEPENDENCIES=./.deps
ALACRITTY_DIR=${DEPENDENCIES}/alacritty
POWERLEVEL10K_DIR=${DEPENDENCIES}/powerlevel10k
NEOVIM_DIR=${DEPENDENCIES}/neovim
FONTS_DIR=${DEPENDENCIES}/fonts
BTOP_DIR=${DEPENDENCIES}/btop
NVIM_DIR=${DEPENDENCIES}/nvim
TMUX_DIR=${DEPENDENCIES}/tmux
LAZYGIT_DIR=${DEPENDENCIES}/lazygit

ALACRITTY_CONFIG=$(realpath ~/.config/alacritty)
ROFI_CONFIG=$(realpath ~/.config/rofi)
RANGER_CONFIG=$(realpath ~/.config/ranger)
TMUX_CONFIG=$(realpath ~/.tmux.conf)

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

