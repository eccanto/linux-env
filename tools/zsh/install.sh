#!/usr/bin/env bash

set -xeu

TEMPORARY_DIRECORY="$(mktemp -d)/powerlevel10k"
SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
ZSH_CONFIGURATION_FILE=$(realpath "${SCRIPT_PATH}/settings/.zshrc")

source "${SCRIPT_PATH}/../../common.sh"

os_name=$(get_os)
if [[ ${os_name} == Ubuntu* ]]; then
    sudo apt install --assume-yes zsh
elif [[ ${os_name} == Manjaro* ]]; then
    sudo pacman -S zsh
fi

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${TEMPORARY_DIRECORY}"
rm -rf ~/.zsh

pushd "${TEMPORARY_DIRECORY}"
    sudo rm -rf /usr/local/share/powerlevel10k
    sudo cp -r . /usr/local/share/powerlevel10k

    cp "${ZSH_CONFIGURATION_FILE}" ~/.zshrc

    sudo ln -s -f "$(realpath ~/.zshrc)" /root/.zshrc

    user=$(whoami)

    sudo usermod --shell /usr/bin/zsh "${user}"
    sudo usermod --shell /usr/bin/zsh root

    sudo chown "${user}":"${user}" /root/.cache -R || true
    sudo chown "${user}":"${user}" /root/.local -R || true
popd

rm -rf "${TEMPORARY_DIRECORY}"

if [[ ! -d "/usr/share/zsh-plugins/" ]]; then
    sudo mkdir -p /usr/share/zsh-plugins/
    sudo chown "$(whoami)":"$(whoami)" /usr/share/zsh-plugins/
fi

# install zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# isntall zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

# install sudo.plugin.zsh
mkdir -p ~/.zsh/zsh-plugins/
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh \
    -O ~/.zsh/zsh-plugins/sudo.plugin.zsh

sudo ln -s -f "$(realpath ~/.zsh)" /root/.zsh

zsh
sudo su -c "zsh"
