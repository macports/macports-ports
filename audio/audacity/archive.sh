#!/usr/bin/env bash

# chdir to the port directory
cd `dirname $0`
PORT=`port -q info --name`
PORTDIR=`basename ${PWD}`
cd ..
CATDIR=`basename ${PWD}`
cd ..

EXTRAFILES=""
EXCLUDES="--exclude ${CATDIR}/${PORTDIR}/files/old --exclude ${CATDIR}/${PORTDIR}/files/debian --exclude ${CATDIR}/${PORTDIR}/files/series"

# echo ${PORT} ${CATDIR} ${PORTDIR}
bsdtar -c ${EXCLUDES} -vjf ${PORT}.tar.bz2 ${EXTRAFILES} ${CATDIR}/${PORTDIR}
ll -h ${PORT}.tar.bz2
