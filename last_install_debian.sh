#!/usr/bin/env bash

set -euo pipefail

RED="31"
GREEN="32"
BOLDRED="\e[1;${RED}m"
BOLDGREEN="\e[1;${GREEN}m"
ENDCOLOR="\e[0m"

DEPENDENCIES=./.deps
POWERLEVEL10K_DIR=${DEPENDENCIES}/powerlevel10k

# powerlevel10k
if ! command -v zsh &> /dev/null; then
    sudo apt update
    sudo apt install zsh
fi

if [[ ! -d ${POWERLEVEL10K_DIR} ]]; then
    echo -e "${BOLDGREEN}installing powerlevel10k...${ENDCOLOR}"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${POWERLEVEL10K_DIR}
    sudo rm -rf /usr/local/share/powerlevel10k/
    sudo cp -r ${POWERLEVEL10K_DIR} /usr/local/share/powerlevel10k
    echo "source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc

    zsh
    sudo su -c 'zsh'  # configure powerlevel10k in the root user.

    sed -i 's/^echo "Welcome to Parrot OS"$/#echo "Welcome to Parrot OS"/g' ~/.zshrc
    sudo ln -s -f $(realpath ~/.zshrc) /root/.zshrc

    sudo usermod --shell /usr/bin/zsh $(whoami)
    sudo usermod --shell /usr/bin/zsh root
fi
