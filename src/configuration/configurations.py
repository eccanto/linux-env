from src.configuration.base_configuration import BaseConfiguration
from src.configuration.parser.ini_parser import IniParser
from src.configuration.parser.regex_parser import RegexParser
from src.configuration.parser.yaml_parser import YamlParser


class PolybarConfiguration(BaseConfiguration):
    _NAME = 'polybar'
    _RELOAD_COMMAND = 'pkill polybar && polybar i3wmthemer_bar &'
    _PARSER = IniParser


class DunstConfiguration(BaseConfiguration):
    _NAME = 'dunst'
    _RELOAD_COMMAND = 'killall dunst || true'
    _PARSER = IniParser


class I3Configuration(BaseConfiguration):
    _NAME = 'i3'
    _RELOAD_COMMAND = 'i3-msg restart || true'
    _PARSER = RegexParser


class AlacrittyConfiguration(BaseConfiguration):
    _NAME = 'alacritty'
    _PARSER = YamlParser


class I3LockConfiguration(BaseConfiguration):
    _NAME = 'i3lock'
    _PARSER = RegexParser


class PicomConfiguration(BaseConfiguration):
    _NAME = 'picom'
    _PARSER = RegexParser


class RofiConfiguration(BaseConfiguration):
    _NAME = 'rofi'
    _PARSER = RegexParser


class RofiMenuConfiguration(BaseConfiguration):
    _NAME = 'rofi_menu'
    _PARSER = RegexParser
