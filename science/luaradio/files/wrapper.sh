#!/bin/sh

DYLD_FALLBACK_LIBRARY_PATH="@PREFIX@/lib:/usr/lib" "@PREFIX@/bin/@LUAJIT@" "@PREFIX@/libexec/luaradio/luaradio" "$@"
