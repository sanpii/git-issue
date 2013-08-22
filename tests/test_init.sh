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

testInit()
{
    local output

    output="$(git issue init 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'Git issue initialized.'
    assertEquals 'status code' $status 0
}

testInitTwice()
{
    local output

    testInit

    output="$(git issue init 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'Git issue already initialized.'
    assertEquals 'status code' $status 1
}

. $CWD/../shunit2/shunit2
