#!/bin/sh

CWD="$( cd "$( dirname "$0" )" && pwd )"

setUp()
{
    OLD_PWD=$(pwd)
    REPO="$SHUNIT_TMPDIR/repo"

    git init -q "$REPO"
    cd "$REPO"
    git commit -qm 'Initial commit' --allow-empty
}

tearDown()
{
    cd "$OLD_PWD"
    rm -rf "$REPO"
}

testNew()
{
    local output

    git issue init -q
    output="$(git issue new 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'Issue #1 created.'
    assertEquals 'status code' $status 0
}

testNewUnitialized()
{
    local output

    output="$(git issue new 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'Git issue not initialized.'
    assertEquals 'status code' $status 1
}

testNewUnstash()
{
    local output

    git issue init -q
    touch test
    output="$(git issue new 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'You have unstaged changes.
Please commit or stash them.'
    assertEquals 'status code' $status 1
}

. $CWD/../shunit2/shunit2
