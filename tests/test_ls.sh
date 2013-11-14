#!/bin/bash

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

	assert_equal "$output" '1: test 1' 'testLsOneIssue'
	assert_numeq $status 0 'testLsOneIssue'
}

testLs () {
	local output

	testLsOneIssue

	git issue new -q --no-edit 'test 2'

	output="$(git issue ls 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1
2: test 2' 'testLs'
	assert_equal $status 0 'testLs'
}

testLsNoIssue () {
	local output

	git issue init -q

	output="$(git issue ls 2>&1)"
	local status=$?

	assert_equal "$output" 'Nothing to do :)' 'testLsNoIssue'
	assert_equal $status 0 'testLsNoIssue'
}

testLsFilter () {
	local output

	testLs
	git issue close -q 1
	git issue new -q --no-edit 'test 3'
	git issue edit -q --status=accepted 3

	output="$(git issue ls --status=close 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1' 'testLsFilter'
	assert_equal $status 0 'testLsFilter'
}

testLsFilterNot () {
	local output

	testLsFilter

	output="$(git issue ls --status=~close 2>&1)"
	local status=$?

	assert_equal "$output" '2: test 2
3: test 3' 'testLsFilterNot'
	assert_equal $status 0 'testLsFilterNot'
}

testLsFilterOr () {
	local output

	testLsFilter

	output="$(git issue ls --status='accepted|close' 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1
3: test 3' 'testLsFilterOr'
	assert_equal $status 0 'testLsFilterOr'
}

. $CWD/tests/common.sh
