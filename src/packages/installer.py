import logging
import os
import pwd
import shutil
import subprocess
from pathlib import Path
from shutil import which
from typing import Any

from src.configuration.configurations import (
    AlacrittyConfiguration,
    DunstConfiguration,
    I3Configuration,
    I3LockConfiguration,
    PicomConfiguration,
    PolybarConfiguration,
    RofiConfiguration,
    RofiMenuConfiguration
)


class PackagesInstaller:
    def __init__(self, temp: Path, settings: Path, config_directory: Path, style: Any) -> None:
        self.temp = temp
        self.settings = settings
        self.config_directory = config_directory
        self.style = style

    def run_command(self, command: str) -> None:
        subprocess.run(
            f'''
            su - {pwd.getpwuid(os.getlogin()).pw_name}
            {command}
            ''',
            shell=True,
            check=True,
            executable='/bin/bash',
        )

    def is_installed(self, package_name: str) -> bool:
        return which(package_name) is not None

    def install_requirements(self) -> None:
        logging.info('installing required packages...')

        self.run_command(
            '''
            sudo apt update -y
            sudo apt install -y                                                                                      \
                libcanberra-gtk-module libcanberra-gtk3-module libjsoncpp-dev build-essential xcb                    \
                libxcb-composite0-dev libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev               \
                libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev               \
                libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xrm0 libxcb-xkb-dev libxkbcommon-dev                   \
                libxkbcommon-x11-dev autoconf xutils-dev dh-autoreconf unzip git libxcb-xrm-dev x11-xserver-utils    \
                compton binutils gcc make cmake pkg-config fakeroot python3 python3-xcbgen xcb-proto                 \
                libxcb-ewmh-dev wireless-tools libiw-dev libasound2-dev libpulse-dev libxcb-shape0 libxcb-shape0-dev \
                libcurl4-openssl-dev libmpdclient-dev pavucontrol python3-pip rxvt-unicode compton ninja-build meson \
                python3 curl playerctl feh flameshot tty-clock arandr cargo htop vlc firejail zsh
            '''
        )

    def install_pip_requirements(self) -> None:
        logging.info('installing required pip packages...')

        self.run_command('pip install speedtest-cli')

    def install_i3_gaps(self) -> None:
        if not self.is_installed('i3'):
            logging.info('installing i3 gaps...')

            i3_gaps_temp = self.temp.joinpath('i3-gaps')
            self.run_command(
                f'''
                if [[ ! -d "{i3_gaps_temp}" ]]; then
                    git clone https://github.com/Airblader/i3 {i3_gaps_temp}
                fi

                pushd "{i3_gaps_temp}"
                    rm -rf build/
                    mkdir -p build
                    pushd build
                        meson --prefix /usr/local
                        ninja
                        sudo ninja install
                    popd
                popd
                '''
            )

        config_directory = self.config_directory.joinpath('i3')
        config_directory.mkdir(parents=True, exist_ok=True)

        configuration = I3Configuration(self.settings.joinpath('i3/config'), config_directory)
        configuration.setup(self.style.components['i3'])

    def install_i3lock(self) -> None:
        if not self.is_installed('i3lock'):
            logging.info('installing i3lock-color...')

            i3lock_color_temp = self.temp.joinpath('i3lock-color')
            self.run_command(
                f'''
                sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev \
                    libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev         \
                    libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev       \
                    libxkbcommon-x11-dev libjpeg-dev i3lock

                if [[ ! -d "{i3lock_color_temp}" ]]; then
                    git clone https://github.com/Raymo111/i3lock-color.git {i3lock_color_temp}
                fi

                pushd "{i3lock_color_temp}"
                    ./build.sh
                    ./install-i3lock-color.sh
                popd
                '''
            )

        configuration = I3LockConfiguration(self.settings.joinpath('i3lock/lock.sh'), Path('/usr/bin/lock'))
        configuration.setup(self.style.components['i3lock'])

    def install_polybar(self) -> None:
        if not self.is_installed('polybar'):
            logging.info('installing polybar...')

            polybar_temp = self.temp.joinpath('polybar')
            self.run_command(
                f'''
                sudo apt install cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev \
                    libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto \
                    libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev \
                    libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libmpdclient-dev     \
                    libcurl4-openssl-dev libnl-genl-3-dev libuv1-dev

                if [[ ! -d "{polybar_temp}" ]]; then
                    git clone --recursive https://github.com/polybar/polybar "{polybar_temp}"
                fi

                pushd "{polybar_temp}"
                    rm -rf build/
                    mkdir build/
                    pushd build/
                        cmake ..
                        make -j$(nproc)
                        sudo make install
                    popd
                popd
                '''
            )

        polybar_settings = self.settings.joinpath('polybar/config')

        polybar_config = self.config_directory.joinpath('polybar')
        polybar_config.mkdir(parents=True, exist_ok=True)

        configuration = PolybarConfiguration(polybar_settings, polybar_config)
        configuration.update(self.style.components['polybar'])
        configuration.backup()

        if polybar_config.exists():
            shutil.rmtree(polybar_config)
            shutil.copytree(polybar_settings.parent, polybar_config)

        configuration.install()
        configuration.reload()

    def install_picom(self) -> None:
        if not self.is_installed('picom'):
            logging.info('installing picom...')

            picom_temp = self.temp.joinpath('picom')
            self.run_command(
                f'''
                sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev   \
                    libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev        \
                    libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev       \
                    libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev \
                    uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev

                if [[ ! -d {picom_temp} ]]; then
                    git clone https://github.com/ibhagwan/picom.git {picom_temp}
                    pushd {picom_temp}
                        git submodule update --init --recursive
                    popd
                fi

                pushd {picom_temp}
                    meson --buildtype=release . build
                    ninja -C build
                    sudo ninja -C build install
                popd
                '''
            )

        configuration = PicomConfiguration(
            self.settings.joinpath('picom/picom.conf'), self.config_directory.joinpath('picom')
        )
        configuration.setup(self.style.components['picom'])

    def install_rofi(self) -> None:
        if not self.is_installed('rofi'):
            logging.info('installing rofi...')

            rofi_config = self.config_directory.joinpath('rofi')
            rofi_theme = self.settings.joinpath('rofi/nord.rasi')
            self.run_command(
                f'''
                sudo apt install -y rofi

                mkdir -p {rofi_config}/themes
                cp "{rofi_theme}" {rofi_config}/themes

                echo "run 'rofi-theme-selector' and select nord theme and press 'Alt + a'"
                '''
            )

        configuration_rofi = RofiConfiguration(
            self.settings.joinpath('rofi/themes/nord.rasi'), self.config_directory.joinpath('rofi/themes/nord.rasi')
        )
        configuration_rofi.setup(self.style.components['rofi'])

        configuration_rofi_menu = RofiMenuConfiguration(
            self.settings.joinpath('polybar/scripts/themes/colors.rasi'),
            self.config_directory.joinpath('polybar/scripts/themes/colors.rasi')
        )
        configuration_rofi_menu.setup(self.style.components['rofi_menu'])

    def install_dunst(self) -> None:
        if not self.is_installed('dunst'):
            logging.info('installing dunst...')

            self.run_command('sudo apt install -y dunst')

        configuration = DunstConfiguration(
            self.settings.joinpath('dunst/dunstrc'), self.config_directory.joinpath('dunst')
        )
        configuration.setup(self.style.components['dunst'])

    def install_ranger(self):
        if not self.is_installed('ranger'):
            logging.info('installing ranger...')

            self.run_command('sudo apt install -y ranger')

            logging.info('configuring ranger...')

            ranger_config_directory = self.config_directory.joinpath('ranger')
            ranger_settings_directory = self.settings.joinpath('ranger')
            self.run_command(
                f'''
                ranger --copy-config all
                cp -r "{ranger_settings_directory}"/* {ranger_config_directory}/
                sudo mkdir -p /root/.config
                sudo ln -s -f $(realpath {ranger_config_directory}) /root/.config/ranger

                # install ranger plugins
                mkdir -p {ranger_config_directory}/pluggins
                if [[ ! -d {ranger_config_directory}/plugins/ranger_devicons ]]; then
                    git clone https://github.com/alexanderjeurissen/ranger_devicons {ranger_config_directory}/plugins/ranger_devicons
                fi
                '''
            )

    def install_vscode(self) -> None:
        if not self.is_installed('code'):
            logging.info('installing vscode...')

            vscode_temp = self.temp.joinpath('vscode-latest.deb')
            vscode_config = self.config_directory.joinpath('Code/User')
            vscode_settings = self.settings.joinpath('vscode')
            self.run_command(
                f'''
                wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O "{vscode_temp}"
                sudo dpkg -i "{vscode_temp}"

                pushd {vscode_settings}
                    mkdir -p "{vscode_config}"
                    cp settings.json keybindings.json "{vscode_config}"
                    cat extensions.txt | xargs -n 1 code --install-extension
                popd
                '''
            )

    def install_rust(self) -> None:
        if not self.is_installed('rustc'):
            logging.info('installing rust...')

            self.run_command(
                '''
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                source ${HOME}/.cargo/env
                rustup default nightly && rustup update
                '''
            )

    def install_alacritty(self) -> None:
        if not self.is_installed('alacritty'):
            logging.info('installing alacritty...')

            alacrity_temp = self.temp.joinpath('alacrity')
            self.run_command(
                f'''
                sudo apt-get install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev \
                    autotools-dev automake libncurses-dev

                if [[ ! -d {alacrity_temp} ]]; then
                    git clone https://github.com/alacritty/alacritty.git {alacrity_temp}
                fi

                pushd {alacrity_temp}
                    cargo build --release
                    #infocmp alacritty &> /dev/null
                    sudo cp target/release/alacritty /usr/local/bin
                popd
                '''
            )

        configuration = AlacrittyConfiguration(
            self.settings.joinpath('alacritty/alacritty.yml'), self.config_directory.joinpath('alacritty')
        )
        configuration.setup(self.style.components['alacritty'])

    def install_btop(self) -> None:
        if not self.is_installed('btop'):
            logging.info('installing btop...')

            btop_temp = self.temp.joinpath('btop')
            self.run_command(
                f'''
                mkdir -p "{btop_temp}"
                wget https://github.com/aristocratos/btop/releases/download/v1.1.4/btop-x86_64-linux-musl.tbz -P "{btop_temp}"
                pushd "{btop_temp}"
                    tar -xvjf btop-x86_64-linux-musl.tbz
                    bash install.sh
                popd
                '''
            )

    def install_dockly(self) -> None:
        if not self.is_installed('dockly'):
            logging.info('installing dockly...')

            self.run_command(
                '''
                if ! command -v npm &> /dev/null; then
                    curl -o- https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh | sudo bash
                    sudo apt-get install -y nodejs
                fi

                sudo npm install -g dockly
                '''
            )

    def install_lazygit(self) -> None:
        if not self.is_installed('lazygit'):
            logging.info('installing lazygit...')

            lazygit_temp = self.temp.joinpath('lazygit')
            self.run_command(
                f'''
                mkdir -p "{lazygit_temp}"
                wget https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz -P "{lazygit_temp}"
                pushd "{lazygit_temp}"
                    tar -xf lazygit_0.34_Linux_x86_64.tar.gz
                    sudo cp lazygit /usr/local/bin
                popd
                '''
            )

    def install_tmux(self) -> None:
        if not self.is_installed('tmux'):
            logging.info('installing tmux...')

            tmux_temp = self.temp.joinpath('tmux')
            self.run_command(
                f'''
                sudo apt install -y libevent-dev bison byacc

                if [[ ! -d "{tmux_temp}" ]]; then
                    git clone https://github.com/tmux/tmux.git "{tmux_temp}"
                fi

                pushd "{tmux_temp}"
                    git checkout 3.2

                    sh autogen.sh
                    ./configure
                    make

                    sudo mv tmux /usr/bin
                popd
                '''
            )

        logging.info('configuring tmux...')

        tmux_config_file = Path('~/.tmux.conf').expanduser()
        tmux_settings_file = self.settings.joinpath('tmux/tmux.conf')
        self.run_command(
            f'''
            cp "{tmux_settings_file}" "{tmux_config_file}"
            sudo ln -s -f "{tmux_config_file}" /root/.tmux.conf
            '''
        )

    def install_firefox(self) -> None:
        if not self.is_installed('firefox'):
            logging.info('installing firefox...')

            self.run_command(
                '''
                wget -O ~/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64"
                sudo tar xjf ~/FirefoxSetup.tar.bz2 -C /opt/
                rm ~/FirefoxSetup.tar.bz2
                sudo mv /usr/bin/firefox /usr/bin/firefox_backup
                sudo ln -s /opt/firefox/firefox /usr/bin/firefox
                '''
            )

    def install_bat(self) -> None:
        if not self.is_installed('bat'):
            logging.info('installing bat...')

            bat_temp = self.temp.joinpath('bat')
            self.run_command(
                f'''
                mkdir -p {bat_temp}
                wget https://github.com/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb -P {bat_temp}
                sudo dpkg -i {bat_temp}/bat_0.18.3_amd64.deb
                '''
            )

    def install_lsd(self) -> None:
        if not self.is_installed('lsd'):
            logging.info('installing lsd...')

            lsd_temp = self.temp.joinpath('lsd')
            self.run_command(
                f'''
                mkdir -p {lsd_temp}
                wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -P {lsd_temp}
                sudo dpkg -i {lsd_temp}/lsd_0.20.1_amd64.deb
                '''
            )

    def install_fzf(self) -> None:
        if not self.is_installed('fzf'):
            logging.info('installing fzf...')

            self.run_command(
                '''
                if [[ ! -d ~/.fzf ]]; then
                    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                fi

                ~/.fzf/install
                '''
            )

    def install_ueberzug(self) -> None:
        if not self.is_installed('ueberzug'):
            logging.info('installing ueberzug...')

            self.run_command(
                '''
                sudo apt install -y libxext-dev

                pip install -U ueberzug
                sudo pip install -U ueberzug
                '''
            )

    def install_fonts_awesome(self) -> None:
        if not os.path.exists('/usr/share/fonts/opentype/scp'):
            logging.info('installing fonts awesome...')

            fonts_temp = self.temp.joinpath('fonts')
            self.run_command(
                f'''
                sudo mkdir -p /usr/share/fonts/opentype
                sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp

                mkdir -p "{fonts_temp}"
                pushd "{fonts_temp}"
                    wget https://use.fontawesome.com/releases/v5.0.13/fontawesome-free-5.0.13.zip
                    unzip fontawesome-free-5.0.13.zip
                    pushd fontawesome-free-5.0.13
                        sudo cp use-on-desktop/* /usr/share/fonts
                        sudo fc-cache -f -v
                    popd
                popd
                '''
            )

    def install_powerlevel10k(self) -> None:
        if os.path.exists('/usr/local/share/powerlevel10k/powerlevel10k.zsh-theme'):
            logging.info('installing powerlevel10k...')

            powerlevel10k_temp = self.temp.joinpath('powerlevel10k')
            self.run_command(
                f'''
                git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "{powerlevel10k_temp}"
                sudo rm -rf /usr/local/share/powerlevel10k/
                sudo cp -r "{powerlevel10k_temp}" /usr/local/share/powerlevel10k
                echo "source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc

                zsh
                '''
            )

        shutil.copyfile(self.settings.joinpath('zsh/.zshrc'), Path('~/.zshrc').expanduser())

        if not os.path.exists('/root/.zshrc'):
            self.run_command('sudo su -c "zsh"')

        self.run_command(
            '''
            sudo ln -s -f $(realpath ~/.zshrc) /root/.zshrc

            user=$(whoami)

            sudo usermod --shell /usr/bin/zsh ${user}
            sudo usermod --shell /usr/bin/zsh root

            sudo chown ${user}:${user} /root
            sudo chown ${user}:${user} /root/.cache -R
            sudo chown ${user}:${user} /root/.local -R
            '''
        )

        if not os.path.exists('/usr/share/zsh-plugins/sudo.plugin.zsh'):
            logging.info('installing zsh plugin: sudo.plugin.zsh...')

            self.run_command(
                '''
                sudo mkdir -p /usr/share/zsh-plugins/
                sudo chown $(whoami):$(whoami) /usr/share/zsh-plugins/
                wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P /usr/share/zsh-plugins/
                '''
            )

    def install_neovim(self) -> None:
        if not self.is_installed('nvim'):
            logging.info('installing neovim...')

            neovim_temp = self.temp.joinpath('neovim')
            self.run_command(
                f'''
                if [[ ! -d {neovim_temp} ]]; then
                    git clone https://github.com/eccanto/nvim-config.git {neovim_temp}
                fi

                pushd {neovim_temp}
                    bash install.sh
                popd
                ''',
            )
