#!/usr/bin/env bash

set -eu

function confirm() {
    local message=$1
    local command=$2

    read -r -p "${message} [y/N] " response
    response=${response,,}
    if [[ "$response" =~ ^(yes|y)$ ]]; then
        $command
    fi
}

function get_os() {
    version=$(grep -E '^(VERSION|NAME)=' /etc/os-release | sed 's/^\(NAME\|VERSION\)=//g' | tr -d '"')
    echo ${version}
}