#!/bin/sh
if echo $1 | grep -q .a; then
	/usr/bin/ranlib $1
fi
exit 0
