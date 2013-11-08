#!/bin/sh

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
	git issue new -q

	output="$(git issue edit 1 2>&1)"
	local status=$?

	assertEquals 'output' "$(git issue show 1)" '[test]'
	assertEquals 'status code' $status 0
}

testEditUnknowId () {
	local output

	git issue init -q
	git issue new -q

	output="$(git issue edit 2 2>&1)"
	local status=$?

	assertEquals 'output' "$output" "Issue #2 doesn't exist"
	assertEquals 'status code' $status 1
}

testEditOneLine () {
	local output

	git issue init -q
	git issue new -q

	output="$(git issue edit --status=close 1 2>&1)"
	local status=$?

	assertEquals 'output' "$(git issue show 1)" 'title: 
status: close
assign:
tags:
milestone:
type:'
	assertEquals 'status code' $status 0
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
