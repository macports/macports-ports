# et:ts=4
# python-1.0.tcl
#
# $Id$
#
# Copyright (c) 2004 Markus W. Weissman <mww@macports.org>,
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
ui_warn "This portgroup is deprecated and will be removed in a future version!"

set python.bin ${prefix}/bin/python2.3

categories       python

dist_subdir      python

depends_lib      path:${python.bin}:python23

use_configure    no

build.cmd        ${python.bin} setup.py
build.target     build

destroot.cmd     ${python.bin} setup.py
destroot.destdir --root=${destroot} --prefix=${prefix}

pre-destroot {
	xinstall -d -m 755 ${destroot}${prefix}/share/doc/${name}/examples
}

post-install	{
#	if [ file exists /Library/Python ] {
#		if { [ file type /Library/Python/2.3 == "link" ] } {
#			if { [ file readlink /Library/Python/2.3 ] ne "${prefix}/lib/python2.3/site-packages/" } {
#				ui_msg "############################################################"
#					ui_msg "# Please create a symlink at '/Library/Python/2.3' pointing"
#					ui_msg "# to ${prefix}/lib/python2.3/site-packages"
#					ui_msg "# for MacOS-X python to work with this package."
#					ui_msg "#"
#					ui_msg "# /Library/Python/2.3 -> ${prefix}/lib/python2.3/site-packages/"
#					ui_msg "#"
#			}
#		}
#	}
}
