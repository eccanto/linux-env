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
ALACRITTY_DIR=${DEPENDENCIES}/alacritty
POWERLEVEL10K_DIR=${DEPENDENCIES}/powerlevel10k
NEOVIM_DIR=${DEPENDENCIES}/neovim
FONTS_DIR=${DEPENDENCIES}/fonts
SLIMLOCK_DIR=${DEPENDENCIES}/slimlock
PICOM_DIR=${DEPENDENCIES}/picom
BTOP_DIR=${DEPENDENCIES}/btop
NVIM_DIR=${DEPENDENCIES}/nvim
TMUX_DIR=${DEPENDENCIES}/tmux

BSPWM_CONFIG=$(realpath ~/.config/bspwm)
SXHKD_CONFIG=$(realpath ~/.config/sxhkd)
POLYBAR_CONFIG=$(realpath ~/.config/polybar)
PICOM_CONFIG=$(realpath ~/.config/picom)
ALACRITTY_CONFIG=$(realpath ~/.config/alacritty)
ROFI_CONFIG=$(realpath ~/.config/rofi)
RANGER_CONFIG=$(realpath ~/.config/ranger)
TMUX_CONFIG=$(realpath ~/.tmux.conf)

DEFAULT_BG=./wallpapers/bg_1.jpg
WALLPAPERS_STORAGE=/usr/local/share/wallpapers

function gen_backup() {
    local path=$1

    if [[ -d "${path}" ]]; then
        echo -e "${BOLDGREEN}generating backup "${path}"...${ENDCOLOR}"}

        local dirname=$(dirname ${path})
        local basename=$(basename ${path})
        local index=$(find ${dirname} -maxdepth 1 -iname "${basename}*" | wc -l)
        cp -r ${path} ${path}.bak.${index}
    fi
}

