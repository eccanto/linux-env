#!/bin/env sh

pkill polybar

sleep 1;

# set HDMI as primary monitor if is connected
MONITOR="$(xrandr -q | grep ' connected ' | grep HDMI | cut -d' ' -f1 | head -1)"
if [[ -z "${MONITOR}" ]]; then
    MONITOR="$(xrandr -q | grep ' connected ' | cut -d' ' -f1 | head -1)"
fi

MONITOR=${MONITOR} polybar i3wmthemer_bar &
picom --experimental-backends -b
feh --bg-fill /home/eccanto/.wallpaper.jpg
