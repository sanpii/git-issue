#!/bin/bash

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testListOneIssue () {
	local output

	git issue init -q
	git issue new -q --no-edit 'test 1'

	output="$(git issue list 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1' 'testListOneIssue'
	assert_numeq $status 0 'testListOneIssue'
}

testList () {
	local output

	testListOneIssue

	git issue new -q --no-edit 'test 2'

	output="$(git issue list 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1
2: test 2' 'testList'
	assert_equal $status 0 'testList'
}

testListNoIssue () {
	local output

	git issue init -q

	output="$(git issue list 2>&1)"
	local status=$?

	assert_equal "$output" 'Nothing to do :)' 'testListNoIssue'
	assert_equal $status 0 'testListNoIssue'
}

testListFilter () {
	local output

	testList
	git issue close -q 1
	git issue new -q --no-edit 'test 3'
	git issue edit -q --status=accepted 3

	output="$(git issue list --status=close 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1' 'testListFilter'
	assert_equal $status 0 'testListFilter'
}

testListFilterNot () {
	local output

	testListFilter

	output="$(git issue list --status=~close 2>&1)"
	local status=$?

	assert_equal "$output" '2: test 2
3: test 3' 'testListFilterNot'
	assert_equal $status 0 'testListFilterNot'
}

testListFilterOr () {
	local output

	testListFilter

	output="$(git issue list --status='accepted|close' 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1
3: test 3' 'testListFilterOr'
	assert_equal $status 0 'testListFilterOr'
}

. $CWD/tests/common.sh
