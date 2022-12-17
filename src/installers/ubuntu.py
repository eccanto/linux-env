"""Class in charge of managing the packages/applications installation."""

import logging
from pathlib import Path

from src.installers.base import BaseInstaller


class UbuntuInstaller(BaseInstaller):  # pylint: disable=too-many-public-methods
    """Class in charge of managing the installation of the required packages on Ubuntu."""

    CONFIG_DIRECTORY_PATH = Path('~/.config').expanduser()

    def install_system_requirements(self) -> None:
        """Installs system requirements (apt)."""
        logging.info('installing required packages...')

        self.run_shell(
            '''
            sudo apt update -y
            sudo apt install -y                                                                                    \
                libcanberra-gtk-module libcanberra-gtk3-module libjsoncpp-dev build-essential xcb                  \
                libxcb-composite0-dev libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev             \
                libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev             \
                libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xrm0 libxcb-xkb-dev libxkbcommon-dev                 \
                libxkbcommon-x11-dev autoconf xutils-dev dh-autoreconf zip unzip git libxcb-xrm-dev                \
                x11-xserver-utils compton binutils gcc make cmake pkg-config fakeroot python3 python3-xcbgen       \
                xcb-proto libxcb-ewmh-dev wireless-tools libiw-dev libasound2-dev libpulse-dev libxcb-shape0       \
                libxcb-shape0-dev libcurl4-openssl-dev libmpdclient-dev pavucontrol python3-pip rxvt-unicode       \
                compton ninja-build meson python3 curl playerctl feh flameshot tty-clock arandr cargo htop vlc     \
                firejail zsh exiftool neofetch
            '''
        )

    def install_speedtest(self) -> None:
        """Installs system requirements (pip)."""
        logging.info('installing speedtest-cli...')

        self.run_shell('pip install speedtest-cli')

    def install_i3gaps(self) -> None:
        """Installs i3 gaps package."""
        logging.info('installing i3 gaps...')

        i3_gaps_temp = self.DEPENDENCIES_PATH.joinpath('i3-gaps')
        self.run_shell(
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

    def install_i3lock(self) -> None:
        """Installs i3 lock package."""
        logging.info('installing i3lock-color...')

        i3lock_color_temp = self.DEPENDENCIES_PATH.joinpath('i3lock-color')
        self.run_shell(
            f'''
            sudo apt install -y autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev \
                libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev         \
                libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev       \
                libxkbcommon-x11-dev libjpeg-dev i3lock peek

            if [[ ! -d "{i3lock_color_temp}" ]]; then
                git clone https://github.com/Raymo111/i3lock-color.git {i3lock_color_temp}
            fi

            pushd "{i3lock_color_temp}"
                ./build.sh
                ./install-i3lock-color.sh
            popd
            '''
        )

    def install_polybar(self) -> None:
        """Installs polybar package."""
        logging.info('installing polybar...')

        polybar_temp = self.DEPENDENCIES_PATH.joinpath('polybar')
        self.run_shell(
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

    def install_picom(self) -> None:
        """Installs picom package."""
        logging.info('installing picom...')

        picom_temp = self.DEPENDENCIES_PATH.joinpath('picom')
        self.run_shell(
            f'''
            sudo apt install -y meson libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev   \
                libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev        \
                libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev       \
                libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libevdev-dev \
                uthash-dev libev-dev libx11-xcb-dev libxcb-glx0-dev

            if [[ ! -d {picom_temp} ]]; then
                git clone https://github.com/ibhagwan/picom.git "{picom_temp}"
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

    def install_rofi(self) -> None:
        """Installs rofi package."""
        logging.info('installing rofi...')

        rofi_config = self.CONFIG_DIRECTORY_PATH.joinpath('rofi')
        rofi_settings = self.SETTINGS_PATH.joinpath('rofi')
        rofi_temp = self.DEPENDENCIES_PATH.joinpath('rofi')
        self.run_shell(
            f'''
            sudo apt-get install -y libgtk2.0-dev flex

            if [[ ! -d "{rofi_temp}" ]]; then
                git clone https://github.com/davatorium/rofi.git "{rofi_temp}"
            fi

            pushd "{rofi_temp}"
                git checkout 1.7.3

                meson setup build
                ninja -C build
                sudo ninja -C build install
            popd

            mkdir -p {rofi_config}
            cp -r {rofi_settings}/* {rofi_config}/

            echo "run 'rofi-theme-selector' and select nord theme and press 'Alt + a'"
            '''
        )

    def install_dunst(self) -> None:
        """Installs dunst package."""
        logging.info('installing dunst...')

        self.run_shell('sudo apt install -y dunst')

    def install_ranger(self) -> None:
        """Installs ranger package."""
        logging.info('installing ranger...')

        self.run_shell('sudo apt install -y ranger')

    def install_vscode(self) -> None:
        """Installs vscode package."""
        logging.info('installing vscode...')

        vscode_temp = self.DEPENDENCIES_PATH.joinpath('vscode-latest.deb')
        vscode_config = self.CONFIG_DIRECTORY_PATH.joinpath('Code/User')
        vscode_settings = self.SETTINGS_PATH.joinpath('vscode')
        self.run_shell(
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
        """Installs rust package."""
        logging.info('installing rust...')

        self.run_shell(
            '''
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
            source ${HOME}/.cargo/env
            rustup default nightly && rustup update
            '''
        )

    def install_alacritty(self) -> None:
        """Installs alacritty terminal emulator."""
        logging.info('installing alacritty...')

        alacrity_temp = self.DEPENDENCIES_PATH.joinpath('alacrity')
        self.run_shell(
            f'''
            sudo apt-get install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev \
                libxkbcommon-dev autotools-dev automake libncurses-dev

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

    def install_btop(self) -> None:
        """Installs btop resource monitor."""
        logging.info('installing btop...')

        btop_temp = self.DEPENDENCIES_PATH.joinpath('btop')
        self.run_shell(
            f'''
            mkdir -p "{btop_temp}"
            wget https://github.com/aristocratos/btop/releases/download/v1.1.4/btop-x86_64-linux-musl.tbz \
                -P "{btop_temp}"
            pushd "{btop_temp}"
                tar -xvjf btop-x86_64-linux-musl.tbz
                bash install.sh
            popd
            '''
        )

    def install_dockly(self) -> None:
        """Installs dockly docker manager."""
        logging.info('installing dockly...')

        self.run_shell(
            '''
            if ! command -v npm &> /dev/null; then
                curl -o- https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh | sudo bash
                sudo apt-get install -y nodejs
            fi

            sudo npm install -g dockly
            '''
        )

    def install_lazygit(self) -> None:
        """Installs lazygit terminal UI for git commands."""
        logging.info('installing lazygit...')

        lazygit_temp = self.DEPENDENCIES_PATH.joinpath('lazygit')
        self.run_shell(
            f'''
            mkdir -p "{lazygit_temp}"
            wget https://github.com/jesseduffield/lazygit/releases/download/v0.34/lazygit_0.34_Linux_x86_64.tar.gz \
                -P "{lazygit_temp}"
            pushd "{lazygit_temp}"
                tar -xf lazygit_0.34_Linux_x86_64.tar.gz
                sudo cp lazygit /usr/local/bin
            popd
            '''
        )

    def install_tmux(self) -> None:
        """Installs tmux terminal multiplexer."""
        logging.info('installing tmux...')

        tmux_temp = self.DEPENDENCIES_PATH.joinpath('tmux')
        self.run_shell(
            f'''
            sudo apt install -y libevent-dev ncurses-dev bison byacc

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

    def install_firefox(self) -> None:
        """Installs firefox web browser."""
        logging.info('installing firefox...')

        self.run_shell(
            '''
            wget -O ~/FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64"
            sudo tar xjf ~/FirefoxSetup.tar.bz2 -C /opt/
            rm ~/FirefoxSetup.tar.bz2
            sudo mv /usr/bin/firefox /usr/bin/firefox_backup || true
            sudo ln -s /opt/firefox/firefox /usr/bin/firefox
            '''
        )

    def install_bat(self) -> None:
        """Installs bat package."""
        logging.info('installing bat...')

        bat_temp = self.DEPENDENCIES_PATH.joinpath('bat')
        self.run_shell(
            f'''
            mkdir -p {bat_temp}
            wget https://github.com/sharkdp/bat/releases/download/v0.22.0/bat_0.22.0_amd64.deb -P {bat_temp}
            sudo dpkg -i {bat_temp}/bat_0.22.0_amd64.deb
            '''
        )

    def install_lsd(self) -> None:
        """Installs lsd package."""
        logging.info('installing lsd...')

        lsd_temp = self.DEPENDENCIES_PATH.joinpath('lsd')
        self.run_shell(
            f'''
            mkdir -p {lsd_temp}
            wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -P {lsd_temp}
            sudo dpkg -i {lsd_temp}/lsd_0.20.1_amd64.deb
            '''
        )

    def install_fzf(self) -> None:
        """Installs fzf general-purpose command-line fuzzy finder."""
        logging.info('installing fzf...')

        self.run_shell(
            '''
            if [[ ! -d ~/.fzf ]]; then
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            fi

            ~/.fzf/install
            sudo ln -s -f ${HOME}/.fzf/bin/fzf /usr/bin/fzf
            '''
        )

    def install_ueberzug(self) -> None:
        """Installs ueberzug terminal image visualizer."""
        logging.info('installing ueberzug...')

        self.run_shell(
            '''
            sudo apt install -y libxext-dev

            pip install -U ueberzug
            sudo pip install -U ueberzug
            '''
        )

    def install_fonts_awesome(self) -> None:
        """Installs awesome fonts."""
        logging.info('installing awesome fonts...')

        fonts_temp = self.DEPENDENCIES_PATH.joinpath('fonts/awesome')
        self.run_shell(
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

    def install_fonts_nerd(self) -> None:
        """Installs nerd fonts."""
        logging.info('installing nerd fonts...')

        fonts_temp = self.DEPENDENCIES_PATH.joinpath('fonts/nerd')
        self.run_shell(
            f'''
            if [[ ! -d "{fonts_temp}" ]]; then
                git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git "{fonts_temp}"
            fi

            pushd "{fonts_temp}"
                sudo ./install.sh -S
            popd
            '''
        )

    def install_powerlevel10k(self) -> None:
        """Installs powerlevel10k zsh."""
        logging.info('installing powerlevel10k...')

        powerlevel10k_temp = self.DEPENDENCIES_PATH.joinpath('powerlevel10k')
        self.run_shell(
            f'''
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "{powerlevel10k_temp}"
            sudo rm -rf /usr/local/share/powerlevel10k/
            sudo cp -r "{powerlevel10k_temp}" /usr/local/share/powerlevel10k
            echo "source /usr/local/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc

            zsh
            '''
        )

    def install_neovim(self) -> None:
        """Installs neovim editor."""
        logging.info('installing neovim...')

        neovim_temp = self.DEPENDENCIES_PATH.joinpath('neovim')
        self.run_shell(
            f'''
            if [[ ! -d {neovim_temp} ]]; then
                git clone https://github.com/eccanto/nvim-config.git {neovim_temp}
            fi

            pushd {neovim_temp}
                bash install.sh
            popd
            ''',
        )
