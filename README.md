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

echo "setxkbmap -layout latam" >> ~/.profile
```

**Nota**:

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
