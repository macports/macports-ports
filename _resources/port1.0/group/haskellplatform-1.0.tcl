# $Id$
#
# Copyright (c) 2009-2012 The MacPorts Project
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
# PortGroup                 haskell-platform 1.0
# haskellplatform.setup     haskell_package version [register_scripts]
# where haskell_package is the name of the package (eg, digest), version is the
# version for it. This automatically defines name, version, categories,
# homepage, master_sites, distname, and depends_build as appropriate, and sets
# up the configure, build, destroot, and post-activate stages. It can do
# pre-deactivate if that ever becomes an option in MacPorts. register_scripts
# can be used to deactivate installing register.sh and unregister.sh as might be
# needed for non-library parts of the haskell platform. Set it to "no" to
# achieve this; defaults to "yes".


proc haskellplatform.setup {package version {register_scripts "yes"}} {
    global homepage prefix configure.cmd configure.cc destroot worksrcpath name master_sites

    name                hs-platform-[string tolower ${package}]
    version             ${version}
    categories          devel haskell
    homepage            http://hackage.haskell.org/package/${package}
    master_sites        http://hackage.haskell.org/packages/archive/${package}/${version}
    distname            ${package}-${version}
    depends_lib         port:hs-platform-ghc
    configure.args      Setup configure \
                        --prefix=${prefix} \
                        --with-compiler=${prefix}/bin/ghc \
                        -v \
                        --enable-library-profiling \
						--with-gcc=${configure.cc}
    configure.cmd       runhaskell
    configure.pre_args

    build.cmd           ${configure.cmd}
    build.args          Setup build -v
    build.target
    destroot.cmd        ${configure.cmd}
    destroot.destdir
    destroot.target     Setup copy --destdir=${destroot}
	if {${register_scripts} == "yes"} {
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
	}
    universal_variant   no

    livecheck.type      none
}

