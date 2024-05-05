#!/usr/bin/env bash

xrandr --output DP-1 --mode 1920x1080 --pos 0x0 --rotate left --output HDMI-1 --off --output HDMI-2 --primary --mode 2560x1080 --pos 1080x330 --rotate normal
feh --bg-fill ~/.wallpaper.jpg
openrgb --profile orange
