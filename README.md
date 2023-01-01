# Overview

Configuration of my Linux environment.

![themes](documentation/media/themes.gif)

# Table of contents

- [Get started](#get-started)
  - [Create a Python virtual environment](#create-a-python-virtual-environment)
  - [Install dependencies](#install-dependencies)
  - [Setup environment](#setup-environment)
- [Tools](#tools)
  - [I3](#i3)
  - [I3Lock](#i3lock)
  - [Rofi](#rofi)
    - [Rofi executables explorer](#rofi-executables-explorer)
    - [Rofi applications explorer](#rofi-applications-explorer)
    - [Rofi System menu](#rofi-system-menu)
  - [VSCode](#vscode)
  - [Neovim](#neovim)
  - [Tmux](#tmux)
  - [fzf](#fzf)
  - [fzf preview](#fzf-preview)
  - [Ranger](#ranger)
  - [tty-clock](#tty-clock)
  - [Peek](#peek)
  - [Flameshot](#flameshot)
- [Useful](#useful)
  - [Change keyboard layout](#change-keyboard-layout)
  - [Search icons in system fonts](#search-icons-in-system-fonts)
  - [Generate monitor profile](#generate-monitor-profile)
  - [Reconfigure powerlevel10k](#reconfigure-powerlevel10k)
  - [Disable underlining of the powerlevel10k zsh-syntax-highlighting plugin](#disable-underlining-of-the-powerlevel10k-zsh-syntax-highlighting-plugin)
  - [Fix polybar brightness module on amd card](#fix-polybar-brightness-module-on-amd-card)
  - [Set polybar on multiple screens](#set-polybar-on-multiple-screens)
  - [Remove absolute path from current working directory](#remove-absolute-path-from-current-working-directory)
  - [Change permissions on sys brightness permanently using udev](#change-permissions-on-sys-brightness-permanently-using-udev)
  - [Enter SSH passphrase once](#enter-ssh-passphrase-once)
  - [Bluetooth - a2dp-sink profile connect failed](#bluetooth---a2dp-sink-profile-connect-failed)
- [Developers](#developers)
  - [Add support for a new Linux OS](#add-support-for-a-new-linux-os)
    - [Architecture](#architecture)
    - [Example](#example)
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

![i3 tiling window manager](documentation/media/i3.png)


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

![i3lock command](documentation/media/i3lock.gif)


| shortcut | description                 |
|----------|-----------------------------|
| Win + l  | lock screen session borders |


## Rofi

A window switcher, Application launcher and dmenu replacement ([github](https://github.com/davatorium/rofi)).

### Rofi executables explorer

![Rofi Executables](documentation/media/rofi_executables.gif)

| shortcut | description                    |
|----------|--------------------------------|
| Win + d  | open Rofi executables explorer |

### Rofi applications explorer

![Rofi Applications](documentation/media/rofi_applications.gif)

| shortcut | description                     |
|----------|---------------------------------|
| Win + i  | open Rofi applications explorer |

### Rofi System menu

![Rofi Applications](documentation/media/rofi_system.gif)

| shortcut     | description                     |
|--------------|---------------------------------|
| Win + Escape | open Rofi applications explorer |

## VSCode

[Visual Studio Code](https://code.visualstudio.com/) is a code editor redefined and optimized for building and debugging
modern web and cloud applications.

![VSCode](documentation/media/vscode.png)


| shortcut                    | description                                                |
|-----------------------------|------------------------------------------------------------|
| Ctrl + b                    | if the `editor` is focused: toggle explorer view           |
| Ctrl + b                    | if the `terminal` is focused: focus previous editor group  |
| Alt  + [Left,Right,Up,Down] | focus [Left,Right,Up,Down] group and side bar (circularly) |
| Alt  + Up                   | if the `terminal` is focused: focus previous group         |
| Ctrl + [Left,Right,Up,Down] | move to [Left,Right,Up,Down] group                         |
| Ctrl + Alt + Shift + Right  | resize: increase group view width                          |
| Ctrl + Alt + Shift + Left   | resize: decrease group view width                          |
| Ctrl + Alt + Shift + Up     | resize: increase group view height                         |
| Ctrl + Alt + Shift + Down   | resize: decrease group view height                         |
| Ctrl + m                    | open markdown preview on the Side                          |
| Ctrl + g                    | go to line/column                                          |
| Ctrl + Space                | search suggestions                                         |
| Ctrl + Shift + [Up,Down]    | move lines [Up,Down]                                       |
| Ctrl + Shift + d            | go to definition                                           |
| Ctrl + [Up,Down]            | scroll to [Up,Down]                                        |
| Alt  + Shift + [Left,Right] | select words [Left,Right]                                  |
| Alt  + Shift + [Up,Down]    | mark select multi-line [Up,Down]                           |
| Alt  + ,                    | go to back                                                 |
| Alt  + .                    | go to forward                                              |
| Ctrl + Enter                | open file in split view [from explorer view]               |

## Neovim

My Neovim configuration: [github](https://github.com/eccanto/nvim-config)

![Neovim](documentation/media/neovim.gif)

## Tmux

tmux is a terminal multiplexer: it enables a number of terminals to be created, accessed, and controlled from a single
screen. tmux may be detached from a screen and continue running in the background, then later reattached.
([github](https://github.com/tmux/tmux)).

![Tmux](documentation/media/tmux.gif)

| shortcut                    | description                          |
|-----------------------------|--------------------------------------|
| tmux                        | start new                            |
| tmux new -s [NAME]          | start new with session name          |
| tmux a                      | attach                               |
| tmux a -t [NAME]            | attach to named                      |
| tmux ls                     | list sessions                        |
| tmux kill-session -t [NAME] | kill session                         |
| tmux kill-server            | kill server (restart configurations) |
| [Ctrl + b] + Ctrl + s       | save tmux state (tmux-resurrect)     |
| [Ctrl + b] + Ctrl + r       | restore tmux state (tmux-resurrect)  |
| Alt + n                     | create window                        |
| Alt + Tab                   | next window                          |
| Alt + Left                  | select left pane                     |
| Alt + Right                 | select right pane                    |
| Alt + Up                    | select up pane                       |
| Alt + Down                  | select down pane                     |
| Alt + Shift + Left          | split left pane                      |
| Alt + Shift + Right         | split right pane                     |
| Alt + Shift + Up            | split up pane                        |
| Alt + Shift + Down          | split down pane                      |
| Alt + 4                     | resize pane to left                  |
| Alt + 6                     | resize pane to right                 |
| Alt + 8                     | resize pane to up                    |
| Alt + 2                     | resize pane to down                  |
| [Ctrl + b] s                | list sessions                        |
| [Ctrl + b] c                | create window                        |
| [Ctrl + b] w                | list windows                         |
| [Ctrl + b] n                | next window                          |
| [Ctrl + b] p                | previous window                      |
| [Ctrl + b] f                | find window                          |
| [Ctrl + b] ,                | rename window                        |
| [Ctrl + b] &                | kill window                          |
| [Ctrl + b] %                | vertical split                       |
| [Ctrl + b] "                | horizontal split                     |
| [Ctrl + b] o                | swap panes                           |
| [Ctrl + b] q                | show pane numbers                    |
| [Ctrl + b] x                | kill pane                            |
| [Ctrl + b] d                | detach tmux                          |

## fzf

fzf is a general-purpose command-line fuzzy finder ([github](https://github.com/junegunn/fzf)).

![fzf command](documentation/media/fzf.gif)

| shortcut | description                   |
|----------|-------------------------------|
| Ctrl + r | find in history from terminal |
| Ctrl + t | find path from terminal       |

## fzf preview

A custom script to preview and open files in your system:

```bash
fzf_preview
```

![fzf_preview command](documentation/media/fzf_preview.gif)

Depending on the type of file selected, a different application will be used to open it:
- images: `feh -x`
- directories: `code`
- other file types: `nvim`


| shortcut | description                                         |
|----------|-----------------------------------------------------|
| Win + c  | open fzf_preview in a new alacritty floating window |

## Ranger

A VIM-inspired filemanager for the console ([github](https://github.com/ranger/ranger)).

![Ranger](documentation/media/ranger.gif)


| shortcut  | description                     |
|-----------|---------------------------------|
| i         | display file (preview)          |
| Shift + s | open shell on current directory |
| F2        | rename selected file/directory  |
| yy        | copy selected file/directory    |
| pp        | paste selected file/directory   |
| dD        | delete selected file/directory  |
| Alt   + j | scroll preview down             |
| Alt   + k | scroll preview up               |
| Ctrl  + r | reset                           |
| Shift + w | display logs                    |

## tty-clock

Open digital clock in terminal.

```bash
tty-clock -ct -f "%H:%M, %d %b %Y"
```

![tty-clock command](documentation/tty-media/clock.gif)

## Peek

Simple screen recorder with an easy to use interface ([github](https://github.com/phw/peek)):

```bash
peek
```

![Peek](documentation/media/peek.png)

## Flameshot

Powerful yet simple to use screenshot software ([github](https://github.com/flameshot-org/flameshot)).

![Flameshot](documentation/media/flameshot.gif)

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

## Remove absolute path from current working directory

Edit `~/.p10k.zsh`, search for `POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER` and change its value to `first`:

```bash
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=first
```

![p10k](documentation/media/p10k_truncate_path.png)

## Change permissions on sys brightness permanently using udev

1. Add your user to `video` group:

    ```bash
    sudo usermod -a -G video <YOUR_USERNAME>
    ```

2. Get your video system kernel (`YOUR_KERNEL`) running this command:

    ```bash
    # get <YOUR_KERNEL>
    ls /sys/class/backlight/ | head -n 1
    ```

3. Create/edit `/etc/udev/rules.d/backlight.rules` file:

    ```bash
    ACTION=="change", SUBSYSTEM=="backlight", KERNEL=="<YOUR_KERNEL>", RUN+="/usr/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="change", SUBSYSTEM=="backlight", KERNEL=="<YOUR_KERNEL>", RUN+="/usr/bin/chmod g+w /sys/class/backlight/%k/brightness"
    ```

4. restart your system.

## Enter SSH passphrase once

1. Install dependencies:

    ```bash
    sudo apt install keychain
    ```

2. Configure git, create/edit `~/.ssh/config` file (`YOUR_REMOTE_HOST` example: "github.com", and `YOUR_SSH_KEY` example: "~/.ssh/id_rsa"):

    ```sshconfig
    Host <YOUR_REMOTE_HOST>
        IgnoreUnknown UseKeychain
        UseKeychain yes
        AddKeysToAgent yes
        IdentityFile <YOUR_SSH_KEY>
    ```

    Example with multiple hosts:

    ```sshconfig
    Host *
        IgnoreUnknown UseKeychain
        UseKeychain yes
        AddKeysToAgent yes

    Host github.com
        IdentityFile ~/.ssh/github

    Host <COMPANY_HOST>
        IdentityFile ~/.ssh/git_company
        Port <COMPANY_PORT>
    ```

3. Change git config file mode:

    ```bash
    chmod 644 ~/.ssh/config
    ```

4. Add keychain to profile file (example: `~/.zshrc`, `~/.bashrc`, etc.)

    ```bash
    ...

    eval $(keychain -q --noask --eval id_rsa)
    ```

## Bluetooth - a2dp-sink profile connect failed

When I try to connect to any headphone, blueman throws:

```bash
blueman.bluez.errors.DBusFailedError: Protocol not available.
```

In logs there are pretty similar errors:

```bash
... bluetoothd[000]: a2dp-sink profile connect failed for 00:00:00:00:00
```

To solve it, follow these steps:

1. Run the following commands:

    ```bash
    sudo apt-get install pulseaudio-module-bluetooth
    ```

2. Adding the `module-bluez5-discover` at the end of the pulseaudio `/etc/pulse/default.pa config`:

    ```config
    load-module module-bluez5-discover
    ```

3. Run the following commands:

    ```bash
    sudo killall pulseaudio
    pulseaudio --start
    sudo systemctl restart bluetooth
    ```

# Developers

## Add support for a new Linux OS

### Architecture

The following diagram describes the installers basic architecture. To support a new Linux OS you must create an installer class **`YourOS`**`Installer` that implements all the abstract methods of `BaseInstaller` class and register it in the `SystemInstaller:OS_INSTALLERS` mapping.

![Instsallers architecture](documentation/architecture/diagram.png)

### Example

Create an installer class that implements all abstract methods of the `BaseInstaller` class:

```python
# str/installers/ubuntu.py

...

class UbuntuInstaller(BaseInstaller):
    """Class in charge of managing the installation of the required packages on Ubuntu."""

    def install_system_requirements(self) -> None:
        """Installs system requirements."""
        ...

    def install_i3gaps(self) -> None:
        """Installs i3 gaps package."""
        ...

    ...
```

Register the created class and define its compatibility:

```python
# src/installer.py

...

from src.installers.ubuntu import UbuntuInstaller


class SystemInstaller(BaseInstaller):
    """Class in charge of managing the installation and configuration of the required packages."""

    OS_INSTALLERS = {
        ('ubuntu', '20.04'): UbuntuInstaller,
        ('ubuntu', '22.04'): UbuntuInstaller,
        ...
    }

    ...
```

Get the OS identifier tuple:

```ipython
In [1]: import distro

In [2]: (distro.id(), distro.version())
Out[2]: ('ubuntu', '20.04')
```

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

- Ubuntu 22.04 LTS
- Ubuntu 20.04 LTS

# Disclaimer

I am not responsible for any harm done to your PC by anything in the repository. Use everything with caution!

# License

[MIT](./LICENSE)

# Changelog

- 1.0.0 - Initial release.
