#!/bin/bash

export CWD="$(cd "$(dirname "$0")" && pwd)"
export PATH="$CWD/src":$PATH
export LANG=C

status=0
part=${1-*}

for t in $CWD/tests/test_$part.sh
do
	$CWD/shunt/shunt.sh $t
	status=$(( status + $? ))
done

exit $status
