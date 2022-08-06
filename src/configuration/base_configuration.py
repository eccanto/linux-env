import logging
import shutil
import subprocess
import time
import zipfile
from abc import ABC, abstractmethod
from pathlib import Path

import click
from dotmap import DotMap
from src.configuration.parser.base_parser import BaseParser


class BaseConfiguration(ABC):
    def __init__(self, config_path: Path, installation_path: Path) -> None:
        self.config_path = config_path
        self.installation_path = installation_path.expanduser()

        self.configuration = self.get_parser()(config_path)

        self.installation_path.mkdir(parents=True, exist_ok=True)

    def update(self, style: DotMap) -> None:
        self.configuration.update(style)
        self.configuration.write(self.config_path)

    def install(self) -> None:
        shutil.copy(self.config_path, self.installation_path)

    def backup(self) -> None:
        backup_zip = f'{self.installation_path}_{time.time()}'

        logging.info('generating %s local configurations backup "%s.zip"...', self.get_name(), backup_zip)

        if self.installation_path.is_dir():
            shutil.make_archive(backup_zip, 'zip', self.installation_path)
        else:
            with zipfile.ZipFile(f'{backup_zip}.zip', 'w', compression=zipfile.ZIP_DEFLATED) as zip_file:
                zip_file.write(self.installation_path, self.installation_path.name)

    @classmethod
    def reload(cls) -> None:
        if click.confirm(f'Do you want to reload {cls.get_name()}?', default=True):
            logging.info('reloading %s...', cls.get_name())
            subprocess.run(cls.get_reload_command(), shell=True, check=True)
            logging.info('%s was reloaded', cls.get_name())

    def setup(self, style: DotMap) -> None:
        self.update(style)
        self.backup()
        self.install()
        self.reload()

    @classmethod
    @abstractmethod
    def get_name(cls) -> str:
        pass

    @classmethod
    @abstractmethod
    def get_reload_command(cls) -> str:
        pass

    @classmethod
    @abstractmethod
    def get_parser(self) -> BaseParser:
        pass
