#!/bin/bash

setUp () {
	createTestRepository
	export GIT_EDITOR='echo [test] >'
}

tearDown () {
	deleteTestRepository
}

testNew () {
	local output

	git issue init -q
	output="$(git issue new --no-edit 2>&1)"
	local status=$?

	assert_equal "$output" 'Issue #1 created.' 'testNew'
	assert_numeq $status 0 'testNew'
}

testNewEdit () {
	local output

	git issue init -q
	output="$(git issue new 2>&1)"
	local status=$?

	assert_equal "$output" 'Issue #1 created.' 'testNewEdit'
	assert_numeq $status 0 'testNewEdit'

	output="$(git issue show 1 2>&1)"
	local status=$?

	assert_equal "$output" '[test]' 'testNewEdit'
	assert_numeq $status 0 'testNewEdit'
}

testNewWithTitle () {
	local output

	git issue init -q
	output="$(git issue new --no-edit --title='Issue title' 2>&1)"
	local status=$?

	assert_equal "$output" 'Issue #1 created.' 'testNewWithTitle'
	assert_numeq $status 0 'testNewWithTitle'

	output="$(git issue show 1 2>&1)"
	local status=$?

	assert_equal "$output" 'title: Issue title
status: new
assign:
tags:
milestone:
type:' 'testNewWithTitle'
	assert_numeq $status 0 'testNewWithTitle'
}

testNewWithDescription () {
	local output

	git issue init -q
	output="$(git issue new --title='Issue title' 'Issue description' 2>&1)"
	local status=$?

	assert_equal "$output" 'Issue #1 created.' 'testNewWithDescription'
	assert_numeq $status 0 'testNewWithDescription'

	output="$(git issue show 1 2>&1)"
	local status=$?

	assert_equal "$output" 'title: Issue title
status: new
assign:
tags:
milestone:
type:

Issue description' 'testNewWithDescription'
	assert_numeq $status 0
}

testNewWithType () {
	local output

	git issue init -q
	output="$(git issue new --no-edit --type='bug' 2>&1)"
	local status=$?

	assert_equal "$output" 'Issue #1 created.' 'testNewWithType'
	assert_numeq $status 0 'testNewWithType'

	output="$(git issue show 1 2>&1)"
	local status=$?

	assert_equal "$output" 'title:
status: new
assign:
tags:
milestone:
type: bug' 'testNewWithType'
	assert_numeq $status 0
}

testNewUnitialized () {
	local output

	output="$(git issue new --no-edit 2>&1)"
	local status=$?

	assert_equal "$output" 'Git issue not initialized.' 'testNewUnitialized'
	assert_numeq $status 1 'testNewUnitialized'
}

testNewUnstash () {
	local output

	git issue init -q
	touch test
	git add test

	output="$(git issue new --no-edit 2>&1)"
	local status=$?

	assert_equal "$output" "Cannot switch to issues branch: Your index contains uncommitted changes." 'testNewUnstash'
	assert_numeq $status 1 'NewUnstash'
}

. $CWD/tests/common.sh
