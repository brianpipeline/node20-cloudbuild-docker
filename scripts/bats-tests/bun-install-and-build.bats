#!/usr/bin/env bats

load $(pwd)/send-message.sh
load $(pwd)/bun-install-and-build.sh
BATS_TEST_DIRNAME=$(pwd)
export PATH="$BATS_TEST_DIRNAME/stub:$PATH"

stub() {
    if [ ! -d $BATS_TEST_DIRNAME/stub ]; then
        mkdir $BATS_TEST_DIRNAME/stub
    fi
    echo $2 >$BATS_TEST_DIRNAME/stub/$1
    chmod +x $BATS_TEST_DIRNAME/stub/$1
}

rm_stubs() {
    rm -rf $BATS_TEST_DIRNAME/stub
}

teardown() {
    rm_stubs
}

@test "bun install and build should successfully build the project" {
    # Stub gcloud builds submit command to return success
    stub bun "exit 0"
    # Run your function
    run bunInstallAndBuild "topic"
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [[ "$output" == *"Bun install succeeded."* ]]
    [[ "$output" == *"Bun build succeeded."* ]]
}