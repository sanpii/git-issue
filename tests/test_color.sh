#!/bin/bash

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testColorNone () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue show --color=none 1 2>&1)"
	local status=$?

	assert_equal "$output" "title:
status: new
assign:
tags:
milestone:
type:" 'testColorNone'
	assert_numeq $status 0 'testColorNone'
}

testColorAlways () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue show --color=always 1 2>&1)"
	local status=$?

	c_metadata=$(git config --get-color '' 'yellow bold')
	c_reset=$(git config --get-color '' 'reset')

	assert_equal "$output" "${c_metadata}title:${c_reset}
${c_metadata}status:${c_reset} new
${c_metadata}assign:${c_reset}
${c_metadata}tags:${c_reset}
${c_metadata}milestone:${c_reset}
${c_metadata}type:${c_reset}" 'testShowColor'
	assert_numeq $status 0 'testShowColor'
}
. $CWD/tests/common.sh
