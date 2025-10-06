#!/bin/bash

function main {
    local path_to_docker="$1"

    if [ -z "$path_to_docker" ]; then
        exit 1
    fi

    source "$path_to_docker/install/configs/version.cfg"
    [ $? -ne 0 ] && exit 1

    if [ -z "$OS" ]; then
        echo "null"
        exit 0
    fi

    echo "$OS"

    exit 0
}
