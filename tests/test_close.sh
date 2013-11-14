#!/bin/sh

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

	assertEquals 'output' "$(git issue show 1)" 'title: 
status: close
assign:
tags:
milestone:
type:'
	assertEquals 'status code' $status 0

	assertEquals 'output' "$(git show --pretty=format:%B -s issues)" 'Edit issue #1

Close issue.'
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
