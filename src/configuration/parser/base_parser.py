import collections
from abc import ABC, abstractmethod
from pathlib import Path
from typing import Any


class BaseParser(ABC):
    def __init__(self, path: Path) -> None:
        super().__init__()

        self.path = path

        self._data = self.read_data(path)

    @abstractmethod
    def read_data(self, path: Path) -> Any:
        pass

    @abstractmethod
    def write(self, output: Path) -> None:
        pass

    def __getattr__(self, name: str) -> Any:
        return getattr(self._data, name)

    def update(self, data: Any) -> None:
        self._update_data(self._data, data)

    def _update_data(self, self_data: Any, data: Any) -> Any:
        for key, value in data.items():
            if isinstance(value, collections.abc.Mapping):
                self_data[key] = self._update_data(self_data.get(key, {}), value)
            else:
                self_data[key] = value
        return self_data
