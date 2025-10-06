#!/bin/bash

function getLatestVersion {
    local path_to_docker="$1"
    local prefix_of_wrap_name="$2"
    local last_action

    local latest_version_file="$path_to_docker/get-latest-version/configs/latest-version.cfg"

    if [ ! -f "$latest_version_file" ]; then
        last_action=$(./envs.sh start "$prefix_of_wrap_name-get-latest-version")
        if [ $? -ne 0 ]; then
            echo "$last_action" >&2
            echo "Failed to start $prefix_of_wrap_name-get-latest-version" >&2
            exit 1
        fi
    fi

    source "$latest_version_file"
    [ $? -ne 0 ] && exit 1

    if [ -z "$LATEST_VERSION" ]; then
        echo "Latest version is not set"
        exit 1
    fi

    echo "$LATEST_VERSION"

    exit 0
}