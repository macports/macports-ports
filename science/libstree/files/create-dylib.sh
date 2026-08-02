#!/bin/bash
#
# Copyright (c) 2005, 2006 Markus W. Weissmann <mww@opendarwin.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of OpenDarwin nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

if [ $# -ne 3 ]; then
	echo "Usage: $0 lib.a version libdir"
	exit 1
fi

tmpdir="create-dylib.${$}"

liba=${1}
version=${2}
libdir=${3}
if [ -z ${CC} ]; then
	CC=gcc
fi
if [ -z ${AR} ]; then
	AR=ar
fi

lib=$(echo $liba | sed 's|^.*/||g' | sed 's|\.a$||g')

if ! mkdir ${tmpdir}; then
	echo "Error creating tmpdir"
	exit 2
fi

if [ ! -d ${tmpdir} ]; then
	echo "error accessing tmpdir"
	exit 3
fi

cd ${tmpdir}

if ! ${AR} -x ../${1}; then
	echo "Error extracting archive"
	exit 4
fi

echo ${CC} ${CFLAGS} -fno-common -dynamiclib -o ../${lib}.${version}.dylib -current_version "${version}" -install_name "${libdir}/${lib}.${version}.dylib" *.o ${LDFLAGS}
if ! ${CC} ${CFLAGS} -fno-common -dynamiclib -o ../${lib}.${version}.dylib -current_version "${version}" -install_name "${libdir}/${lib}.${version}.dylib" *.o ${LDFLAGS}; then
	echo "Error creating dylib"
	exit 5
fi

cd ..

if ! rm -r ${tmpdir}; then
	echo "Error removing tmpdir"
	exit 6
fi

ln -s ${lib}.${version}.dylib ${lib}.dylib

