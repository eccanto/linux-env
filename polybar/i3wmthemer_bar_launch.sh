#!/bin/env sh

pkill polybar

sleep 1;

polybar i3wmthemer_bar &
picom --experimental-backends -b
feh --bg-fill /home/eccanto/.wallpaper.jpg
