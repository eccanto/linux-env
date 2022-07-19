#!/bin/env bash

BLANK='#000000ff'
CLEAR='#000000ee'
DEFAULT='#1E272Bff'
TEXT='#FF8000ff'
WRONG='#E90A0Aff'
VERIFYING='#1E272Bff'

i3lock \
    --insidever-color=$CLEAR     \
    --ringver-color=$VERIFYING   \
    \
    --insidewrong-color=$CLEAR   \
    --ringwrong-color=$WRONG     \
    \
    --inside-color=$BLANK        \
    --ring-color=$DEFAULT        \
    --line-color=$BLANK          \
    --separator-color=$DEFAULT   \
    \
    --verif-color=$TEXT          \
    --wrong-color=$TEXT          \
    --time-color=$TEXT           \
    --date-color=$TEXT           \
    --layout-color=$TEXT         \
    --keyhl-color=$WRONG         \
    --bshl-color=$WRONG          \
    \
    --screen 1                   \
    --blur 4                     \
    --clock                      \
    --indicator                  \
    --time-str="%H:%M:%S"        \
    --date-str="%A, %Y-%m-%d"

