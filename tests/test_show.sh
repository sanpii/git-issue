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

	output="$(git issue show --color=none 1 2>&1)"
	local status=$?

	assert_equal "$output" 'test' 'testShow'
	assert_numeq $status 0 'testShow'
}

testShowUnknowId () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue show --color=none 2 2>&1)"
	local status=$?

	assert_equal "$output" "Issue #2 doesn't exist" 'testShowUnknowId'
	assert_numeq $status 1 'testShowUnknowId'
}

testShowColor () {
	local output

	git issue init -q
	git issue new -q --no-edit --title='Issue 1'

	output="$(git issue show --color=always 1 2>&1)"
	local status=$?

	c_metadata=$(git config --get-color '' 'yellow bold')
	c_reset=$(git config --get-color '' 'reset')

	assert_equal "$output" "${c_metadata}title:${c_reset} Issue 1
${c_metadata}status:${c_reset} new
${c_metadata}assign:${c_reset}
${c_metadata}tags:${c_reset}
${c_metadata}milestone:${c_reset}
${c_metadata}type:${c_reset}" 'testShowColor'
	assert_numeq $status 0 'testShowColor'
}

. $CWD/tests/common.sh
