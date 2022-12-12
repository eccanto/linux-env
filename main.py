#!/usr/bin/env python3
"""Entry point to set up the local environment."""

import logging
import shutil
from itertools import chain
from pathlib import Path
from typing import List

import click
import coloredlogs

from src.configuration.parser.yaml_parser import YamlParser
from src.installer import SystemInstaller


REQUIRED_INSTALLERS = SystemInstaller.required_methods()
PACKAGE_INSTALLERS = SystemInstaller.install_methods()
AVAILABLE_INSTALLERS = {
    name: function for name, function in PACKAGE_INSTALLERS.items() if name not in REQUIRED_INSTALLERS
}


@click.command()
@click.option('-s', '--style', help='Yaml style path.', type=click.Path())
@click.option(
    '-f',
    '--function',
    'functions',
    multiple=True,
    type=click.Choice(list(AVAILABLE_INSTALLERS.keys())),
    help=(
        'Components to be installed. The --component option can be specified several times, '
        'if no component is indicated all of them will be installed'
    ),
)
def main(style: str, functions: List[str]) -> None:
    """Setup linux environment.

    :param style: The file path that describes the style to be used.
    """
    coloredlogs.install(fmt='%(asctime)s-%(name)s-%(levelname)s: %(message)s', level=logging.INFO)

    style_parser = YamlParser(Path(style)) if style else None
    if style_parser:
        logging.info('setting wallpaper "%s"...', style_parser.general.base.wallpaper)
        shutil.copy(style_parser.general.base.wallpaper, Path('~/.wallpaper.jpg').expanduser())

    if not functions:
        functions = list(PACKAGE_INSTALLERS.keys())

    installer = SystemInstaller(style_parser)
    installer.prepare()

    for function in chain(REQUIRED_INSTALLERS.keys(), functions):
        PACKAGE_INSTALLERS[function](installer)

    logging.info('done!')


if __name__ == '__main__':
    main()  # pylint: disable=no-value-for-parameter
