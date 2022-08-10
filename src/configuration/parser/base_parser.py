"""Package configuration file parsers - Base class."""

import collections
from abc import ABC, abstractmethod
from pathlib import Path
from typing import Any


class BaseParser(ABC):
    """Base parser abstract class."""

    def __init__(self, path: Path) -> None:
        """Constructor method.

        :param path: The path to the file to be parsed.
        """
        self.path = path

        self._data = self.read_data()

    @abstractmethod
    def read_data(self) -> Any:
        """Reads the file contents."""

    @abstractmethod
    def write(self, output: Path) -> None:
        """Writes the current changes to a file.

        :param output: The output file path.
        """

    def __getattr__(self, name: str) -> Any:
        """Gets an attribute of the current changes.

        :param name: The attribute name.

        :returns: The value related to the name entered.
        """
        return getattr(self._data, name)

    def update(self, data: Any) -> None:
        """Updates the current changes.

        :param data: An object that contains the changes to be applied.
        """
        self._update_data(self._data, data)

    def _update_data(self, self_data: Any, data: Any) -> Any:
        """Updates the current changes recursively.

        :param self_data: The current changes.
        :param data: An object that contains the changes to be applied.

        :returns: The new current changes.
        """
        for key, value in data.items():
            if isinstance(value, collections.abc.Mapping):
                self_data[key] = self._update_data(self_data.get(key, {}), value)
            else:
                self_data[key] = value
        return self_data
