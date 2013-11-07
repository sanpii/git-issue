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

testSyncPush () {
	local output

	git issue init -q
	git issue new -q 'test 1'

	output="$(git issue sync 2>&1)"
	local status=$?

	assertEquals 'output' "$output" 'Issues synced.'
	assertEquals 'status code' $status 0

	cd "$REPO"
	output="$(git issue ls)"

	assertEquals 'output' "$output" '1: test 1'
	assertEquals 'status code' $status 0
}

testSyncPull () {
	local output

	cd "$REPO"
	git issue init -q
	git issue new -q 'test 1'

	cd "$REPO-clone"
	output="$(git issue sync 2>&1)"
	local status=$?

	assertEquals 'output' "$output" 'Issues synced.'
	assertEquals 'status code' $status 0

	output="$(git issue ls)"

	assertEquals 'output' "$output" '1: test 1'
	assertEquals 'status code' $status 0
}

testSyncNothing () {
	local output

	output="$(git issue sync 2>&1)"
	local status=$?

	assertEquals 'output' "$output" 'Nothing to sync.'
	assertEquals 'status code' $status 0
}

testSyncConflict () {
	local output

	cd "$REPO"
	git issue init -q
	git issue new -q 'test 1' 'Issue in the first repo'

	cd "$REPO-clone"
	git issue init -q
	git issue new -q 'test 1' 'Issue in the second repo'

	output="$(git issue sync 2>&1)"
	local status=$?

	assertEquals 'status code' $status 1
}

CWD="$(cd "$(dirname "$0")" && pwd)"

. $CWD/common.sh
. $CWD/../shunit2/shunit2
