#!/bin/bash

source send-message.sh
source utils.sh

createBunArtifactRepository() {
    local replyTopic=$1
    local gitRef=$2
    local nodeProjectName

    if [[ $gitRef != "refs/heads/main" && $gitRef != *"release"* ]]; then
        echo "Not on main or release branch, skipping Artifact Registry creation."
        exit 0
    fi
    nodeProjectName=$(getNodeProjectName)

    if ! gcloud artifacts repositories describe "$nodeProjectName" --location=us-central1; then
        echo "Creating Artifact Registry $nodeProjectName."
        if ! gcloud artifacts repositories create "$nodeProjectName" --repository-format=docker --location=us-central1; then
            echo "Failed to create Artifact Registry $nodeProjectName."
            sendMessage "$replyTopic" "Pipeline failed."
            exit 1
        fi
    else
        echo "Artifact Registry $nodeProjectName already exists."
    fi

    echo "Artifact Registry created."
}
