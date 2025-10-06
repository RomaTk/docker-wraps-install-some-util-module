#!/bin/bash

function getArch {
    local arch

    arch=$(uname -m)
    [ $? -ne 0 ] && exit 1

    arch=$(formatArch "$arch")
    if [ $? -ne 0 ]; then
        echo "Failed to format architecture" >&2
        exit 1
    fi

    echo "$arch"

    exit 0
}