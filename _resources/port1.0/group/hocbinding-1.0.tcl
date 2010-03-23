# $Id$
# 
# Copyright (c) 2010 The MacPorts Project
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
# This PortGroup automatically sets all the fields of the various hs-HOC
# bindings ports (e.g. hs-HOC-Foundation).
# 
# Usage:
# 
#   PortGroup        hocbinding 1.0
#   hocbinding.setup framework version source
# 
# where framework is the name of the bound framework (e.g. Foundation), version
# is the version of the binding, and if the framework additional code is in HOC
# source itself, source is "hoc"; otherwise don't use source.
# 
# Example:
# 
#   PortGroup        hocbinding 1.0
#   hocbinding.setup Foundation 0.7-r413 hoc

PortGroup haskell 1.0

options hocbinding.framework
options hocbinding.deps
default hocbinding.deps {{}}

proc hocbinding.setup {framework version {source ""}} {
    global description name prefix worksrcpath

    hocbinding.framework ${framework}

    haskell.setup   HOC-${framework} ${version}
    name            hs-HOC-${framework}
    categories      devel
    platforms       darwin

    eval description ${framework} framework bindings for HOC
    long_description ${description}

    if {${source} eq "hoc"} {
        homepage    http://code.google.com/p/hoc/

        worksrcdir  hoc/Bindings/Generated/HOC-${framework}

        post-extract {
            xinstall -d ${worksrcpath}
        }

        depends_build-append \
            port:hs-HOC

        pre-configure {
            set args ""
            foreach dep ${hocbinding.deps} {
                append args " -d ${dep}"
            }

            system "cd [file dirname ${worksrcpath}] && \
                hoc-ifgen -f ${hocbinding.framework} -b ../binding-script.txt \
                    -a ../AdditionalCode ${args}"
        }

        post-destroot {
            set pidir ${prefix}/share/HOC
            xinstall -d ${destroot}${pidir}
            xinstall -m 0644 ${worksrcpath}/${hocbinding.framework}.pi \
                ${destroot}${pidir}
        }
    }

    universal_variant no
}
