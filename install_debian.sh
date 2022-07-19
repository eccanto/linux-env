#!/usr/bin/env bash

set -euo pipefail

source common.sh

# os
install_required_packages

mkdir -p ${DEPENDENCIES}

# i3-gaps
if ! command -v i3; then
    install_i3_gaps
fi

if [[ ! -d "${I3_CONFIG}" ]]; then
    echo -e "${BOLDGREEN}configuring i3-gaps...${ENDCOLOR}"

    mkdir -p "${I3_CONFIG}"
    cp "${I3_SETTINGS_DIR}"/* "${I3_CONFIG}"/
fi

# polybar
if ! command -v polybar &> /dev/null; then
    install_polybar
fi

if [[ ! -d "${POLYBAR_CONFIG}" ]]; then
    echo -e "${BOLDGREEN}configuring polybar...${ENDCOLOR}"

    mkdir -p "${POLYBAR_CONFIG}"
    cp "${POLYBAR_SETTINGS_DIR}"/* ${POLYBAR_CONFIG}/
fi

# picom
if ! command -v polybar &> /dev/null; then
    install_picom
fi

generate_backup ${PICOM_CONFIG}

echo -e "${BOLDGREEN}configuring picom...${ENDCOLOR}"
mkdir -p ${PICOM_CONFIG}
cp "${PICOM_SETTINGS_DIR}"/* ${PICOM_CONFIG}

if ! grep 'picom' "${POLYBAR_CONFIG}"/i3wmthemer_bar_launch.sh; then
    echo "picom --experimental-backends -b" >> "${POLYBAR_CONFIG}"/i3wmthemer_bar_launch.sh
fi

# vscode
if ! command -v code; then
    install_vscode
fi

# feh
if ! command -v feh; then
    install_package feh
fi

# flameshot
if ! command -v flameshot; then
    install_package flameshot;
fi

# i3lock
if ! command -v i3lock; then
    install_package i3lock
fi

# i3lock-color
if [[ ! -d "${I3LOCK_COLOR_CONFIG}" ]]; then
    install_i3lock_color

    mkdir -p "${I3LOCK_COLOR_CONFIG}"
    cp "${I3LOCK_COLOR_SETTINGS_DIR}"/* "${I3LOCK_COLOR_CONFIG}"/

    sudo ln -s "${I3LOCK_COLOR_CONFIG}"/lock.sh /usr/bin/lock
fi

# tty-clock
if ! command -v tty-clock; then
    install_package tty-clock
fi

if ! grep 'feh --bg-fill' "${POLYBAR_CONFIG}"/i3wmthemer_bar_launch.sh; then
    echo "feh --bg-fill ${WALLPAPERS_STORAGE}" >> "${POLYBAR_CONFIG}"/i3wmthemer_bar_launch.sh
fi

# xcb-util-xrm
if [[ ! -d "${XCB_DEPENDENCIES_DIR}" ]]; then
    install_xcb_util_xrm
fi

# fonts awesome
if [[ ! -d "/usr/share/fonts/opentype/scp" ]]; then
    install_fonts_awesome
fi

# dunst
if ! command -v dunst; then
    install_package dunst
fi

if [[ ! -d "${DUNST_CONFIG}" ]]; then
    echo -e "${BOLDGREEN}configuring dunst...${ENDCOLOR}"

    mkdir -p "${DUNST_CONFIG}"
    cp "${DUNST_SETTINGS_DIR}"/* "${DUNST_CONFIG}"/
fi

# arandr
if ! command -v arandr; then
    install_package arandr
fi

# cargo
if ! command -v cargo; then
    install_package cargo
fi

# htop
if ! command -v htop; then
    install_package htop
fi

# rustup
if [[ -f ${HOME}/.cargo/env ]]; then
    source ${HOME}/.cargo/env
fi

if ! command -v rustup; then
    install_rust
fi

# alacritty
if ! command -v alacritty &> /dev/null; then
    install_alacritty
fi

generate_backup ${ALACRITTY_CONFIG}

echo -e "${BOLDGREEN}configuring alacritty...${ENDCOLOR}"
mkdir -p ${ALACRITTY_CONFIG}
cp "${ALACRITTY_SETTINGS_DIR}"/* ${ALACRITTY_CONFIG}/

# nvlc (command line VLC media player)
if ! command -v nvlc &> /dev/null; then
    install_package vlc
fi

# btop
if ! command -v btop &> /dev/null; then
    install_btop
fi

# speedtest-cli
if ! command -v speedtest &> /dev/null; then
    install_pip_package speedtest-cli
fi

# dockly
if ! command -v dockly &> /dev/null; then
    install_dockly
fi

# lazygit
if ! command -v lazygit &> /dev/null; then
    install_lazygit
fi

# tmux
if ! command -v tmux &> /dev/null; then
    install_tmux
fi

if [[ ! -f "${TMUX_CONFIG_FILE}" ]]; then
    echo -e "${BOLDGREEN}configuring tmux...${ENDCOLOR}"

    cp "${TMUX_SETTINGS_FILE}" "${TMUX_CONFIG_FILE}"
    sudo ln -s -f "${TMUX_CONFIG_FILE}" /root/.tmux.conf
fi

# firefox latest
if ! command -v firefox &> /dev/null; then
    install_firefox
fi

# firejail
if ! command -v firejail &> /dev/null; then
    install_package firejail
fi

# rofi
generate_backup ${ROFI_CONFIG}

echo -e "${BOLDGREEN}configuring rofi...${ENDCOLOR}"

mkdir -p ${ROFI_CONFIG}/themes
cp "${ROFI_THEME_FILE}" ${ROFI_CONFIG}/themes

echo -e "select nord theme and press ${BOLDGREEN}'Alt + a'${ENDCOLOR}"

# rofi-theme-selector

# zsh
if ! command -v zsh &> /dev/null; then
    install_package zsh
fi

# powerlevel10k
if [[ ! -d ${POWERLEVEL10K_DIR} ]]; then
    install_powerlevel10k
    zsh
fi

if ! sudo test -f /root/.zshrc; then
    echo -e "${BOLDGREEN}configuring powerlevel10k [root]...${ENDCOLOR}"

    sudo su -c 'zsh'  # configure powerlevel10k in the root user.
fi

if ! grep -qE '^echo "Welcome to.*' ~/.zshrc; then
    echo -e "${BOLDGREEN}configuring '~/.zshrc' file...${ENDCOLOR}"

    sed -i -E 's/^echo "Welcome to(.+)"$/#echo "Welcome to\1"/g' ~/.zshrc
fi

# alias
if ! grep 'git' ~/.zshrc; then
    echo -e "${BOLDGREEN}configuring '~/.zshrc' file (git)...${ENDCOLOR}"

    echo "alias gs='/usr/bin/git status'" >> ~/.zshrc
    echo "alias ga='/usr/bin/git add'" >> ~/.zshrc
    echo "alias gr='/usr/bin/git rm'" >> ~/.zshrc
    echo "alias gal='/usr/bin/git add *'" >> ~/.zshrc
    echo "alias gc='/usr/bin/git commit'" >> ~/.zshrc
    echo "alias gl='/usr/bin/git pull'" >> ~/.zshrc
    echo "alias gp='/usr/bin/git push'" >> ~/.zshrc
    echo "alias gd='/usr/bin/git diff'" >> ~/.zshrc
fi

sudo ln -s -f $(realpath ~/.zshrc) /root/.zshrc

user=$(whoami)

sudo usermod --shell /usr/bin/zsh ${user}
sudo usermod --shell /usr/bin/zsh root

sudo chown ${user}:${user} /root
sudo chown ${user}:${user} /root/.cache -R
sudo chown ${user}:${user} /root/.local -R

# bat
if ! command -v bat &> /dev/null; then
    install_bat

    echo "alias catl='/bin/bat'" >> ~/.zshrc
    echo "alias catn='/bin/cat'" >> ~/.zshrc
    echo "alias cat='/bin/bat --paging=never'" >> ~/.zshrc
fi

# lsd
if ! command -v lsd &> /dev/null; then
    install_lsd

    echo "alias ll='lsd -lh --group-dirs=first'" >> ~/.zshrc
    echo "alias la='lsd -a --group-dirs=first'" >> ~/.zshrc
    echo "alias l='lsd --group-dirs=first'" >> ~/.zshrc
    echo "alias lla='lsd -lha --group-dirs=first'" >> ~/.zshrc
    echo "alias ls='lsd --group-dirs=first'" >> ~/.zshrc
fi

# fzf
if ! command -v fzf &> /dev/null; then
    echo -e "${BOLDGREEN}installing fzf...${ENDCOLOR}"

    if [[ ! -d ~/.fzf ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi

    ~/.fzf/install
fi

# ueberzug
if ! command -v ueberzug &> /dev/null; then
    install_ueberzug
fi

# ranger
if ! command -v ranger &> /dev/null; then
    install_package ranger
fi

generate_backup ${RANGER_CONFIG}

echo -e "${BOLDGREEN}configuring ranger...${ENDCOLOR}"

ranger --copy-config all
cp "${RANGER_SETTINGS_DIR}"/* ${RANGER_CONFIG}/
sudo mkdir -p /root/.config
sudo ln -s -f $(realpath ${RANGER_CONFIG}) /root/.config/ranger

# zsh pluggins
echo -e "${BOLDGREEN}installing zsh plugin: sudo.plugin.zsh...${ENDCOLOR}"

sudo mkdir -p /usr/share/zsh-plugins/
sudo chown $(whoami):$(whoami) /usr/share/zsh-plugins/
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P /usr/share/zsh-plugins/

echo "source /usr/share/zsh-plugins/sudo.plugin.zsh" >> ~/.zshrc

# nvim
if [[ ! -d ${NVIM_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading neovim configurations...${ENDCOLOR}"
    git clone https://github.com/eccanto/nvim-config.git ${NVIM_DIR}
else
    echo -e "${BOLDGREEN}updating neovim configurations...${ENDCOLOR}"
    git -C ${NVIM_DIR} pull
fi

pushd ${NVIM_DIR}
    bash install.sh
popd

# end
echo -e "${BOLDGREEN}\nfinished.${ENDCOLOR}\n"
