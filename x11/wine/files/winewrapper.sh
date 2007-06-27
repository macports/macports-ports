#!/bin/sh

DYLD_FALLBACK_LIBRARY_PATH="@PREFIX@/lib" \
"@PREFIX@/bin/wine-real" "$@"
