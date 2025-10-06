#!/bin/bash

function cleanFolder {
    local target_dir="$1"
    local current_dir="$(pwd)"

    cd "$target_dir"
    [ $? -ne 0 ] && exit 1

    for item in * .*; do
        # The glob pattern '.*' matches '.', '..', and '.gitkeep'. We must skip them.
        if [[ "$item" == "." || "$item" == ".." || "$item" == ".gitkeep" ]]; then
        continue # Skip to the next item in the loop.
        fi

        # Remove the item recursively and forcefully.
        rm -rf "$item"
        [ $? -ne 0 ] && exit 1
    done

    cd "$current_dir"
    [ $? -ne 0 ] && exit 1

    exit 0
}

function getImageNameWithoutTag {
    local full_image_name="$1"
    local image_name_without_tag

    image_name_without_tag="${full_image_name%%:*}"
    [ $? -ne 0 ] && exit 1

    echo "$image_name_without_tag"

    exit 0
}

function main {
    local path_to_docker="$1"
    local type_of_wrap="$2"

    if [ -z "$type_of_wrap" ]; then
        echo "Type of wrap is required"
        exit 1
    fi

    if [ -z "$path_to_docker" ]; then
        echo "path_to_docker is required"
        exit 1
    fi

    case "$type_of_wrap" in
        "install")
            (cleanFolder "$path_to_docker/install/configs")
            [ $? -ne 0 ] && exit 1
            (cleanFolder "$path_to_docker/install/saved-versions")
            [ $? -ne 0 ] && exit 1
            ;;
        "get-latest-version")
            (cleanFolder "$path_to_docker/get-latest-version/configs")
            [ $? -ne 0 ] && exit 1
            ;;
        "download")
            (cleanFolder "$path_to_docker/download/with-configs/configs")
            [ $? -ne 0 ] && exit 1
            ;;
        *)
            echo "Unknown type of wrap"
            exit 1
    esac

    exit 0
}