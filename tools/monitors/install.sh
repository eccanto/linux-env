#!/usr/bin/env bash

set -eu

XRESOURCES_PATH=~/.Xresources
DPI=96

if [[  ! -f "${XRESOURCES_PATH}" ]]; then
    cat <<EOF | sed 's/^[ \t]*//' > "${XRESOURCES_PATH}"
    Xft.dpi: 96
EOF
else
    if grep -q "Xft.dpi" "${XRESOURCES_PATH}"; then
        sed -i 's/Xft.dpi.*/Xft.dpi: 96/' "${XRESOURCES_PATH}"
    else
        echo "Xft.dpi: 96" >> "${XRESOURCES_PATH}"
    fi
fi

xrdb "${XRESOURCES_PATH}"
