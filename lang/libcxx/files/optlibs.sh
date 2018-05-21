#!/bin/sh

if [ "${DYLD_INSERT_LIBRARIES}" != "" ] ;then
	DYLD_INSERT_LIBRARIES="${DYLD_INSERT_LIBRARIES}:@PREFIX@/lib/libc++.1.dylib"
else
	DYLD_INSERT_LIBRARIES="@PREFIX@/lib/libc++.1.dylib"
fi
export DYLD_INSERT_LIBRARIES

exec "$@"
