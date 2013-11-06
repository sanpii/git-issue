#!/bin/sh

createTestRepository () {
	OLD_PWD=$(pwd)
	REPO="$(mktemp -d)"

	git init -q "$REPO"
	cd "$REPO"
	git commit -qm 'Initial commit' --allow-empty
}

deleteTestRepository () {
	cd "$OLD_PWD"
	rm -rf "$REPO"
}
