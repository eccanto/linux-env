import configparser
from pathlib import Path
from typing import Any

from dotmap import DotMap

from src.configuration.parser.base_parser import BaseParser


class IniParser(BaseParser):
    def read_data(self, path: Path) -> Any:
        config = configparser.RawConfigParser()
        config.read(path)
        return DotMap(config._sections)  # type: ignore  # pylint: disable=protected-access

    def write(self, output: Path) -> None:
        with open(output, 'w', encoding='UTF-8') as config_file:
            config = configparser.RawConfigParser()
            config.read_dict(self._data.toDict())
            config.write(config_file)
