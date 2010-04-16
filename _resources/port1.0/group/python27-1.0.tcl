# et:ts=4
# python27-1.0.tcl
#
# $Id$
#
# Copyright (c) 2010 The MacPorts Project,
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of Apple Computer, Inc. nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

set python.branch	2.7
set python.prefix	${frameworks_dir}/Python.framework/Versions/${python.branch}
set python.bin	${python.prefix}/bin/python${python.branch}
set python.lib	${python.prefix}/Python
set python.libdir ${python.prefix}/lib/python${python.branch}
set python.pkgd	${python.prefix}/lib/python${python.branch}/site-packages
set python.include	${python.prefix}/include/python${python.branch}

categories		python

dist_subdir		python

depends_lib		port:python27

use_configure	no

build.cmd		${python.bin} setup.py --no-user-cfg
build.target	build

destroot.cmd	${python.bin} setup.py --no-user-cfg
destroot.destdir	--prefix=${python.prefix} --root=${destroot}

pre-destroot	{
	xinstall -d -m 755 ${destroot}${prefix}/share/doc/${name}/examples
}

options         python.link_binaries
default python.link_binaries yes
options         python.link_binaries_suffix
default python.link_binaries_suffix -${python.branch}
post-destroot {
    if {${python.link_binaries}} {
        foreach bin [glob -nocomplain -tails -directory "${destroot}${python.prefix}/bin" *] {
            if {[catch {file type "${destroot}${prefix}/bin/${bin}${python.link_binaries_suffix}"}]} {
                ln -s "${python.prefix}/bin/${bin}" "${destroot}${prefix}/bin/${bin}${python.link_binaries_suffix}"
            }
        }
    }
}
