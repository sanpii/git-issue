#!/bin/bash

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testDelete () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue delete 1 2>&1)"
	local status=$?

	assert_equal "$output" 'Issue #1 deleted.' 'testDelete'
	assert_equal "$(git issue show 1 2>&1)" "Issue #1 doesn't exist" 'testDelete'
	assert_numeq $status 0 'testDelete'

	assert_equal "$(git show --pretty=format:%B -s issues)" 'Delete issue #1' 'testDelete'
}

testDeleteUnknowId () {
	local output

	git issue init -q

	output="$(git issue delete 1 2>&1)"
	local status=$?

	assert_equal "$output" "Issue #1 doesn't exist" 'testDeleteUnknowId'
	assert_numeq $status 1 'testDeleteUnknowId'
}

testDeleteMessage() {
	git issue init -q
	git issue new -q --no-edit

	git issue delete -q -m 'Too old' 1
	local status=$?

	assert_equal "$(git show --pretty=format:%B -s issues)" 'Delete issue #1

Too old' 'testDeleteMessage'
	assert_numeq $status 0 'testDeleteMessage'
}

. $CWD/tests/common.sh
