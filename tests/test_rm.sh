#!/bin/bash

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

	assert_equal "$output" 'Issue #1 deleted.' 'testRm'
	assert_equal "$(git issue show 1 2>&1)" "Issue #1 doesn't exist" 'testRm'
	assert_numeq $status 0 'testRm'

	assert_equal "$(git show --pretty=format:%B -s issues)" 'Delete issue #1' 'testRm'
}

testRmUnknowId () {
	local output

	git issue init -q

	output="$(git issue rm 1 2>&1)"
	local status=$?

	assert_equal "$output" "Issue #1 doesn't exist" 'testRmUnknowId'
	assert_numeq $status 1 'testRmUnknowId'
}

testRmMessage() {
	git issue init -q
	git issue new -q --no-edit

	git issue rm -q -m 'Too old' 1
	local status=$?

	assert_equal "$(git show --pretty=format:%B -s issues)" 'Delete issue #1

Too old' 'testRmMessage'
	assert_numeq $status 0 'testRmMessage'
}

. $CWD/tests/common.sh
