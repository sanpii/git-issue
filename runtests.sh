#!/bin/sh

CWD="$(cd "$(dirname "$0")" && pwd)"
PATH="$CWD/src":$PATH

PART=${1-*}

for t in $CWD/tests/test_$PART.sh
do
	$t
done
