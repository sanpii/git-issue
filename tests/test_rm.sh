#!/bin/sh

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testRm () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue rm 1 2>&1)"
	local status=$?

	assertEquals 'output' "$output" 'Issue #1 deleted.'
	assertEquals 'output' "$(git issue show 1 2>&1)" "Issue #1 doesn't exist"
	assertEquals 'status code' $status 0
}

testRmUnknowId () {
	local output

	git issue init -q

	output="$(git issue rm 1 2>&1)"
	local status=$?

	assertEquals 'output' "$output" "Issue #1 doesn't exist"
	assertEquals 'status code' $status 1
}

testRmMessage() {
	git issue init -q
	git issue new -q --no-edit

	git issue rm -q -m 'Too old' 1
	local status=$?

	assertEquals 'output' "$(git show --pretty=format:%B -s issues)" 'Delete issue #1

Too old'
	assertEquals 'status code' $status 0
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
