#!/usr/bin/env bash

set -xeu

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
SETTINGS_DIRECTORY="${SCRIPT_PATH}/settings"

rm -rf ~/.config/lazydocker/
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

sudo rm -rf /usr/bin/lazydocker
sudo ln -s "$(realpath ~/.local/bin/lazydocker)" /usr/bin/lazydocker

mkdir -p ~/.config/lazydocker/
cp -r "${SETTINGS_DIRECTORY}"/* ~/.config/lazydocker/
