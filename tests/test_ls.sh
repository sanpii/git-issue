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
	local output

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

testLsFilter () {
	local output

	testLs
	git issue close -q 1
	git issue new -q --no-edit 'test 3'
	git issue edit -q --status=accepted 3

	output="$(git issue ls --status=close 2>&1)"
	local status=$?

	assertEquals 'output' "$output" '1: test 1'
	assertEquals 'status code' $status 0
}

testLsFilterNot () {
	local output

	testLsFilter

	output="$(git issue ls --status=~close 2>&1)"
	local status=$?

	assertEquals 'output' "$output" '2: test 2
3: test 3'
	assertEquals 'status code' $status 0
}

testLsFilterOr () {
	local output

	testLsFilter

	output="$(git issue ls --status='accepted|close' 2>&1)"
	local status=$?

	assertEquals 'output' "$output" '1: test 1
3: test 3'
	assertEquals 'status code' $status 0
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
