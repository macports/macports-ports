# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
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
    homepage            https://hackage.haskell.org/package/${package}
    master_sites        https://hackage.haskell.org/packages/archive/${package}/${version}
    distname            ${package}-${version}
    depends_lib         port:ghc
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
    	    xinstall -m 0755 -d ${destroot}${prefix}/libexec/${name}
    	    xinstall -m 0755 -W ${worksrcpath} register.sh unregister.sh \
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

