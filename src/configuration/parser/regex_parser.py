import logging
import re
from pathlib import Path

from src.configuration.parser.base_parser import BaseParser


class RegexParser(BaseParser):
    def read_data(self, path: Path) -> str:
        return path.read_text()

    def write(self, output: Path) -> None:
        with open(output, 'w') as raw_file:
            raw_file.write(self._data)

    def update(self, data):
        for regex, value in [item.values() for item in data]:
            current_value = re.search(rf'({regex})', self._data)

            logging.debug('replacing "%s" by "%s"', current_value, value)

            self._data = re.subn(regex, value, self._data, 1)[0]
