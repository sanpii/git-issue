#!/bin/bash

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
	git issue new -q --no-edit 'test 1'

	output="$(git issue sync 2>&1)"
	local status=$?

	assert_equal "$output" 'Issues synced.' 'testSyncPush'
	assert_numeq $status 0 'testSyncPush'

	cd "$REPO"
	output="$(git issue ls)"

	assert_equal "$output" '1: test 1' 'testSyncPush'
	assert_numeq $status 0 'testSyncPush'
}

testSyncPull () {
	local output

	cd "$REPO"
	git issue init -q
	git issue new -q --no-edit 'test 1'

	cd "$REPO-clone"
	output="$(git issue sync 2>&1)"
	local status=$?

	assert_equal "$output" 'Issues synced.' 'testSyncPull'
	assert_numeq $status 0 'testSyncPull'

	output="$(git issue ls)"

	assert_equal "$output" '1: test 1' 'testSyncPull'
	assert_numeq $status 0 'testSyncPull'
}

testSyncNothing () {
	local output

	output="$(git issue sync 2>&1)"
	local status=$?

	assert_equal "$output" 'Nothing to sync.' 'testSyncNothing'
	assert_numeq $status 0 'testSyncNothing'
}

testSyncConflict () {
	local output

	cd "$REPO"
	git issue init -q
	git issue new -q --no-edit 'test 1' 'Issue in the first repo'

	cd "$REPO-clone"
	git issue init -q
	git issue new -q --no-edit 'test 1' 'Issue in the second repo'

	output="$(git issue sync 2>&1)"
	local status=$?

	assert_numeq $status 1 'testSyncConflict'
}

. $CWD/tests/common.sh
