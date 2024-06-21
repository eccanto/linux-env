#!/usr/bin/env bash

if type "xrandr"; then
    for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        if [[ "${monitor}" == HDMI* ]]; then
            MONITOR=$monitor polybar --reload i3wmthemer_primary_bar &
        else
            MONITOR=$monitor polybar --reload i3wmthemer_secondary_bar &
        fi
    done
else
    polybar --reload i3wmthemer_primary_bar &
fi

picom --daemon --config /home/eccanto/.config/picom/picom.conf
