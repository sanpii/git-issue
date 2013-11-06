#!/bin/sh

CWD="$(cd "$(dirname "$0")" && pwd)"
PATH="$CWD/src":$PATH

for t in $CWD/tests/test_*.sh
do
	$t
done
