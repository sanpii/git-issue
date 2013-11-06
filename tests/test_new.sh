#!/bin/sh

setUp()
{
    createTestRepository
}

tearDown()
{
    deleteTestRepository
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

testNewWithTitle()
{
    local output

    git issue init -q
    output="$(git issue new 'Issue title' 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'Issue #1 created.'
    assertEquals 'status code' $status 0

    output="$(git issue show 1 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'title: Issue title
status: new
assign:
tags:
milestone:
type:'
    assertEquals 'status code' $status 0
}

testNewWithDescription()
{
    local output

    git issue init -q
    output="$(git issue new 'Issue title' 'Issue description' 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'Issue #1 created.'
    assertEquals 'status code' $status 0

    output="$(git issue show 1 2>&1)"
    local status=$?

    assertEquals 'output' "$output" 'title: Issue title
status: new
assign:
tags:
milestone:
type:

Issue description'
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

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
