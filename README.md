**`WIP`**

# Overview

Configuration of my Linux environment.

![themes](documentation/themes.gif)

# Table of contents

- [Overview](#overview)
- [Table of contents](#table-of-contents)
- [Get started](#get-started)
  - [Create a Python virtual environment](#create-a-python-virtual-environment)
  - [Install dependencies](#install-dependencies)
  - [Setup environment](#setup-environment)
- [Tools](#tools)
  - [I3](#i3)
    - [Shortcuts](#shortcuts)
  - [I3Lock](#i3lock)
  - [tty-clock](#tty-clock)
  - [fzf preview](#fzf-preview)
  - [Peek](#peek)
  - [VSCode](#vscode)
    - [Shortcuts](#shortcuts-1)
  - [Ranger](#ranger)
    - [Shortcuts](#shortcuts-2)
  - [Neovim](#neovim)
- [Useful](#useful)
  - [Change keyboard layout](#change-keyboard-layout)
  - [Search icons in system fonts](#search-icons-in-system-fonts)
  - [Generate monitor profile](#generate-monitor-profile)
  - [Reconfigure powerlevel10k](#reconfigure-powerlevel10k)
  - [Disable underlining of the powerlevel10k zsh-syntax-highlighting plugin](#disable-underlining-of-the-powerlevel10k-zsh-syntax-highlighting-plugin)
  - [Fix polybar brightness module on amd card](#fix-polybar-brightness-module-on-amd-card)
  - [Set polybar on multiple screens](#set-polybar-on-multiple-screens)
- [Developers](#developers)
  - [Static code analysis tools](#static-code-analysis-tools)
    - [Set up the Git hooks custom directory](#set-up-the-git-hooks-custom-directory)
    - [Python Static Checkers](#python-static-checkers)
- [Compatibility](#compatibility)
- [Disclaimer](#disclaimer)
- [License](#license)
- [Changelog](#changelog)

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
python main.py -s themes/colored_simple.yml
```

# Tools

## I3

[i3](https://i3wm.org/) is a tiling window manager:

![i3 tiling window manager](documentation/i3.png)

### Shortcuts

| shortcut                   | description                                                            |
|----------------------------|------------------------------------------------------------------------|
| Win + u                    | hide borders                                                           |
| Win + y                    | restore borders                                                        |
| Win + n                    | change to "normal" border mode (show window title)                     |
| Win + Shift + q            | kill focused window                                                    |
| Win + Enter                | open Alacritty terminal emulator                                       |
| Win + d                    | open Rofi - Application and executable explorer                        |
| Win + i                    | open Rofi - Application GUIs explorer                                  |
| Win + Escape               | open Rofi - System menu: poweroff, sleep, etc.                         |
| Win + Print                | open flameshot - screenshot capturer                                   |
| Win + l                    | lock screen session                                                    |
| Win + Left                 | focus left window                                                      |
| Win + Right                | focus right window                                                     |
| Win + Down                 | focus down window                                                      |
| Win + Up                   | focus up window                                                        |
| Win + Shift + Left         | move the focused window to left                                        |
| Win + Shift + Right        | move the focused window to right                                       |
| Win + Shift + Down         | move the focused window to down                                        |
| Win + Shift + Up           | move the focused window to up                                          |
| Win + Ctrl + Shift + Left  | move the focused workspace to left                                     |
| Win + Ctrl + Shift + Right | move the focused workspace to right                                    |
| Win + Ctrl + Shift + Down  | move the focused workspace to down                                     |
| Win + Ctrl + Shift + Up    | move the focused workspace to up                                       |
| Win + b                    | workspace back and forth                                               |
| Win + Shift + b            | move window to workspace back_and_forth                                |
| Win + h                    | change split mode to "horizontal"                                      |
| Win + v                    | change split mode to "vertical"                                        |
| Win + f                    | toggle fullscreen mode for the focused window                          |
| Win + s                    | change layout mode to "stacking"                                       |
| Win + w                    | change layout mode to "tabbed"                                         |
| Win + e                    | change layout mode to "toggle split"                                   |
| Win + Shift + Space        | toggle tiling / floating                                               |
| Win + Space                | change focus between tiling / floating windows                         |
| Win + Shift + s            | Sticky floating windows, even if you switch to another workspace       |
| Win + a                    | focus the parent window                                                |
| Win + Shift + Minus        | move the currently focused window to the scratchpad                    |
| Win + Shift                | show the next scratchpad window or hide the focused scratchpad window. |
| Win + Ctrl + Left          | focus left workspace                                                   |
| Win + Ctrl + Right         | focus right workspace                                                  |
| Win + Shift + c            | reload the configuration file                                          |
| Win + Shift + r            | restart i3 inplace                                                     |
| Win + Shift + e            | exit i3                                                                |
| Win + 0                    | Set shut down, restart and locking features                            |
| Win + r                    | enable resize windows mode                                             |
| Win + Shift + g            | enable gap mode                                                        |

## I3Lock

A modern version of i3lock with color functionality and other features ([github](https://github.com/Raymo111/i3lock-color)).

![i3lock command](documentation/i3lock.gif)

**Shortcut**: `< Win + l >`

## tty-clock

Open digital clock in terminal.

```bash
tty-clock -ct -f "%H:%M, %d %b %Y"
```

![tty-clock command](documentation/tty-clock.gif)

## fzf preview

A custom script to preview and open files in your system:

```bash
fzf_preview
```

![fzf_preview command](documentation/fzf_preview.gif)

Depending on the type of file selected, a different application will be used to open it:
- images: `feh -x`
- directories: `code`
- other file types: `nvim`

**Shortcut**: `< Win + c >`

## Peek

Simple screen recorder with an easy to use interface ([github](https://github.com/phw/peek)):

```bash
peek
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

## Neovim

My Neovim configuration: [github](https://github.com/eccanto/nvim-config)

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

Relocate the monitors and save the profile "Layout -> Save as" (bash file). You can generate multiple profiles for different situations (home, office, etc.).

## Reconfigure powerlevel10k

```bash
p10k configure
```

## Disable underlining of the powerlevel10k zsh-syntax-highlighting plugin

Add the following to your `.zshrc`:

```bash
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
```

## Fix polybar brightness module on amd card

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

## Set polybar on multiple screens

1. Create a polybar launcher script:

    ```bash
    # launch_polybar.sh

    if type "xrandr"; then
        for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
            MONITOR=$m polybar --reload i3wmthemer_bar &
        done
    else
        polybar --reload i3wmthemer_bar &
    fi
    ```

2. Edit the polybar config file (`~/.config/polybar/config`):

    ```
    [bar/i3wmthemer_bar]
    monitor = ${env:MONITOR:}
    ...
    ```

3. Kill current polybar:

    ```
    sudo pkill polybar
    ```

4. Run script:

    ```
    bash launch_polybar.sh
    ```

# Developers

## Static code analysis tools

These are the linters that will help us to follow good practices and style guides of our source
code. We will be using the following static analysis tools, which will be executed when generating
a new commit in the repository (**git hooks**).

### Set up the Git hooks custom directory

After cloning the repository run the following command in the repository root:

```bash
git config core.hooksPath .githooks
```

### Python Static Checkers

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
