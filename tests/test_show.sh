#!/bin/bash

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testShow () {
	local output

	git issue init -q
	git issue new -q --no-edit

	git checkout -q issues
	echo 'test' > 1
	git commit 1 -qm 'Edit issue #1'

	output="$(git issue show 1 2>&1)"
	local status=$?

	assert_equal "$output" 'test' 'testShow'
	assert_numeq $status 0 'testShow'
}

testShowUnknowId () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue show 2 2>&1)"
	local status=$?

	assert_equal "$output" "Issue #2 doesn't exist" 'testShowUnknowId'
	assert_numeq $status 1 'testShowUnknowId'
}

. $CWD/tests/common.sh
