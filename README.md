**`WIP`**

# Overview
configuration of my Linux environment

# Get started

## Install dependencies

```bash
pip3 install -r requirements.txt
```

## Setup environment

```bash
python3 main.py -s themes/colored_simple.ym
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
    sudo chmod a+rw /sys/class/backlight/$(ls -1 /sys/class/backlight/)/brightness
    ```
