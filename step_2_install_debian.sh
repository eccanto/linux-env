#!/usr/bin/env bash

set -euo pipefail

source common.sh

# Hack Nerd Fonts
if ! ls /usr/local/share/fonts/Hack*.ttf &> /dev/null; then
    echo -e "${BOLDGREEN}installing Hack Nerd Fonts...${ENDCOLOR}"

    mkdir -p ${FONTS_DIR}
    pushd ${FONTS_DIR}
        wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
        sudo mv Hack.zip /usr/local/share/fonts/
        cd /usr/local/share/fonts/
        sudo unzip Hack.zip
        sudo rm Hack.zip
    popd
    fc-cache -v
fi

# firefox latest
if ! command -v firefox &> /dev/null; then  # TODO -> verify version!!!
    echo -e "${BOLDGREEN}installing firefox...${ENDCOLOR}"
    wget -O ~/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64"
    sudo tar xjf ~/FirefoxSetup.tar.bz2 -C /opt/
    rm ~/FirefoxSetup.tar.bz2
    sudo mv /usr/bin/firefox /usr/bin/firefox_backup
    sudo ln -s /opt/firefox/firefox /usr/bin/firefox
fi

# firejail
if ! command -v firejail &> /dev/null; then
    echo -e "${BOLDGREEN}installing firejail...${ENDCOLOR}"
    sudo apt install -y firejail
fi

# feh
if ! command -v feh &> /dev/null; then
    echo -e "${BOLDGREEN}installing wallpapers...${ENDCOLOR}"
    sudo apt install -y feh
    sudo mkdir -p ${WALLPAPERS_STORAGE}
    sudo cp ${DEFAULT_BG} ${WALLPAPERS_STORAGE}

    echo -e "\n# background\nfeh --bg-fill ${WALLPAPERS_STORAGE}/$(basename ${DEFAULT_BG})" >> ${BSPWM_CONFIG}/bspwmrc
    pkill -USR1 -x sxhkd || true
fi

# rofi
if ! command -v rofi &> /dev/null; then
    sudo apt install -y rofi
fi

if [[ ! -d ${ROFI_CONFIG} ]]; then
    echo -e "${BOLDGREEN}configuring rofi...${ENDCOLOR}"

    mkdir -p ${ROFI_CONFIG}/themes
    cp ./rofi/nord.rasi ${ROFI_CONFIG}/themes
fi

echo -e "select nord theme and press ${BOLDGREEN}'Alt + a'${ENDCOLOR}"

rofi-theme-selector

# slim and slimlock
if ! command -v slimlock &> /dev/null; then
    sudo apt update -y
    sudo apt install -y slim libpam0g-dev libxrandr-dev libfreetype6-dev libimlib2-dev libxft-dev

    git clone https://github.com/joelburget/slimlock.git ${SLIMLOCK_DIR}
    pushd ${SLIMLOCK_DIR}
        sudo make
        sudo make install
    popd

    pushd ./slim/
        sudo cp slim.conf /etc/
        sudo cp slimlock.conf /etc/
        sudo cp -r default /usr/share/slim/themes/
    popd

    echo -e "\n# Slimlock\nsuper + l\n    slimlock" >> ${SXHKD_CONFIG}/sxhkdrc
fi

# end
echo -e "${BOLDGREEN}\nfinished.${ENDCOLOR}\n"
echo -e "you must reboot the machine and then run the ${BOLDGREEN}\"bash last_install_debian.sh\"${ENDCOLOR} command to complete the installation."
