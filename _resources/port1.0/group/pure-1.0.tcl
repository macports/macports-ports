# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup automatically sets up the standard environment for building
# a module for the Pure language.
#
# Usage:
#
#   PortGroup               pure 1.0
#   pure.setup              module module_version
#
# where module is the name of the module (e.g. pure-gsl) and module_version is
# its version.


PortGroup                       github 1.0

proc pure.setup {module module_version} {
    global name homepage

    github.setup                agraef pure-lang ${module_version} ${module}-
    name                        ${module}
    categories-append           pure
    homepage                    https://github.com/agraef/pure-lang/wiki/Addons#${name}
    github.tarball_from         releases
    distname                    ${name}-${module_version}

    depends_lib-append          port:pure

    use_configure               no

    build.args-append           PUREC_FLAGS=-mcpu=generic

    pre-build {
        if {${configure.cxx_stdlib} ne "" && [string match "*clang*" [option configure.cxx]]} {
            configure.cxxflags-append -stdlib=${configure.cxx_stdlib}
        }
        build.args-append       CC="${configure.cc}" \
                                CFLAGS="${configure.cflags} ${configure.cc_archflags}" \
                                CPPFLAGS="${configure.cppflags}" \
                                CXX="${configure.cxx}" \
                                CXXFLAGS="${configure.cxxflags} ${configure.cxx_archflags}" \
                                LDFLAGS="${configure.ldflags} ${configure.ld_archflags}"
    }

    post-destroot {
        xinstall -d ${destroot}${prefix}/share/doc/${name}
        foreach f {COPYING README} {
            if {[file exists ${worksrcpath}/${f}]} {
                xinstall -m 0644 ${worksrcpath}/${f} ${destroot}${prefix}/share/doc/${name}
            }
        }
        if {[file exists ${worksrcpath}/examples]} {
            xinstall -d ${destroot}${prefix}/share/examples
            copy ${worksrcpath}/examples ${destroot}${prefix}/share/examples/${name}
        }
    }
}
