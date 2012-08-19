# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2009 The MacPorts Project
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
# 3. Neither the name of The MacPorts Project nor the names of its
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
#
# This PortGroup automatically sets up the standard environment for building
# a module for the Pure language.
#
# Usage:
#
#   PortGroup               pure 1.0
#   pure.setup              module version
#
# where module is the name of the module (e.g. gsl) and version is its
# version.


proc pure.setup {module version} {
    global name homepage

    name                        pure-${module}
    version                     ${version}
    homepage                    http://code.google.com/p/pure-lang/wiki/Addons#${name}
    master_sites                googlecode:pure-lang

    depends_lib                 path:lib/libpure.dylib:pure

    use_configure               no

    use_parallel_build          yes
    pre-build {
        build.args-append       CC=${configure.cc} \
                                CFLAGS="${configure.cflags} ${configure.cc_archflags}" \
                                CPPFLAGS="${configure.cppflags}" \
                                CXX=${configure.cxx} \
                                CXXFLAGS="${configure.cxxflags} ${configure.cxx_archflags}" \
                                LDFLAGS="${configure.ldflags} ${configure.ld_archflags}"
    }

    post-destroot {
        xinstall -d ${destroot}${prefix}/share/doc/${name}
        foreach f {COPYING README} {
            if {[file exists ${worksrcpath}/${f}]} {
                xinstall -m 644 ${worksrcpath}/${f} ${destroot}${prefix}/share/doc/${name}
            }
        }
        if {[file exists ${worksrcpath}/examples]} {
            xinstall -d ${destroot}${prefix}/share/examples
            copy ${worksrcpath}/examples ${destroot}${prefix}/share/examples/${name}
        }
    }

    livecheck.type              regex
    default livecheck.url       {http://code.google.com/p/pure-lang/downloads/list?q=${name}&sort=filename}
    default livecheck.regex     {${name}-(\[0-9.\]+)\\.tar}
}
