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
if [[ ! -d ${POWERLEVEL10K_DIR} ]]; then
    echo -e "${BOLDGREEN}installing powerlevel10k...${ENDCOLOR}"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${POWERLEVEL10K_DIR}
    echo "source ${POWERLEVEL10K_DIR}/powerlevel10k.zsh-theme" >>~/.zshrc
    zsh
fi
