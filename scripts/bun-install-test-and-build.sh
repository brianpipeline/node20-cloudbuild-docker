#!/bin/bash

source send-message.sh

bunInstallTestAndBuild() {
    local replyTopic=$1
    if ! bun install; then
        echo "Bun build failed."
        sendMessage "$replyTopic" "Pipeline failed."
        exit 1
    fi
    echo "Bun install succeeded."

    if ! bun run test; then
        echo "Bun test failed."
        sendMessage "$replyTopic" "Pipeline failed."
        exit 1
    fi
    echo "Bun test succeeded."

    if ! bun run build; then
        echo "Bun build failed."
        sendMessage "$replyTopic" "Pipeline failed."
        exit 1
    fi
    echo "Bun build succeeded."
}
