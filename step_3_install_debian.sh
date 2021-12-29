#!/usr/bin/env bash

set -euo pipefail

source common.sh

# powerlevel10k
if ! command -v zsh &> /dev/null; then
    echo -e "${BOLDGREEN}installing zsh...${ENDCOLOR}"

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

    chown $(whoami):$(whoami) /root
    chown $(whoami):$(whoami) /root/.cache -R
    chown $(whoami):$(whoami) /root/.local -R
fi

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

# ranger
if ! command -v ranger &> /dev/null; then
    echo -e "${BOLDGREEN}installing ranger...${ENDCOLOR}"

    sudo apt install ranger
fi

# zsh pluggins
echo -e "${BOLDGREEN}installing zsh plugin: sudo.plugin.zsh...${ENDCOLOR}"

sudo mkdir -p /usr/share/zsh-plugins/
sudo chown $(whoami):$(whoami) /usr/share/zsh-plugins/
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P /usr/share/zsh-plugins/

echo "source /usr/share/zsh-plugins/sudo.plugin.zsh" >> ~/.zshrc

# nvim
if ! command -v nvim &> /dev/null; then
    echo -e "${BOLDGREEN}installing neovim...${ENDCOLOR}"
    wget https://github.com/neovim/neovim/releases/download/v0.6.0/nvim-linux64.tar.gz -O- | sudo tar zxvf - -C /usr/local --strip=1

    sudo mv /usr/bin/vim /usr/bin/vim_backup
    sudo ln -s /usr/local/bin/nvim /usr/bin/vim
fi

rm ${NVIM_CONFIG}/init.vim
echo -e "${BOLDGREEN}installing neovim style...${ENDCOLOR}"

mkdir -p ${NVIM_CONFIG}

cat > ${NVIM_CONFIG}/init.vim << EOC
set number

set expandtab
set autoindent
set softtabstop=4
set shiftwidth=4
set tabstop=4

"Enable mouse click for nvim
set mouse=a
"Fix cursor replacement after closing nvim
set guicursor=
"Shift + Tab does inverse tab
inoremap <S-Tab> <C-d>

"See invisible characters
set list listchars=tab:>\ ,trail:.

"wrap to next line when end of line is reached
set whichwrap+=<,>,[,]

syntax on
EOC

# system
echo -e "${BOLDGREEN}updating system files...${ENDCOLOR}"
sudo updatedb

# end
echo -e "${BOLDGREEN}\nfinished.${ENDCOLOR}\n"
