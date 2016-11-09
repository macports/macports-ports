#!/usr/bin/env bash

# chdir to the port directory
cd `dirname $0`
PORT=`port -q info --name`
PORTDIR=`basename ${PWD}`
cd ..
CATDIR=`basename ${PWD}`
cd ..

EXTRAFILES="_resources/port1.0/group/locale_select-1.0.tcl"

# echo ${PORT} ${CATDIR} ${PORTDIR}
tar -cvj --exclude .kdev4 --exclude "*.kdev4" -f ${PORT}.tar.bz2 ${EXTRAFILES} ${CATDIR}/${PORTDIR}
