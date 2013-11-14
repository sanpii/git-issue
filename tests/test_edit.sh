#!/bin/bash

setUp () {
	createTestRepository
	export GIT_EDITOR='echo [test] >'
}

tearDown () {
	deleteTestRepository
}

testEdit () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue edit 1 2>&1)"
	local status=$?

	assert_equal "$(git issue show --color=none 1)" '[test]' 'testEdit'
	assert_numeq $status 0 'testEdit'

	assert_equal "$(git show --pretty=format:%B -s issues)" 'Edit issue #1' 'testEdit'
}

testEditUnknowId () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue edit 2 2>&1)"
	local status=$?

	assert_equal "$output" "Issue #2 doesn't exist" 'testEditUnknowId'
	assert_numeq $status 1 'testEditUnknowId'
}

testEditOneLine () {
	git issue init -q
	git issue new -q --no-edit

	git issue edit -q --status=close 1
	local status=$?

	assert_equal "$(git issue show --color=none 1)" 'title:
status: close
assign:
tags:
milestone:
type:' 'testEditOneLine'
	assert_numeq $status 0 'testEditOneLine'
}

testEditMessage () {
	git issue init -q
	git issue new -q --no-edit

	git issue edit -q --status=close -m 'Close issue' 1
	local status=$?

	assert_equal "$(git show --pretty=format:%B -s issues)" 'Edit issue #1

Close issue' 'testEditMessage'
	assert_numeq $status 0 'testEditMessage'
}

. $CWD/tests/common.sh
