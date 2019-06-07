# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup       haskell 1.0
# haskell.setup   haskell_package version [haskell_compiler]
# where haskell_package is the name of the package (eg, digest), version
# is the version for it, and haskell_compiler is which compiler to use
# (ghc is the default if not specified, and currently the only option).
# This automatically defines name, version, categories, homepage,
# master_sites, distname, and depends_build as appropriate, and sets up
# the configure, build, destroot, and post-activate stages.


# List of supported compilers
set haskell.compiler_list {ghc}

# Configuration for each compiler

# I'm explicitly *not* determining the GHC version programatically here,
# because doing so would allow GHC packages to continue working when
# installed from source after a GHC update without a revbump. That's however
# not what I want, because it has previously lead to problems when mixing
# buildbot packages with locally compiled ones around the time of GHC
# updates.
array set haskell.compiler_configuration {
    ghc {port       ghc
         version    7.8.3
         compiler   ${prefix}/bin/ghc
         ghc-pkg    ${prefix}/bin/ghc-pkg}
}

proc haskell.setup {package version {compiler ghc} {register_scripts "yes"} {target "standalone"}} {
    global haskell.compiler_list
    global haskell.compiler_configuration
    global homepage prefix configure.cmd destroot worksrcpath name master_sites configure.cc extract.suffix

    if {![info exists haskell.compiler_configuration($compiler)]} {
        return -code error "Compiler ${compiler} not currently supported"
    }
    array set compiler_config [lindex [array get haskell.compiler_configuration $compiler] 1]

    if {${target} eq "standalone"} {
        # Do not set name when used for haskell platform port, because those
        # are subports and cannot touch $name
        name            hs-[string tolower ${package}]
    }
    version             ${version}
    categories          devel haskell
    homepage            https://hackage.haskell.org/package/${package}
    master_sites        https://hackage.haskell.org/package/${package}-${version}
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
    if {${register_scripts} == "yes"} {
        # Create the package config, drop it in package.conf.d for the current
        # GHC version and run ghc-pkg recache.
        # Do not use the Setup register --gen-script and Setup unregister
        # --gen-script method to generate scripts and call them during
        # activation. It previously caused a mess that was hard to clean up,
        # especially since ghc-pkg is pretty stubborn in removing packages when
        # there are still dependencies left.

        set package_conf_d ${prefix}/lib/ghc-${compiler_config(version)}/package.conf.d/
        set generate_pkg_config_cmdline [list \
            ${configure.cmd} Setup register \
            --gen-pkg-config=${package}-${version}.conf]
        set generate_pkg_config_hook [subst {
            xinstall -d -m 0755 [list ${destroot}${package_conf_d}]
            system -W [list ${worksrcpath}] [list $generate_pkg_config_cmdline]
            xinstall -m 0644 [list ${worksrcpath}/${package}-${version}.conf] \
                [list ${destroot}${package_conf_d}]
        }]
        post-destroot $generate_pkg_config_hook

        set ghc_pkg_recache [list [subst ${compiler_config(ghc-pkg)}] recache -v]
        set ghc_pkg_recache_hook [subst {
            system [list $ghc_pkg_recache]
        }]
        post-activate $ghc_pkg_recache_hook
        post-deactivate $ghc_pkg_recache_hook
    }

    set ghc_pkg_list  [list [subst ${compiler_config(ghc-pkg)}] list]
    set ghc_pkg_check [list [subst ${compiler_config(ghc-pkg)}] check]

    pre-configure [subst {
        global ports_trace

        ui_debug "Listing installed haskell packages"
        catch {system [list $ghc_pkg_list]}

        if [list {![tbool ports_trace]}] {
            ui_debug "Running ghc-pkg check"
            catch {system [list $ghc_pkg_check]}
        } else {
            ui_debug "Skipping ghc-pkg check because it generates wrong results in trace mode"
        }
    }]

    if {${target} eq "standalone"} {
        livecheck.type      regex
        livecheck.url       https://hackage.haskell.org/package/${package}
        livecheck.regex     "/package/[quotemeta ${package}]-\[^/\]+/[quotemeta ${package}]-(\[^\"\]+)[quotemeta ${extract.suffix}]"
    } else {
        # Disable livecheck for haskell platform ports
        livecheck.type      none
    }

    universal_variant   no
}
