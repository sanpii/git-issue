#!/bin/sh

setUp () {
	createTestRepository
}

tearDown () {
	deleteTestRepository
}

testInit () {
	local output

	output="$(git issue init 2>&1)"
	local status=$?

	assertEquals 'output' "$output" 'Git issue initialized.'
	assertEquals 'status code' $status 0
}

testInitTwice () {
	local output

	testInit

	output="$(git issue init 2>&1)"
	local status=$?

	assertEquals 'output' "$output" 'Git issue already initialized.'
	assertEquals 'status code' $status 1
}

testInitQuiet () {
	local output

	output="$(git issue init -q 2>&1)"
	local status=$?

	assertEquals 'output' "$output" ''
	assertEquals 'status code' $status 0
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
