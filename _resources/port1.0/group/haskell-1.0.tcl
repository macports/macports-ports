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
# Usage:
# PortGroup       haskell 1.0
# haskell.setup   haskell_package version [haskell_compiler]
# where haskell_package is the name of the package (eg, digest), version
# is the version for it, and haskell_compiler is which compiler to use
# (ghc is the default if not specified, and currently the only option).
# This automatically defines name, version, categories, homepage,
# master_sites, distname, and depends_build as appropriate, and sets up
# the configure, build, destroot, and post-activate stages.  It can do
# pre-deactivate if that ever becomes an option in MacPorts.
#

# List of supported compilers
set haskell.compiler_list {ghc}

# Configuration for each compiler
array set haskell.compiler_configuration {
    ghc {port       ghc
         compiler   ${prefix}/bin/ghc}
}

proc haskell.setup {package version {compiler ghc}} {
    global haskell.compiler_list
    global haskell.compiler_configuration
    global homepage prefix configure.cmd destroot worksrcpath name master_sites configure.cc

    if {![info exists haskell.compiler_configuration($compiler)]} {
        return -code error "Compiler ${compiler} not currently supported"
    }
    array set compiler_config [lindex [array get haskell.compiler_configuration $compiler] 1]
    name                hs-[string tolower ${package}]
    version             ${version}
    categories          devel haskell
    homepage            http://hackage.haskell.org/package/${package}
    master_sites        http://hackage.haskell.org/packages/archive/${package}/${version}
    distname            ${package}-${version}
    depends_lib         port:${compiler_config(port)}
    configure.cmd       runhaskell
    configure.pre_args
    configure.args      Setup configure \
                        --prefix=${prefix} \
                        --with-compiler=[subst ${compiler_config(compiler)}] \
                        -v \
                        --enable-library-profiling \
                        --with-gcc=${configure.cc}
    build.cmd           ${configure.cmd}
    build.args          Setup build -v
    build.target
    destroot.cmd        ${configure.cmd}
    destroot.destdir
    destroot.target     Setup copy --destdir=${destroot}
    post-destroot {
        system "cd ${worksrcpath} && ${configure.cmd} Setup register --gen-script"
        system "cd ${worksrcpath} && ${configure.cmd} Setup unregister --gen-script"
        xinstall -m 755 -d ${destroot}${prefix}/libexec/${name}
        xinstall -m 755 -W ${worksrcpath} register.sh unregister.sh \
            ${destroot}${prefix}/libexec/${name}
    }
    post-activate {
        system "${prefix}/libexec/${name}/register.sh"
    }
    pre-deactivate {
        system "${prefix}/libexec/${name}/unregister.sh"
    }

    livecheck.type      regex
    livecheck.url       http://hackage.haskell.org/cgi-bin/hackage-scripts/package/${package}
    livecheck.regex     /packages/archive/${package}/.*/${package}-(.*)\.tar\.gz

    universal_variant   no
}

