"""Package configuration file parsers - Ini files."""

import configparser
from pathlib import Path
from typing import Any

from dotmap import DotMap

from src.configuration.parser.base_parser import BaseParser


class IniParser(BaseParser):
    """Ini files parser."""

    def read_data(self) -> Any:
        """Reads the ini file contents.

        :returns: An object that contains the ini file sections.
        """
        config = configparser.RawConfigParser()
        config.read(self.path)
        return DotMap(config._sections)  # type: ignore  # pylint: disable=protected-access

    def write(self, output: Path) -> None:
        """Writes the current changes to a ini file.

        :param output: The output file path.
        """
        with open(output, 'w', encoding='UTF-8') as config_file:
            config = configparser.RawConfigParser()
            config.read_dict(self._data.toDict())
            config.write(config_file)
