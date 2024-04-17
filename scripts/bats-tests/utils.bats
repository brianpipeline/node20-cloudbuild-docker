#!/usr/bin/env bats

load $(pwd)/utils.sh
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

@test "getNodeProjectName should successfully return a project name." {
    # Stub gcloud builds submit command to return success
    stub jq "echo name"
    # Run your function
    run getNodeProjectName
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [ "$output" = "name" ]
}

@test "getNodeProjectName should exit 1 when it can't find a project name." {
    # Stub gcloud builds submit command to return success
    stub jq "exit 0"
    # Run your function
    run getNodeProjectName
    # Check if it succeeds
    [ "$status" -eq 1 ]
    [ "$output" = "Failed to find project name from package.json." ]
}

@test "getNodeVersionName should successfully return a project version." {
    # Stub gcloud builds submit command to return success
    stub jq "echo version"
    # Run your function
    run getNodeVersionName
    # Check if it succeeds
    [ "$status" -eq 0 ]
    [ "$output" = "version" ]
}

@test "getNodeVersionName should exit 1 when it can't find a project version." {
    # Stub gcloud builds submit command to return success
    stub jq "exit 0"
    # Run your function
    run getNodeVersionName
    # Check if it succeeds
    [ "$status" -eq 1 ]
    [ "$output" = "Failed to find project version from package.json." ]
}
