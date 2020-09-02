#!/bin/sh

set -euo pipefail

requireprog() {
    if ! command -v "$1" > /dev/null; then
        printf "Cannot find %s (sudo port install %s)\n" "$1" "$2" 1>&2
        exit 1
    fi
}

requireprog pixz pixz
requireprog svn subversion

if [ -d trunk ]; then
    printf "Updating working copy\n"
    svn revert -R trunk
    svn up trunk
else
    printf "Checking out working copy\n"
    svn co svn://svn.icculus.org/alienarena/trunk
fi

version=$(sed -En 's%^AC_INIT\(\[alienarena\],\[([^]]+)].*$%\1%p' trunk/configure.ac)

svndate=$(svn info trunk --show-item last-changed-date | cut -dT -f1 | tr -d -)
svnrevision=$(svn info trunk --show-item last-changed-revision)
distname="alienarena-$version-$svndate-r$svnrevision"
distfile="$distname.tar.xz"
if [ -f "$distfile" ]; then
    printf "%s already exists\n" "$distfile"
else
    printf "Creating %s\n" "$distfile"
    mv trunk "$distname"
    tar --exclude ".svn" \
        --exclude "*.dll" \
        --exclude "*.exe" \
        --exclude "*.ico" \
        --exclude "Tools" \
        --exclude "alienarena_w32.*" \
        --exclude "build" \
        --exclude "data1" \
        --exclude "lib_zipfiles" \
        --exclude "source/win32" \
        --exclude "vs2010" \
        --use-compress-program pixz \
        -cf "$distfile" "$distname"
    mv "$distname" trunk
fi

svndate=$(svn info trunk/data1 --show-item last-changed-date | cut -dT -f1 | tr -d -)
svnrevision=$(svn info trunk/data1 --show-item last-changed-revision)
distname="alienarena-data-$version-$svndate-r$svnrevision"
distfile="$distname.tar.xz"
if [ -f "$distfile" ]; then
    printf "%s already exists\n" "$distfile"
else
    printf "Creating %s\n" "$distfile"
    mkdir "$distname"
    mv trunk/data1 "$distname"
    tar --use-compress-program pixz \
        -cf "$distfile" "$distname"
    mv "$distname/data1" trunk
    rmdir "$distname"
fi
