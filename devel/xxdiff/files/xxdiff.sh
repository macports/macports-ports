#!/bin/sh

export KDE_SESSION_VERSION=5

exec @@QT_APPS_DIR@@/xxdiff.app/Contents/MacOS/xxdiff "$@"
