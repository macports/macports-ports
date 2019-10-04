# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup         haskell_cabal 1.0
#
# This PortGroup configures the build to use the Haskell Cabal tool. It
# modifies the defaults for a number of variables, so your Portfile should take
# care not to accidentally overwrite them.
#
# The PortGroup will automatically add the required build dependencies for
# port:cabal.
#
# The configure, build, destroot and test phases are set up (although the test
# phase is not enabled automatically). A default livecheck is configured to
# hackage.haskell.org using ${name}.
#
# This PortGroup offers the following options:
#
# haskell_cabal.bin
#   The cabal binary. Defaults to ${prefix}/bin/cabal.
#
# haskell_cabal.default_args
#   Default arguments for cabal used across invocations in configure, build, and
#   destroot phases. Defaults to
#       --prefix=${prefix}
#       --bindir=${prefix}/bin
#       --libdir=${prefix}/lib
#       --libsubdir=${name}
#       --dynlibdir=${prefix}/lib
#       --libexecdir=${prefix}/libexec
#       --libexecsubdir=${name}
#       --datadir=${prefix}/share/${name}
#       --docdir=${prefix}/share/doc/${name}
#       --htmldir=${prefix}/share/doc/${name}
#       --sysconfdir=${prefix}/etc/${name}
#       --enable-documentation
#       --enable-relocatable

proc haskell_cabal.add_dependencies {} {
    global name
    if { ${name} ne "cabal" } {
        depends_build-append port:cabal \
                             port:ghc
    }
}
port::register_callback haskell_cabal.add_dependencies

# libHSbase shipped with GHC links against system libiconv, which provides the
# 'iconv' symbol, but not the 'libiconv' symbol. Because the compilation
# process statically links libHSbase.a, we must have /usr/lib in the library
# search path first :/
compiler.library_path
compiler.cpath

options haskell_cabal.bin haskell_cabal.default_args
default haskell_cabal.bin   ${prefix}/bin/cabal
default haskell_cabal.default_args \
    {--prefix=${prefix} \
        --bindir=${prefix}/bin \
        --libdir=${prefix}/lib \
        --libsubdir=${name} \
        --dynlibdir=${prefix}/lib \
        --libexecdir=${prefix}/libexec \
        --libexecsubdir=${name} \
        --datadir=${prefix}/share/${name} \
        --docdir=${prefix}/share/doc/${name} \
        --htmldir=${prefix}/share/doc/${name} \
        --sysconfdir=${prefix}/etc/${name} \
        --enable-documentation \
        --enable-relocatable}

pre-configure {
    system -W ${worksrcpath} "${haskell_cabal.bin} new-update"
}

default configure.cmd       {${haskell_cabal.bin}}
default configure.pre_args  {}
default configure.args      {new-configure ${haskell_cabal.default_args}}

default build.cmd           {${haskell_cabal.bin}}
default build.target        {new-build}
default build.args          {${haskell_cabal.default_args}}

# Note: cabal new-install does *not* use the specified --prefix'ed datadir
# Do not use new-install; rather, new-update / new-configure / new-build

destroot {
    # install binary
    set cabal_build ${worksrcpath}/dist-newstyle/build
    fs-traverse f ${cabal_build} {
        if { [file isdirectory ${f}]
            && [file tail ${f}] eq "${name}-${version}" } {
            set cabal_build ${f}
            break
        }
    }
    fs-traverse f ${cabal_build} {
        if { [file isfile ${f}]
            && [file executable ${f}]
            && [file tail ${f}] eq "${name}"
            && [file tail [file dirname ${f}]] eq "${name}" } {
            xinstall -m 0755 ${f} ${destroot}${prefix}/bin/${name}
        }
    }

    # install documentation
    if { [file isdirectory ${cabal_build}/doc] } {
        xinstall -m 0755 -d ${destroot}${prefix}/share/doc/${name}
        fs-traverse f_or_d ${cabal_build}/doc {
            set subpath [strsed ${f_or_d} "s|${cabal_build}/doc||"]
            if { ${subpath} ne "" } {
                if { [file isdirectory ${f_or_d}] } {
                    xinstall -m 0755 -d \
                        ${destroot}${prefix}/share/doc/${name}${subpath}
                } elseif { [file isfile ${f_or_d}] } {
                    xinstall -m 0644 ${f_or_d} \
                        ${destroot}${prefix}/share/doc/${name}${subpath}
                }
            }
        }
    }

    # install cabal data-files
    if { [file exists ${worksrcpath}/data]
        && [file isdirectory ${worksrcpath}/data] } {
        xinstall -m 0644 {*}[glob ${worksrcpath}/data/*] \
            ${destroot}${prefix}/share/${name}
    }
}

default livecheck.type      {regex}
default livecheck.url       {https://hackage.haskell.org/package/${name}}
default livecheck.regex     {"/package/[quotemeta ${name}]-\\\[^/\\\]+/[quotemeta ${name}]-(\\\[^\\\"\\\]+)[quotemeta ${extract.suffix}]"}
