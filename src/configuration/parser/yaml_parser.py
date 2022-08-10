"""Package configuration file parsers - Yaml files."""

from pathlib import Path
from typing import Any

import yaml
from dotmap import DotMap

from src.configuration.parser.base_parser import BaseParser


def concat_constructor(loader: Any, node: Any) -> str:
    """Yaml constructor to concatenate values."""
    sequence = loader.construct_sequence(node)
    return ' '.join([str(i) for i in sequence])


def format_constructor(loader: Any, node: Any) -> str:
    """Yaml constructor to format values."""
    sequence, value = loader.construct_sequence(node)
    return sequence.format(value)


yaml.add_constructor('!concat', concat_constructor)
yaml.add_constructor('!format', format_constructor)


class YamlParser(BaseParser):
    """Yaml files parser."""

    def read_data(self) -> Any:
        """Reads the yaml file contents.

        :returns: An object that contains the yaml file data.
        """
        with open(self.path, encoding='UTF-8') as yaml_file:
            return DotMap(yaml.full_load(yaml_file))

    def write(self, output: Path) -> None:
        """Writes the current changes to a yaml file.

        :param output: The output file path.
        """
        with open(output, 'w', encoding='UTF-8') as yaml_file:
            yaml.dump(self._data.toDict(), yaml_file)
