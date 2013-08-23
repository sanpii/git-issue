#!/bin/sh

setUp()
{
    createTestRepository
}

tearDown()
{
    deleteTestRepository
}

testShow()
{
    local output

    git issue init -q
    git issue new -q

    git checkout -q issues
    echo 'test' > 1
    git commit 1 -qm 'Edit issue #1'

    output="$(git issue show 1 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'test'
    assertEquals 'status code' $status 0
}

testShowUnknowId()
{
    local output

    git issue init -q
    git issue new -q

    output="$(git issue show 2 2>&1)"
    local status=$?

    assertEquals 'output' "$output" "Issue #2 doesn't exist"
    assertEquals 'status code' $status 1
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
