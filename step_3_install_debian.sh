#!/usr/bin/env bash

set -euo pipefail

source common.sh

# zsh
if ! command -v zsh &> /dev/null; then
    echo -e "${BOLDGREEN}installing zsh...${ENDCOLOR}"

    sudo apt update -y
    sudo apt install -y zsh
fi

# powerlevel10k
if [[ ! -d ${POWERLEVEL10K_DIR} ]]; then
    echo -e "${BOLDGREEN}installing powerlevel10k...${ENDCOLOR}"

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${POWERLEVEL10K_DIR}
    sudo rm -rf /usr/local/share/powerlevel10k/
    sudo cp -r ${POWERLEVEL10K_DIR} /usr/local/share/powerlevel10k
    echo "source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc

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
    echo -e "${BOLDGREEN}installing bat...${ENDCOLOR}"

    wget https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb -P ${DEPENDENCIES}
    sudo dpkg -i ${DEPENDENCIES}/bat_0.18.3_amd64.deb

    echo "alias catl='/bin/bat'" >> ~/.zshrc
    echo "alias catn='/bin/cat'" >> ~/.zshrc
    echo "alias cat='/bin/bat --paging=never'" >> ~/.zshrc
fi

# lsd
if ! command -v lsd &> /dev/null; then
    echo -e "${BOLDGREEN}installing lsd...${ENDCOLOR}"

    wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -P ${DEPENDENCIES}
    sudo dpkg -i ${DEPENDENCIES}/lsd_0.20.1_amd64.deb

    echo "alias ll='lsd -lh --group-dirs=first'" >> ~/.zshrc
    echo "alias la='lsd -a --group-dirs=first'" >> ~/.zshrc
    echo "alias l='lsd --group-dirs=first'" >> ~/.zshrc
    echo "alias lla='lsd -lha --group-dirs=first'" >> ~/.zshrc
    echo "alias ls='lsd --group-dirs=first'" >> ~/.zshrc
fi

# fzf
if ! command -v fzf &> /dev/null; then
    echo -e "${BOLDGREEN}installing fzf...${ENDCOLOR}"

    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

# ueberzug
if ! command -v ueberzug &> /dev/null; then
    echo -e "${BOLDGREEN}installing ueberzug...${ENDCOLOR}"
    pip install -U ueberzug
    sudo pip install -U ueberzug
fi

# ranger
if ! command -v ranger &> /dev/null; then
    echo -e "${BOLDGREEN}installing ranger...${ENDCOLOR}"

    sudo apt install -y ranger
fi

gen_backup ${RANGER_CONFIG}

echo -e "${BOLDGREEN}configuring ranger...${ENDCOLOR}"

ranger --copy-config all
cp ./ranger/* ${RANGER_CONFIG}/
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

# system
echo -e "${BOLDGREEN}updating system files...${ENDCOLOR}"
sudo updatedb

# end
echo -e "${BOLDGREEN}\nfinished.${ENDCOLOR}\n"
