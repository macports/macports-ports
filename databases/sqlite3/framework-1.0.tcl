# et:ts=4
# framework-1.0.tcl
#
# $Id: framework-1.0.tcl,v 1.1 2005/04/08 19:16:58 mww Exp $
#
# Copyright (c) 2004 Markus W. Weissman <mww@opendarwin.org>,
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


proc framework.setup {fname fversion} {
	global prefix f_name f_version f_path f_framework f_prefix 
	set f_name ${fname}
	set f_version ${fversion}
	set f_path /Library/Frameworks
	set f_framework ${f_path}/${f_name}.framework
	set f_prefix ${f_framework}/Versions/${f_version}

	configure.args-append \
		--includedir=${f_prefix}/Headers \
		--libdir=${f_prefix}/Libraries \
		--datadir=${f_prefix}/Resources \
		--bindir=${prefix}/bin \
		--sbindir=${prefix}/sbin \
		--sysconfdir=${prefix}/etc \
		--mandir=${prefix}/share/man \
		--infodir=${prefix}/share/info \
		--localstatedir=${prefix}/var

	post-destroot {
		system "cd ${destroot}${f_framework}/Versions && \
			ln -s ${f_version} Current"
		system "cd ${destroot}${f_framework} && \
			ln -s Versions/Current/Headers Headers && \
			ln -s Versions/Current/Libraries Libraries"
	}
}
