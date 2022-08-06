from pathlib import Path
from typing import Any

import yaml
from dotmap import DotMap

from src.configuration.parser.base_parser import BaseParser


def concat_constructor(loader, node):
    sequence = loader.construct_sequence(node)
    return ' '.join([str(i) for i in sequence])


def format_constructor(loader, node):
    sequence, value = loader.construct_sequence(node)
    return sequence.format(value)


yaml.add_constructor('!concat', concat_constructor)
yaml.add_constructor('!format', format_constructor)


class YamlParser(BaseParser):
    def read_data(self, path: Path) -> Any:
        with open(path) as yaml_file:
            return DotMap(yaml.full_load(yaml_file))

    def write(self, output: Path) -> None:
        with open(output, 'w') as yaml_file:
            yaml.dump(self._data.toDict(), yaml_file)
