#!/bin/sh

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testLsOneIssue () {
	local output

	git issue init -q
	git issue new -q --no-edit 'test 1'

	output="$(git issue ls 2>&1)"
	local status=$?

	assertEquals 'output' "$output" '1: test 1'
	assertEquals 'status code' $status 0
}

testLs () {
	testLsOneIssue

	git issue new -q --no-edit 'test 2'

	output="$(git issue ls 2>&1)"
	local status=$?

	assertEquals 'output' "$output" '1: test 1
2: test 2'
	assertEquals 'status code' $status 0
}

testLsNoIssue () {
	local output

	git issue init -q

	output="$(git issue ls 2>&1)"
	local status=$?

	assertEquals 'output' "$output" 'Nothing to do :)'
	assertEquals 'status code' $status 0
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
