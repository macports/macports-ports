#!/bin/sh

DYLD_FALLBACK_LIBRARY_PATH="@PREFIX@/lib" \
"@PREFIX@/libexec/wine/wine" "$@"
