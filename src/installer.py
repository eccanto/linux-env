"""Class in charge of managing the packages/applications installation."""

import logging
import os
import shutil
from pathlib import Path
from typing import Any

import click
import distro

from src.configuration.configurations import (
    AlacrittyConfiguration,
    DunstConfiguration,
    I3Configuration,
    I3LockConfiguration,
    PicomConfiguration,
    PolybarConfiguration,
    RofiConfiguration,
    RofiMenuConfiguration,
)
from src.installers.base import BaseInstaller
from src.installers.ubuntu import UbuntuInstaller


class SystemInstaller(BaseInstaller):  # pylint: disable=too-many-public-methods
    """Class in charge of managing the installation and configuration of the required packages."""

    CONFIG_DIRECTORY_PATH = Path('~/.config').expanduser()

    OS_INSTALLERS = {
        ('ubuntu', '20.04'): UbuntuInstaller,
        ('ubuntu', '22.04'): UbuntuInstaller,
    }

    def __init__(self, style: Any) -> None:
        """Constructor method.

        :param style: An object representing the style to be applied.
        """
        self.style = style

        os_version = (distro.id(), distro.version())
        if os_version not in self.OS_INSTALLERS:
            raise OSError(f'Unsupported OS: {os_version}')

        self.os_installer = self.OS_INSTALLERS[os_version]()

    def install_system_requirements(self) -> None:
        """Installs system requirements (apt)."""
        if click.confirm('Do you want to install system requirements?'):
            self.os_installer.install_system_requirements()

    def install_speedtest(self) -> None:
        """Installs speedtest package (pip)."""
        self.os_installer.install_speedtest()

    def install_i3gaps(self) -> None:
        """Installs i3 gaps package."""
        self.os_installer.install_bsnotifier()

        if not self.is_installed('i3'):
            self.os_installer.install_i3gaps()

        if not self.is_installed('i3_tab_switcher'):
            script_path = self.SETTINGS_PATH.joinpath('i3/i3_tab_switcher.py')
            self.run_shell(
                f'''
                sudo pip3 install -r requirements.txt
                sudo ln -s -f $(realpath {script_path}) /usr/bin/i3_tab_switcher
                '''
            )

        if self.style:
            config_directory = self.CONFIG_DIRECTORY_PATH.joinpath('i3')
            config_directory.mkdir(parents=True, exist_ok=True)

            configuration = I3Configuration(self.SETTINGS_PATH.joinpath('i3/config'), config_directory)
            configuration.setup(self.style.components['i3'])

            config_path = config_directory.joinpath('config')
            config_raw = config_path.read_text()
            config_path.write_text(config_raw.replace('${USER_HOME}', str(Path('~').expanduser())))

    def install_i3lock(self) -> None:
        """Installs i3 lock package."""
        if not self.is_installed('i3lock'):
            self.os_installer.install_i3lock()

        if self.style:
            configuration = I3LockConfiguration(self.SETTINGS_PATH.joinpath('i3lock/lock.sh'), Path('/usr/bin/lock'))
            configuration.setup(self.style.components['i3lock'])

    def install_polybar(self) -> None:
        """Installs polybar package."""
        if not self.is_installed('polybar'):
            self.os_installer.install_polybar()

        if self.style:
            polybar_settings = self.SETTINGS_PATH.joinpath('polybar/config')

            polybar_config = self.CONFIG_DIRECTORY_PATH.joinpath('polybar')
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
        """Installs picom package."""
        if not self.is_installed('picom'):
            self.os_installer.install_picom()

        if self.style:
            picom_config = self.CONFIG_DIRECTORY_PATH.joinpath('picom')
            picom_config.mkdir(parents=True, exist_ok=True)

            configuration = PicomConfiguration(self.SETTINGS_PATH.joinpath('picom/picom.conf'), picom_config)
            configuration.setup(self.style.components['picom'])

    def install_rofi(self) -> None:
        """Installs rofi package."""
        if not self.is_installed('rofi'):
            self.os_installer.install_rofi()

        if self.style:
            shutil.copy(
                self.SETTINGS_PATH.joinpath('polybar/scripts/themes/powermenu_alt.rasi'),
                self.CONFIG_DIRECTORY_PATH.joinpath('polybar/scripts/themes/powermenu_alt.rasi'),
            )

            configuration_rofi = RofiConfiguration(
                self.SETTINGS_PATH.joinpath('rofi/themes/nord.rasi'),
                self.CONFIG_DIRECTORY_PATH.joinpath('rofi/themes/nord.rasi'),
            )
            configuration_rofi.setup(self.style.components['rofi'])

            configuration_rofi_menu = RofiMenuConfiguration(
                self.SETTINGS_PATH.joinpath('polybar/scripts/themes/colors.rasi'),
                self.CONFIG_DIRECTORY_PATH.joinpath('polybar/scripts/themes/colors.rasi'),
            )
            configuration_rofi_menu.setup(self.style.components['rofi_menu'])

    def install_dunst(self) -> None:
        """Installs dunst package."""
        if not self.is_installed('dunst'):
            self.os_installer.install_dunst()

        if self.style:
            dunst_config = self.CONFIG_DIRECTORY_PATH.joinpath('dunst')
            dunst_config.mkdir(parents=True, exist_ok=True)

            configuration = DunstConfiguration(self.SETTINGS_PATH.joinpath('dunst/dunstrc'), dunst_config)
            configuration.setup(self.style.components['dunst'])

    def install_ranger(self) -> None:
        """Installs ranger package."""
        if not self.is_installed('ranger'):
            self.os_installer.install_ranger()

        logging.info('configuring ranger...')

        ranger_config_directory = self.CONFIG_DIRECTORY_PATH.joinpath('ranger')
        ranger_settings_directory = self.SETTINGS_PATH.joinpath('ranger')
        self.run_shell(
            f'''
            ranger --copy-config all
            cp -r "{ranger_settings_directory}"/* {ranger_config_directory}/
            sudo mkdir -p /root/.config
            sudo ln -s -f $(realpath {ranger_config_directory}) /root/.config/ranger

            # install ranger plugins
            mkdir -p {ranger_config_directory}/pluggins
            if [[ ! -d {ranger_config_directory}/plugins/ranger_devicons ]]; then
                git clone https://github.com/alexanderjeurissen/ranger_devicons \
                    {ranger_config_directory}/plugins/ranger_devicons
            fi
            '''
        )

    def install_vscode(self) -> None:
        """Installs vscode package."""
        if (not self.is_installed('code')) or click.confirm('Do you want to update "vscode"?'):
            self.os_installer.install_vscode()

    def install_rust(self) -> None:
        """Installs rust package."""
        if not self.is_installed('rustc'):
            self.os_installer.install_rust()

    def install_alacritty(self) -> None:
        """Installs alacritty terminal emulator."""
        if not self.is_installed('alacritty'):
            self.os_installer.install_alacritty()

        if self.style:
            alacrity_config = self.CONFIG_DIRECTORY_PATH.joinpath('alacritty')
            alacrity_config.mkdir(parents=True, exist_ok=True)

            configuration = AlacrittyConfiguration(
                self.SETTINGS_PATH.joinpath('alacritty/alacritty.yml'), alacrity_config
            )
            configuration.setup(self.style.components['alacritty'])

    def install_btop(self) -> None:
        """Installs btop resource monitor."""
        if not self.is_installed('btop'):
            self.os_installer.install_btop()

    def install_dockly(self) -> None:
        """Installs dockly docker manager."""
        if not self.is_installed('dockly'):
            self.os_installer.install_dockly()

    def install_lazygit(self) -> None:
        """Installs lazygit terminal UI for git commands."""
        if not self.is_installed('lazygit'):
            self.os_installer.install_lazygit()

    def install_tmux(self) -> None:
        """Installs tmux terminal multiplexer."""
        if not self.is_installed('tmux'):
            self.os_installer.install_tmux()

        logging.info('configuring tmux...')

        tmux_tpm_directory = Path('~/.tmux/plugins/tpm').expanduser()
        if not tmux_tpm_directory.exists():
            self.run_shell(
                f'''
                git clone https://github.com/tmux-plugins/tpm "{tmux_tpm_directory}"
                '''
            )

        tmux_config_file = Path('~/.tmux.conf').expanduser()
        tmux_settings_file = self.SETTINGS_PATH.joinpath('tmux/tmux.conf')
        self.run_shell(
            f'''
            cp "{tmux_settings_file}" "{tmux_config_file}"
            sudo ln -s -f "{tmux_config_file}" /root/.tmux.conf
            '''
        )

    def install_firefox(self) -> None:
        """Installs firefox web browser."""
        if not self.is_installed('firefox'):
            self.os_installer.install_firefox()

    def install_bat(self) -> None:
        """Installs bat package."""
        if not self.is_installed('bat'):
            self.os_installer.install_bat()

    def install_lsd(self) -> None:
        """Installs lsd package."""
        if not self.is_installed('lsd'):
            self.os_installer.install_lsd()

    def install_fzf(self) -> None:
        """Installs fzf general-purpose command-line fuzzy finder."""
        if not self.is_installed('fzf'):
            self.os_installer.install_fzf()

        if click.confirm('Do you want to install "fzf_preview"?'):
            finder_source = self.SETTINGS_PATH.joinpath('fzf/fzf_preview')
            self.run_shell(f'sudo cp {finder_source} /usr/bin/fzf_preview')

    def install_ueberzug(self) -> None:
        """Installs ueberzug terminal image visualizer."""
        if not self.is_installed('ueberzug'):
            self.os_installer.install_ueberzug()

    def install_fonts_nerd(self) -> None:
        """Installs nerd fonts."""
        if not os.path.exists('/usr/local/share/fonts/NerdFonts'):
            self.os_installer.install_fonts_nerd()

    def install_powerlevel10k(self) -> None:
        """Installs powerlevel10k zsh."""
        if not os.path.exists('/usr/local/share/powerlevel10k/powerlevel10k.zsh-theme'):
            self.os_installer.install_powerlevel10k()

        shutil.copyfile(self.SETTINGS_PATH.joinpath('zsh/.zshrc'), Path('~/.zshrc').expanduser())

        if not os.path.exists('/root/.zshrc'):
            self.run_shell('sudo su -c "zsh"')

        self.run_shell(
            '''
            sudo ln -s -f $(realpath ~/.zshrc) /root/.zshrc

            user=$(whoami)

            sudo usermod --shell /usr/bin/zsh ${user}
            sudo usermod --shell /usr/bin/zsh root

            sudo chown ${user}:${user} /root/.cache -R || true
            sudo chown ${user}:${user} /root/.local -R || true
            '''
        )

        if not os.path.exists('/usr/share/zsh-plugins/'):
            logging.info('configuring zsh plugin directory...')

            self.run_shell(
                '''
                sudo mkdir -p /usr/share/zsh-plugins/
                sudo chown $(whoami):$(whoami) /usr/share/zsh-plugins/
                '''
            )

        zsh_rc_path = Path('~/.zshrc').expanduser()

        plugins_path = Path('~/.zsh/').expanduser()
        plugins_path.mkdir(parents=True, exist_ok=True)

        if ('zsh-autosuggestions.zsh' not in zsh_rc_path.read_text(encoding='UTF-8')) and click.confirm(
            'Do you want to install "zsh-autosuggestions.zsh" zsh plugging?'
        ):
            logging.info('installing zsh plugin: zsh-autosuggestions.zsh...')

            self.run_shell(
                f'''
                if [[ ! -d "{plugins_path}/zsh-autosuggestions" ]]; then
                    git clone https://github.com/zsh-users/zsh-autosuggestions {plugins_path}/zsh-autosuggestions
                fi
                echo "source {plugins_path}/zsh-autosuggestions/zsh-autosuggestions.zsh" >> {zsh_rc_path}
                '''
            )

        if ('zsh-syntax-highlighting.zsh' not in zsh_rc_path.read_text(encoding='UTF-8')) and click.confirm(
            'Do you want to install "zsh-syntax-highlighting.zsh" zsh plugging?'
        ):
            logging.info('installing zsh plugin: zsh-syntax-highlighting.zsh...')

            self.run_shell(
                f'''
                if [[ ! -d "{plugins_path}/zsh-syntax-highlighting" ]]; then
                    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
                        {plugins_path}/zsh-syntax-highlighting
                fi
                echo "source {plugins_path}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> {zsh_rc_path}
                '''
            )

        if ('sudo.plugin.zsh' not in zsh_rc_path.read_text(encoding='UTF-8')) and click.confirm(
            'Do you want to install "sudo.plugin.zsh" zsh plugging?'
        ):
            logging.info('installing zsh plugin: sudo.plugin.zsh...')

            self.run_shell(
                f'''
                if [[ ! -d "{plugins_path}/zsh-plugins/" ]]; then
                    mkdir -p {plugins_path}/zsh-plugins/
                    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh \
                        -P {plugins_path}/zsh-plugins/
                fi
                echo "source {plugins_path}/zsh-plugins/sudo.plugin.zsh" >> {zsh_rc_path}
                '''
            )

    def install_neovim(self) -> None:
        """Installs neovim editor."""
        if not self.is_installed('nvim'):
            self.os_installer.install_neovim()
