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
	git issue new -q --no-edit

	output="$(git issue edit 1 2>&1)"
	local status=$?

	assertEquals 'output' "$(git issue show 1)" '[test]'
	assertEquals 'status code' $status 0

	assertEquals 'output' "$(git show --pretty=format:%B -s issues)" 'Edit issue #1'
}

testEditUnknowId () {
	local output

	git issue init -q
	git issue new -q --no-edit

	output="$(git issue edit 2 2>&1)"
	local status=$?

	assertEquals 'output' "$output" "Issue #2 doesn't exist"
	assertEquals 'status code' $status 1
}

testEditOneLine () {
	git issue init -q
	git issue new -q --no-edit

	git issue edit -q --status=close 1
	local status=$?

	assertEquals 'output' "$(git issue show 1)" 'title: 
status: close
assign:
tags:
milestone:
type:'
	assertEquals 'status code' $status 0
}

testEditMessage () {
	git issue init -q
	git issue new -q --no-edit

	git issue edit -q --status=close -m 'Close issue' 1
	local status=$?

	assertEquals 'output' "$(git show --pretty=format:%B -s issues)" 'Edit issue #1

Close issue'
	assertEquals 'status code' $status 0
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
