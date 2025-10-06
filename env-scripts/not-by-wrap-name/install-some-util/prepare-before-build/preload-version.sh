#!/bin/bash

function preloadVersion {
    local version="$1"
    local os="$2"
    local arch="$3"
    local prefix="$4"
    local path_to_docker="$5"

    local file_config_download_docker_context="$path_to_docker/download/with-configs/configs/versions.cfg"

    if [ -z "$version" ]; then
        exit 0
    fi

    if [ -z "$os" ]; then
        exit 0
    fi

    (changeFileConfigDownloadDockerContext "$version" "$os" "$arch" "$file_config_download_docker_context")
    [ $? -ne 0 ] && exit 1

    echo "starting container..."
    (./envs.sh start "$prefix-download-with-configs")
    [ $? -ne 0 ] && exit 1

    exit 0
}

function changeFileConfigDownloadDockerContext {
    local version="$1"
    local os="$2"
    local arch="$3"
    local file_config_download_docker_context="$4"
    local dirname
    local version_in_file
    local quoted_versions

    local arg_name="VERSIONS"

    dirname=$(dirname "$file_config_download_docker_context")
    [ $? -ne 0 ] && exit 1

    if [ ! -d "$dirname" ]; then
        mkdir -p "$dirname"
        [ $? -ne 0 ] && exit 1
    fi

    if [ ! -f "$file_config_download_docker_context" ]; then
        touch "$file_config_download_docker_context"
        [ $? -ne 0 ] && exit 1
    fi

    source "$file_config_download_docker_context"
    [ $? -ne 0 ] && exit 1

    version_in_file="$os/$arch/$version"
    if [[ -z "${VERSIONS+x}" ]]; then
        echo "$arg_name=(\"$version_in_file\")" > "$file_config_download_docker_context"
        [ $? -ne 0 ] && exit 1
    else
        quoted_versions=()
        for item in "${VERSIONS[@]}"; do
            if [[ "$item" == "$version_in_file" ]]; then
                exit 0
            fi
            quoted_versions+=("\"$item\"")
        done
        echo "$arg_name=(${quoted_versions[@]} \"$version_in_file\")" > "$file_config_download_docker_context"
        [ $? -ne 0 ] && exit 1
    fi

    exit 0
}