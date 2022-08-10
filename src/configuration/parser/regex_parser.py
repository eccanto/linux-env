"""Package configuration file parsers - Plain text files."""

import logging
import re
from pathlib import Path
from typing import Any

from src.configuration.parser.base_parser import BaseParser


class RegexParser(BaseParser):
    """Plain text files parser."""

    def read_data(self) -> str:
        """Reads the plain file contents.

        :returns: A string that contains the file content.
        """
        return self.path.read_text()

    def write(self, output: Path) -> None:
        """Writes the current changes to a plain file.

        :param output: The output file path.
        """
        with open(output, 'w', encoding='UTF-8') as raw_file:
            raw_file.write(self._data)

    def update(self, data: Any) -> None:
        """Updates the current changes.

        :param data: An object that contains the changes to be applied.
        """
        for regex, value in [item.values() for item in data]:
            current_value = re.search(rf'({regex})', self._data)

            logging.debug('replacing "%s" by "%s"', current_value, value)

            self._data = re.subn(regex, value, self._data, 1)[0]
