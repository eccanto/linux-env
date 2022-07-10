#!/usr/bin/env bash

set -euo pipefail

source common.sh

# os
sudo apt update -y
sudo apt install -y python3 python3-pip curl


mkdir -p ${DEPENDENCIES}

# i3
if ! command -v i3; then
    sudo apt-get install -y i3 i3-wm dunst i3lock i3status suckless-tools \
        compton hsetroot rxvt-unicode xsel rofi fonts-noto fonts-mplus    \
        xsettingsd lxappearance scrot viewnior

    cp -a i3/. ~
fi

# cargo
if ! command -v cargo; then
    sudo apt-get install -y cargo
fi

# rustup
if [[ -f ${HOME}/.cargo/env ]]; then
    source ${HOME}/.cargo/env
fi

if ! command -v rustup; then
    echo -e "${BOLDGREEN}installing rustup...${ENDCOLOR}"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source ${HOME}/.cargo/env
fi

# update rust
echo -e "${BOLDGREEN}updating rust...${ENDCOLOR}"
rustup default nightly && rustup update

# alacritty
if ! command -v alacritty &> /dev/null; then
    echo -e "${BOLDGREEN}installing alacritty...${ENDCOLOR}"

    sudo apt-get install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev \
        libxcb-xfixes0-dev libxkbcommon-dev autotools-dev automake libncurses-dev
fi

if [[ ! -d ${ALACRITTY_DIR} ]]; then
    echo -e "${BOLDGREEN}downloading alacritty...${ENDCOLOR}"

    git clone https://github.com/alacritty/alacritty.git ${ALACRITTY_DIR}
fi

if ! command -v alacritty &> /dev/null; then
    pushd ${ALACRITTY_DIR}
        cargo build --release
        #infocmp alacritty &> /dev/null
        sudo cp target/release/alacritty /usr/local/bin
    popd
fi

generate_backup ${ALACRITTY_CONFIG}

echo -e "${BOLDGREEN}configuring alacritty...${ENDCOLOR}"
mkdir -p ${ALACRITTY_CONFIG}
cp ./alacritty/* ${ALACRITTY_CONFIG}/

# nvlc (command line VLC media player)
if ! command -v nvlc &> /dev/null; then
    echo -e "${BOLDGREEN}installing nvlc (vlc)...${ENDCOLOR}"

    sudo apt install -y vlc
fi

# btop
if ! command -v btop &> /dev/null; then
    echo -e "${BOLDGREEN}installing btop...${ENDCOLOR}"

    mkdir -p ${BTOP_DIR}
    wget https://github.com/aristocratos/btop/releases/download/v1.1.4/btop-x86_64-linux-musl.tbz -P ${BTOP_DIR}
    pushd ${BTOP_DIR}
        tar -xvjf btop-x86_64-linux-musl.tbz
        bash install.sh
    popd
fi

# speedtest-cli
if ! command -v speedtest &> /dev/null; then
    echo -e "${BOLDGREEN}installing speedtest...${ENDCOLOR}"

    pip install speedtest-cli
fi

# dockly
if ! command -v dockly &> /dev/null; then
    echo -e "${BOLDGREEN}installing dockly...${ENDCOLOR}"

    if ! command -v npm &> /dev/null; then
        curl -o- https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh | sudo bash
        sudo apt-get install -y nodejs
    fi

    sudo npm install -g dockly
fi

# lazygit
if ! command -v lazygit &> /dev/null; then
    echo -e "${BOLDGREEN}installing lazygit...${ENDCOLOR}"

    mkdir -p ${LAZYGIT_DIR}
    wget https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz -P ${LAZYGIT_DIR}
    pushd ${LAZYGIT_DIR}
        tar -xf lazygit_0.34_Linux_x86_64.tar.gz
        sudo cp lazygit /usr/local/bin
    popd
fi

# tmux
if ! command -v tmux &> /dev/null; then
    echo -e "${BOLDGREEN}installing tmux...${ENDCOLOR}"

    sudo apt install -y libevent-dev bison byacc

    if [[ ! -d ${TMUX_DIR} ]]; then
        git clone https://github.com/tmux/tmux.git ${TMUX_DIR}
    fi

    pushd ${TMUX_DIR}
        git checkout 3.2

        sh autogen.sh
        ./configure
        make

        sudo mv tmux /usr/bin
    popd
fi

if [[ ! -f "${TMUX_CONFIG}" ]]; then
    echo -e "${BOLDGREEN}configuring tmux...${ENDCOLOR}"

    cp ./tmux/tmux.conf "${TMUX_CONFIG}"
    sudo ln -s -f "${TMUX_CONFIG}" /root/.tmux.conf
fi

# firefox latest
if ! command -v firefox &> /dev/null; then
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
sudo mkdir -p ${WALLPAPERS_STORAGE}
sudo cp ${DEFAULT_BG} ${WALLPAPERS_STORAGE}

if ! command -v feh &> /dev/null; then
    echo -e "${BOLDGREEN}installing wallpaper manager...${ENDCOLOR}"
    sudo apt install -y feh
    feh --bg-fill ${WALLPAPERS_STORAGE}/$(basename ${DEFAULT_BG})
fi

# rofi
if ! command -v rofi &> /dev/null; then
    sudo apt install -y rofi
fi

generate_backup ${ROFI_CONFIG}

echo -e "${BOLDGREEN}configuring rofi...${ENDCOLOR}"

mkdir -p ${ROFI_CONFIG}/themes
cp ./rofi/nord.rasi ${ROFI_CONFIG}/themes

echo -e "select nord theme and press ${BOLDGREEN}'Alt + a'${ENDCOLOR}"

rofi-theme-selector

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

    if [[ ! -d ~/.fzf ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi

    ~/.fzf/install
fi

# ueberzug
if ! command -v ueberzug &> /dev/null; then
    echo -e "${BOLDGREEN}installing ueberzug...${ENDCOLOR}"

    sudo apt install -y libxext-dev

    pip install -U ueberzug
    sudo pip install -U ueberzug
fi

# ranger
if ! command -v ranger &> /dev/null; then
    echo -e "${BOLDGREEN}installing ranger...${ENDCOLOR}"

    sudo apt install -y ranger
fi

generate_backup ${RANGER_CONFIG}

echo -e "${BOLDGREEN}configuring ranger...${ENDCOLOR}"

ranger --copy-config all
cp ./ranger/* ${RANGER_CONFIG}/
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
