#!/bin/sh

setUp()
{
    createTestRepository
}

tearDown()
{
    deleteTestRepository
}

testLs()
{
    local output

    git issue init -q
    git issue new -q 'test 1'
    git issue new -q 'test 2'

    output="$(git issue ls 1 2>&1)"
    local status=$?

    assertEquals 'output' "$output" '1: test 1
2: test 2'
    assertEquals 'status code' $status 0
}

testLsNoIssue()
{
    local output

    git issue init -q

    output="$(git issue ls 1 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'Nothing to do :)'
    assertEquals 'status code' $status 0
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
