"""Module in charge to apply the changes to the configuration files - Base class."""

import logging
import shutil
import subprocess  # nosec #B404
import time
import zipfile
from abc import ABC
from pathlib import Path
from typing import Optional, Type

from dotmap import DotMap

from src.configuration.parser.base_parser import BaseParser


class BaseConfiguration(ABC):
    """Base configurator."""

    _NAME: Optional[str] = None
    _RELOAD_COMMAND: Optional[str] = None
    _PARSER: Optional[Type[BaseParser]] = None

    def __init__(self, config_path: Path, installation_path: Path) -> None:
        """Constructor method.

        :param config_path: The configuration file directory path.
        :param installation_path: The installation file or directory path.
        """
        self.config_path = config_path
        self.installation_path = installation_path.expanduser()

        self.configuration = self.make_parser(self.get_parser(), config_path)

    def update(self, style: DotMap) -> None:
        """Updates the configurations.

        :param style: An object representing the style to be applied.
        """
        self.configuration.update(style)
        self.configuration.write(self.config_path)

    def install(self) -> None:
        """Installs the configurations."""
        try:
            shutil.copy(self.config_path, self.installation_path)
        except PermissionError:
            subprocess.run(
                f'sudo cp {self.config_path} {self.installation_path}', shell=True, check=True  # nosec #B602
            )

    def backup(self) -> None:
        """Backups the configurations."""
        if self.installation_path.exists():
            backup_zip = f'{self.installation_path}_backup_{time.time()}'

            logging.info('generating %s local configurations backup "%s.zip"...', self.get_name(), backup_zip)

            if self.installation_path.is_dir():
                shutil.make_archive(backup_zip, 'zip', self.installation_path)
            else:
                try:
                    with zipfile.ZipFile(f'{backup_zip}.zip', 'w', compression=zipfile.ZIP_DEFLATED) as zip_file:
                        zip_file.write(self.installation_path, self.installation_path.name)
                except PermissionError:
                    subprocess.run(
                        f'sudo zip {backup_zip}.zip {self.installation_path}', shell=True, check=True  # nosec #B602
                    )

    @classmethod
    def reload(cls) -> None:
        """Reloads the configurations."""
        if cls._RELOAD_COMMAND is not None:
            logging.info('reloading %s...', cls.get_name())
            subprocess.run(cls._RELOAD_COMMAND, shell=True, check=True)  # nosec #B602
            logging.info('%s was reloaded', cls.get_name())
        else:
            logging.info('%s reloads itself', cls.get_name())

    def setup(self, style: DotMap) -> None:
        """Setup the configurations."""
        self.update(style)
        self.backup()
        self.install()
        self.reload()

    @classmethod
    def get_name(cls) -> str:
        """Gets the application name."""
        if cls._NAME is None:
            raise ValueError('Application name is required')
        return cls._NAME

    @classmethod
    def get_parser(cls) -> Type[BaseParser]:
        """Gets the application configuration parser."""
        if cls._PARSER is None:
            raise ValueError('Parser class is required')
        return cls._PARSER

    @staticmethod
    def make_parser(parser_class: Type[BaseParser], config_path: Path) -> BaseParser:
        """Makes a parser instance of a class."""
        return parser_class(config_path)
