#!/bin/sh

CWD="$(cd "$(dirname "$0")" && pwd)"

for t in $CWD/tests/test_*.sh
do
    $t
done
