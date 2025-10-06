#!/bin/bash

function setVersion {
    local version="$1"
    local os="$2"
    local arch="$3"
    local version_file="$4"
    local dirname

    dirname=$(dirname "$version_file")
    [ $? -ne 0 ] && exit 1

    if [ ! -d "$dirname" ]; then
        mkdir -p "$dirname"
        [ $? -ne 0 ] && exit 1
    fi

    echo "VERSION=\"$version\"
OS=\"$os\"
ARCH=\"$arch\"" > "$version_file"
    [ $? -ne 0 ] && exit 1

    exit 0
}
