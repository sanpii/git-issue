#!/bin/sh

setUp()
{
    createTestRepository
}

tearDown()
{
    deleteTestRepository
}

testRm()
{
    local output

    git issue init -q
    git issue new -q

    output="$(git issue rm 1 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'Issue #1 deleted.'
    assertEquals 'output' "$(git issue show 1 2>&1)" "Issue #1 doesn't exist"
    assertEquals 'status code' $status 0
}

testRmUnknowId()
{
    local output

    git issue init -q

    output="$(git issue rm 1 2>&1)"
    local status=$?

    assertEquals 'output' "$output" "Issue #1 doesn't exist"
    assertEquals 'status code' $status 1
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
