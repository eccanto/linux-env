**`WIP`**

# Overview
configuration of my Linux environment


# Table of contents

* [Get started](#get-started)
  * [Install dependencies](#install-dependencies)
  * [Setup environment](#setup-environment)
* [Static code analysis tools](#static-code-analysis-tools)
  * [Find Problems](#find-problems)
* [License](#license)
* [Changelog](#changelog)

# Get started

## Create a Python virtual environment

```bash
# create
python3 -m venv .venv

# activate
source .venv/bin/activate
```

## Install dependencies

```bash
pip install -r requirements.txt
```

## Setup environment

##
```bash
python main.py -s themes/colored_simple.ym
```

# Tools

## tty-clock

Open digital clock in terminal

```bash
tty-clock -ct -f "%H:%M, %d %b %Y"
```

## VSCode

### Shortcuts

| shortcut                 | description                             |
| -                        | -                                       |
| Ctrl + B                 | toggle (show and hide) explorer view    |
| Alt  + [Up,Down]         | move line(s) to [Up,Down]               |
| Alt  + [Left,Right]      | focus [Left,Right] group                |
| Ctrl + Shift + D         | go to definition                        |
| Ctrl + [Up,Down]         | scroll to [Up,Down]                     |
| Alt  + Shift + [Up,Down] | mark select multi-line [Up,Down]        |
| Alt  + ,                 | go to back                              |
| Alt  + .                 | go to forward                           |
| Ctrl + Enter             | open file in split view [from explorer] |


## Ranger

### Shortcuts

| shortcut | description            |
| -        | -                      |
| i        | display file (preview) |
| Alt + j  | scroll preview down    |
| Alt + k  | scroll preview up      |


# Useful

## Change keyboard layout

```bash
# change to Español latam
setxkbmap -layout latam
```

To make this configuration permanent you can add "setxkbmap -layout latam" to `~/.config/i3/config` or use another
autostart configuration file.

```bash
# Autostart applications
exec_always --no-startup-id setxkbmap -layout latam
```

## Search icons in system fonts

```bash
sudo apt install gucharmap

gucharmap
```

## Generate monitor profile

```bash
arandr
```

relocate the monitors and save the profile "Layout -> Save as" (bash file). You can generate multiple profiles for different situations (home, office, etc.).

## reconfigure powerlevel10k

```bash
p10k configure
```

## powerlevel10k plugin - zsh-syntax-highlighting - disabled the underline

Add the following to your .zshrc:

```bash
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
```

# fix polybar brightness module on amd card

1. get card name:

    ```bash
    $ ls -1 /sys/class/backlight/
    amdgpu_bl0
    ```

2. update polybar configuration file:

    ```bash
    # file: ~/.config/polybar/config
    # card = intel_backlight
    card = amdgpu_bl0
    ```

3. restart polybar

    ```bash
    pkill polybar && polybar i3wmthemer_bar &
    ```

4. [optional] if permission denied

    ```bash
    sudo chmod a+rw /sys/class/backlight/$(ls /sys/class/backlight/ | head -n 1)/brightness
    ```

# Static code analysis tools

## Find Problems

Checkers statically analyzes the code to find problems.

```bash
bash code_checkers.sh  # run pylint, prospector, black and isort
```

Tools used:
- [black](https://github.com/psf/black): Black is the uncompromising Python code formatter.
- [isort](https://pycqa.github.io/isort/): Python utility / library to sort imports alphabetically, and automatically separated into sections and by type.
- [prospector](https://github.com/PyCQA/prospector): Prospector is a tool to analyse Python code and output information about errors, potential problems, convention violations and complexity.

  Tools executed by Prospector:
  - [pylint](https://github.com/PyCQA/pylint): Pylint is a Python static code analysis tool which looks for programming errors,   helps enforcing a coding standard, sniffs for code smells and offers simple refactoring suggestions.
  - [bandit](https://github.com/PyCQA/bandit): Bandit is a tool designed to find common security issues.
  - [dodgy](https://github.com/landscapeio/dodgy): It is a series of simple regular expressions designed to detect things such as accidental SCM diff checkins, or passwords or secret keys hard coded into files.
  - [mccabe](https://github.com/PyCQA/mccabe): Complexity checker.
  - [mypy](https://github.com/python/mypy): Mypy is an optional static type checker for Python.
  - [pep257](https://github.com/PyCQA/pydocstyle): pep257 is a static analysis tool for checking compliance with Python PEP 257.
  - [pep8](https://pep8.readthedocs.io/en/release-1.7.x/): pep8 is a tool to check your Python code against some of the style conventions in PEP 8.
  - [pyflakes](https://github.com/PyCQA/pyflakes): Pyflakes analyzes programs and detects various errors.
  - [pyroma](https://github.com/regebro/pyroma): Pyroma is a product aimed at giving a rating of how well a Python project complies with the best practices of the Python packaging ecosystem, primarily PyPI, pip, Distribute etc, as well as a list of issues that could be improved.

# Compatibility

- Ubuntu 22.04 LTS [locally tested]
- Ubuntu 18.04 LTS [locally tested]

# Disclaimer

I am not responsible for any harm done to your PC by anything in the repository. Use everything with caution!

# License

[MIT](./LICENSE)

# Changelog

- 1.0.0 - Initial release.
