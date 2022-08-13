#!/usr/bin/env python3
"""Entry point to set up the local environment."""

import logging
import shutil
from pathlib import Path
from typing import List

import click
import coloredlogs

from src.configuration.parser.yaml_parser import YamlParser
from src.packages.installer import PackagesInstaller


CUSTOM_SETTINGS = Path('.custom_settings')
DEFAULT_SETTINGS = Path('settings')

DEPENDENCIES = Path('.dependencies')

COMPONENTS_INSTALL = PackagesInstaller.component_methods()


@click.command()
@click.option('-s', '--style_path', help='Yaml style path.', required=True, type=click.Path(exists=True))
@click.option(
    '-c',
    '--component',
    'components',
    multiple=True,
    type=click.Choice(COMPONENTS_INSTALL.keys()),
    help=(
        'Components to be installed. The --component option can be specified several times, '
        'if no component is indicated all of them will be installed'
    ),
)
def main(style_path: str, components: List[str]) -> None:
    """Setup linux environment.

    :param style_path: The file path that describes the style to be used.
    """
    coloredlogs.install(fmt='%(asctime)s-%(name)s-%(levelname)s: %(message)s', level=logging.INFO)

    if not components:
        components = COMPONENTS_INSTALL.keys()

    if CUSTOM_SETTINGS.exists():
        shutil.rmtree(CUSTOM_SETTINGS)

    DEPENDENCIES.mkdir(parents=True, exist_ok=True)

    style = YamlParser(Path(style_path))

    shutil.copytree(DEFAULT_SETTINGS, CUSTOM_SETTINGS)

    logging.info('setting wallpaper "%s"...', style.general.base.wallpaper)
    shutil.copy(style.general.base.wallpaper, Path('~/.wallpaper.jpg').expanduser())

    installer = PackagesInstaller(DEPENDENCIES, CUSTOM_SETTINGS, style)
    for component in components:
        COMPONENTS_INSTALL[component](installer)

    logging.info('done!')


if __name__ == '__main__':
    main()  # pylint: disable=no-value-for-parameter
