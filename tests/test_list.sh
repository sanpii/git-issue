#!/bin/bash

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testListDefaultAction () {
	local output

	git issue init -q

	output="$(git issue 2>&1)"
	local status=$?

	assert_equal "$output" 'Nothing to do :)' 'testListDefaultAction'
	assert_equal $status 0 'testListDefaultAction'
}

testListOneIssue () {
	local output

	git issue init -q
	git issue new -q --no-edit --title='test 1'

	output="$(git issue list --color=none 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1' 'testListOneIssue'
	assert_numeq $status 0 'testListOneIssue'
}

testList () {
	local output

	testListOneIssue

	git issue new -q --no-edit

	output="$(git issue list --color=none 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1
2:' 'testList'
	assert_equal $status 0 'testList'
}

testListNoIssue () {
	local output

	git issue init -q

	output="$(git issue list --color=none 2>&1)"
	local status=$?

	assert_equal "$output" 'Nothing to do :)' 'testListNoIssue'
	assert_equal $status 0 'testListNoIssue'
}

testListFilter () {
	local output

	testList
	git issue close -q 1
	git issue new -q --no-edit --title='test 3'
	git issue edit -q --status=accepted 3

	output="$(git issue list --color=none --status=close 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1' 'testListFilter'
	assert_equal $status 0 'testListFilter'
}

testListFilterNot () {
	local output

	testListFilter

	output="$(git issue list --color=none --status=~close 2>&1)"
	local status=$?

	assert_equal "$output" '2:
3: test 3' 'testListFilterNot'
	assert_equal $status 0 'testListFilterNot'
}

testListFilterOr () {
	local output

	testListFilter

	output="$(git issue list --color=none --status='accepted|close' 2>&1)"
	local status=$?

	assert_equal "$output" '1: test 1
3: test 3' 'testListFilterOr'
	assert_equal $status 0 'testListFilterOr'
}

testShowColor () {
	local output

	git issue init -q
	git issue new -q --no-edit --title='Issue 1'

	output="$(git issue list --color=always 1 2>&1)"
	local status=$?

	c_id=$(git config --get-color '' 'blue bold')
	c_reset=$(git config --get-color '' 'reset')

	assert_equal "$output" "${c_id}1:${c_reset} Issue 1" 'testShowColor'
	assert_numeq $status 0 'testShowColor'
}

. $CWD/tests/common.sh
