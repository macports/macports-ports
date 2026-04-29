#!/bin/sh

prefix="${1}"
dylib="${2}"

"${prefix}/bin/sqlite3" >out <<EOF
.load ${dylib}
SELECT "asdf" REGEXP "(?i)^A";
EOF
grep 1 out
