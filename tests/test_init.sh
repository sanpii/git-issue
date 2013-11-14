#!/bin/bash

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

	assert_equal 'Git issue initialized.' "$output" 'testInit'
	assert_numeq $status 0 'testInit'
}

testInitTwice () {
	local output

	testInit

	output="$(git issue init 2>&1)"
	local status=$?

	assert_equal 'Git issue already initialized.' "$output" 'testInitTwice'
	assert_numeq $status 1 'testInitTwice'
}

testInitQuiet () {
	local output

	output="$(git issue init -q 2>&1)"
	local status=$?

	assert_equal '' "$output" 'testInitQuiet'
	assert_numeq $status 0 'testInitQuiet'
}

. $CWD/tests/common.sh
