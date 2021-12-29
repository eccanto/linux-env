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
POWERLEVEL10K_DIR=${DEPENDENCIES}/powerlevel10k
NEOVIM_DIR=${DEPENDENCIES}/neovim
FONTS_DIR=${DEPENDENCIES}/fonts
SLIMLOCK_DIR=${DEPENDENCIES}/slimlock
PICOM_DIR=${DEPENDENCIES}/picom

BSPWM_CONFIG=$(realpath ~/.config/bspwm)
SXHKD_CONFIG=$(realpath ~/.config/sxhkd)
POLYBAR_CONFIG=$(realpath ~/.config/polybar)
PICOM_CONFIG=$(realpath ~/.config/picom)
TERMITE_CONFIG=$(realpath ~/.config/termite)
ROFI_CONFIG=$(realpath ~/.config/rofi)
NVIM_CONFIG=$(realpath ~/.config/nvim)

DEFAULT_BG=./wallpapers/bg_1.jpg
WALLPAPERS_STORAGE=/usr/local/share/wallpapers
