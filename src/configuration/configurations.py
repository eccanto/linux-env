import logging

from src.configuration.base_configuration import BaseConfiguration
from src.configuration.parser.base_parser import BaseParser
from src.configuration.parser.ini_parser import IniParser
from src.configuration.parser.regex_parser import RegexParser
from src.configuration.parser.yaml_parser import YamlParser


# region ini_configuration

class StaticConfiguration(BaseConfiguration):
    """reaload is required."""

    _NAME = None
    _RELOAD_COMMAND = None
    _PARSER = None

    @classmethod
    def get_name(cls) -> str:
        return cls._NAME

    @classmethod
    def get_reload_command(cls) -> str:
        return cls._RELOAD_COMMAND

    @classmethod
    def get_parser(cls) -> BaseParser:
        return cls._PARSER


class PolybarConfiguration(StaticConfiguration):
    _NAME = 'polybar'
    _RELOAD_COMMAND = 'pkill polybar && polybar i3wmthemer_bar &'
    _PARSER = IniParser


class DunstConfiguration(StaticConfiguration):
    _NAME = 'dunst'
    _RELOAD_COMMAND = 'killall dunst || true'
    _PARSER = IniParser


class I3Configuration(StaticConfiguration):
    _NAME = 'i3'
    _RELOAD_COMMAND = 'i3-msg restart || true'
    _PARSER = RegexParser


# endregion

# region file_configuration

class DynamicConfiguration(BaseConfiguration):
    """reload is not required."""

    _NAME = None
    _PARSER = None

    @classmethod
    def get_name(cls) -> str:
        return cls._NAME

    def reload(cls):
        logging.info('%s reloads itself', cls._NAME)

    @classmethod
    def get_reload_command(cls):
        pass

    @classmethod
    def get_parser(cls) -> BaseParser:
        return cls._PARSER


class AlacrittyConfiguration(DynamicConfiguration):
    _NAME = 'alacritty'
    _PARSER = YamlParser


class I3LockConfiguration(DynamicConfiguration):
    _NAME = 'i3lock'
    _PARSER = RegexParser


class PicomConfiguration(DynamicConfiguration):
    _NAME = 'picom'
    _PARSER = RegexParser


class RofiConfiguration(DynamicConfiguration):
    _NAME = 'rofi'
    _PARSER = RegexParser


class RofiMenuConfiguration(DynamicConfiguration):
    _NAME = 'rofi_menu'
    _PARSER = RegexParser

# endregion
