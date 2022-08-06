import logging
import shutil
from pathlib import Path

import click
import coloredlogs

from src.configuration.parser.yaml_parser import YamlParser
from src.packages.installer import PackagesInstaller


CUSTOM_SETTINGS = Path('.custom_settings')
DEFAULT_SETTINGS = Path('settings')

DEPENDENCIES = Path('.dependencies')
LOCAL_CONFIG = Path('~/.config').expanduser()


@click.command()
@click.option('-s', '--style_path', help='Yaml style path.', required=True, type=click.Path(exists=True))
def main(style_path) -> None:
    coloredlogs.install(fmt='%(asctime)s-%(name)s-%(levelname)s: %(message)s', level=logging.INFO)

    if CUSTOM_SETTINGS.exists():
        shutil.rmtree(CUSTOM_SETTINGS)

    DEPENDENCIES.mkdir(parents=True, exist_ok=True)

    style = YamlParser(style_path)

    shutil.copytree(DEFAULT_SETTINGS, CUSTOM_SETTINGS)

    logging.info('setting wallpaper "%s"...', style.general.base.wallpaper)
    shutil.copy(style.general.base.wallpaper, Path('~/.wallpaper.jpg').expanduser())

    installer = PackagesInstaller(DEPENDENCIES, CUSTOM_SETTINGS, LOCAL_CONFIG, style)
    installer.install_requirements()
    installer.install_pip_requirements()
    installer.install_i3_gaps()
    installer.install_i3lock()
    installer.install_polybar()
    installer.install_picom()
    installer.install_vscode()
    installer.install_fonts_awesome()
    installer.install_dunst()
    installer.install_rust()
    installer.install_btop()
    installer.install_dockly()
    installer.install_lazygit()
    installer.install_tmux()
    installer.install_firefox()
    installer.install_rofi()
    installer.install_powerlevel10k()
    installer.install_bat()
    installer.install_lsd()
    installer.install_fzf()
    installer.install_ueberzug()
    installer.install_ranger()
    installer.install_neovim()

    logging.info('done!')


if __name__ == '__main__':
    main()  # pylint: disable=no-value-for-parameter
