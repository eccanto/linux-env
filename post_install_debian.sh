#!/usr/bin/env bash

set -euo pipefail

RED="31"
GREEN="32"
BOLDRED="\e[1;${RED}m"
BOLDGREEN="\e[1;${GREEN}m"
ENDCOLOR="\e[0m"

DEPENDENCIES=./.deps

# Hack Nerd Fonts
echo -e "${BOLDGREEN}installing Hack Nerd Fonts...${ENDCOLOR}"

fc-cache -v

# firefox latest
wget -O ~/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64"
sudo tar xjf ~/FirefoxSetup.tar.bz2 -C /opt/
rm ~/FirefoxSetup.tar.bz2
sudo mv /usr/lib/firefox/firefox /usr/lib/firefox/firefox_backup
sudo ln -s /opt/firefox/firefox /usr/lib/firefox/firefox

# firejail
sudo apt install firejail


