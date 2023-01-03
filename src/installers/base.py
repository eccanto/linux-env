"""Class in charge of managing the packages/applications installation."""

import logging
import shutil
import subprocess  # nosec #B404
from abc import ABC, abstractmethod
from pathlib import Path
from shutil import which
from types import FunctionType
from typing import Any, Dict


class BaseInstaller(ABC):  # pylint: disable=too-many-public-methods
    """Class in charge of managing the installation of the required packages."""

    DEPENDENCIES_PATH = Path('.dependencies')

    BASE_SETTINGS_PATH = Path('settings')
    SETTINGS_PATH = Path('.custom_settings')

    @classmethod
    def prepare(cls) -> None:
        """Prepares environment dependencies."""
        cls.DEPENDENCIES_PATH.mkdir(parents=True, exist_ok=True)

        if cls.SETTINGS_PATH.exists():
            shutil.rmtree(cls.SETTINGS_PATH)
        shutil.copytree(cls.BASE_SETTINGS_PATH, cls.SETTINGS_PATH)

    @classmethod
    def required_methods(cls) -> Dict[str, Any]:
        """Gets the required installer methods."""
        return {cls.install_system_requirements.__name__: cls.install_system_requirements}

    @classmethod
    def install_methods(cls, prefix: str = 'install_') -> Dict[str, Any]:
        """Gets the installer methods.

        :param prefix: Method name prefix to filter the installation methods.
        """
        return {
            name: method
            for name, method in cls.__dict__.items()
            if isinstance(method, FunctionType) and name.startswith(prefix)
        }

    @staticmethod
    def run_shell(script: str) -> None:
        """Runs a shell script.

        :param script: The script to run.
        """
        subprocess.run(
            f'''
            set -eux
            {script}
            ''',
            shell=True,  # nosec #B602
            check=True,
            executable='/bin/bash',
        )

    @staticmethod
    def is_installed(package_name: str) -> bool:
        """Checks whether a package is installed.

        :param package_name: The package name.
        """
        return which(package_name) is not None

    @abstractmethod
    def install_system_requirements(self) -> None:
        """Installs system requirements."""

    @abstractmethod
    def install_speedtest(self) -> None:
        """Installs speedtest client."""

    @abstractmethod
    def install_i3gaps(self) -> None:
        """Installs i3 gaps package."""

    @abstractmethod
    def install_i3lock(self) -> None:
        """Installs i3 lock package."""

    @abstractmethod
    def install_polybar(self) -> None:
        """Installs polybar package."""

    @abstractmethod
    def install_picom(self) -> None:
        """Installs picom package."""

    @abstractmethod
    def install_rofi(self) -> None:
        """Installs rofi package."""

    @abstractmethod
    def install_dunst(self) -> None:
        """Installs dunst package."""

    @abstractmethod
    def install_ranger(self) -> None:
        """Installs ranger package."""

    @abstractmethod
    def install_vscode(self) -> None:
        """Installs vscode package."""

    @abstractmethod
    def install_rust(self) -> None:
        """Installs rust package."""

    @abstractmethod
    def install_alacritty(self) -> None:
        """Installs alacritty terminal emulator."""

    @abstractmethod
    def install_btop(self) -> None:
        """Installs btop resource monitor."""

    @abstractmethod
    def install_dockly(self) -> None:
        """Installs dockly docker manager."""

    @abstractmethod
    def install_lazygit(self) -> None:
        """Installs lazygit terminal UI for git commands."""

    @abstractmethod
    def install_tmux(self) -> None:
        """Installs tmux terminal multiplexer."""

    @abstractmethod
    def install_firefox(self) -> None:
        """Installs firefox web browser."""

    @abstractmethod
    def install_bat(self) -> None:
        """Installs bat package."""

    @abstractmethod
    def install_lsd(self) -> None:
        """Installs lsd package."""

    @abstractmethod
    def install_fzf(self) -> None:
        """Installs fzf general-purpose command-line fuzzy finder."""

    @abstractmethod
    def install_ueberzug(self) -> None:
        """Installs ueberzug terminal image visualizer."""

    @abstractmethod
    def install_fonts_nerd(self) -> None:
        """Installs nerd fonts."""

    @abstractmethod
    def install_powerlevel10k(self) -> None:
        """Installs powerlevel10k zsh."""

    @abstractmethod
    def install_neovim(self) -> None:
        """Installs neovim editor."""

    def install_bsnotifier(self) -> None:
        """Installs bsnotifier package (pip)."""
        logging.info('installing bsnotifier...')

        self.run_shell(
            '''
            pip install -U bsnotifier

            BSNOTIFIER_PATH="$(which bsnotifier)"
            sudo ln -fs "${BSNOTIFIER_PATH}" /usr/bin/bsnotifier
            '''
        )
