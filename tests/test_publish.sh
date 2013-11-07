#!/bin/sh

setUp () {
	createTestRepository

	git clone -q "$REPO" "$REPO-clone"
	cd "$REPO-clone"
}

tearDown () {
	rm -rf "$REPO-clone"

	deleteTestRepository
}

testPublish () {
	local output

	git issue init -q
	git issue new -q 'test 1'

	output="$(git issue publish 2>&1)"
	local status=$?

	assertEquals 'output' "$output" 'Issues published.'
	assertEquals 'status code' $status 0

	cd "$REPO"
	output="$(git issue ls)"

	assertEquals 'output' "$output" '1: test 1'
	assertEquals 'status code' $status 0
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
