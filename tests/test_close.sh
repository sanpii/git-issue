#!/bin/bash

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testClose () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue close 1 2>&1)"
	local status=$?

	assert_equal "$(git issue show 1)" 'title:
status: close
assign:
tags:
milestone:
type:' 'testClose'
	assert_numeq $status 0 'testClose'

	assert_equal "$(git show --pretty=format:%B -s issues)" 'Edit issue #1

Close issue.' 'testClose'
}

. $CWD/tests/common.sh
