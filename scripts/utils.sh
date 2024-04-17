#!/bin/bash

getNodeProjectName() {
    local name
    name=$(jq -r '.name' package.json)
    if [[ -z "$name" ]]; then
        echo "Failed to find project name from package.json."
        exit 1
    fi
    echo "$name"
}

getNodeVersionName() {
    local version
    version=$(grep -Po "version\s*=\s*['\"]\K[^'\"]+" build.gradle)
    if [[ -z "$version" ]]; then
        echo "Failed to find project version from package.json."
        exit 1
    fi
    echo "$version"
}
