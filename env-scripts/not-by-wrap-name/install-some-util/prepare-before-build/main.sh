#!/bin/bash

function main {
    local version="$1"
    local os="$2"
    local prefix="$3"
    local path_to_docker="$4"
    local empty_file_name="$5"
    local current_file
    local current_dir
    local version_file
    local arch

    if [ -z "$prefix" ]; then
        echo "Path to prefix is not set"
        exit 1
    fi

    if [ -z "$path_to_docker" ]; then
        echo "Path to docker is not set"
        exit 1
    fi

    if [ -z "$empty_file_name" ]; then
        echo "Path to empty_file_name is not set"
        exit 1
    fi

    if [ -z "$version" ] || [ -z "$os" ]; then
        echo "" > "$path_to_docker/install/saved-versions/$empty_file_name"
        [ $? -ne 0 ] && exit 1

        exit 0
    fi

    current_file="${BASH_SOURCE[0]}"

    if [ -z "$current_file" ]; then
        exit 1
    fi

    current_dir="$(dirname "$current_file")"
    [ $? -ne 0 ] && exit 1

    source "$current_dir/get-arch.sh"
    [ $? -ne 0 ] && exit 1

    arch=$(getArch)
    if [ $? -ne 0 ]; then
        echo "Failed to get architecture" >&2
        exit 1
    fi

    (
        source "$current_dir/preload-version.sh"
        [ $? -ne 0 ] && exit 1
        (preloadVersion "$version" "$os" "$arch" "$prefix" "$path_to_docker")
        [ $? -ne 0 ] && exit 1

        exit 0
    )
    [ $? -ne 0 ] && exit 1

    (
        version_file="$path_to_docker/install/configs/version.cfg"
        source "$current_dir/set-version.sh"
        [ $? -ne 0 ] && exit 1
        (setVersion "$version" "$os" "$arch" "$version_file")
        [ $? -ne 0 ] && exit 1

        exit 0
    )
    [ $? -ne 0 ] && exit 1

    exit 0
}