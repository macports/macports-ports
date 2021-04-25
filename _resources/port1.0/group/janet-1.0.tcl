# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Usage:
# PortGroup     janet 1.0
#
# This PortGroup allows projects to be built with jpm
#     (see https://janet-lang.org/docs/jpm.html).
#

# search in ${prefix}/lib/janet/bin and create link in ${prefix}/bin
options janet.link_bin
default janet.link_bin          yes

# program to create and maintain library archives
options janet.compiler.ar
default janet.compiler.ar       {[janetpg::get_default_ar]}

namespace eval janetpg {
}

proc janetpg::get_default_ar {} {
    # no doubt that at some point, for some systems, the ar from cctools will have to be used
    return /usr/bin/ar
}

# The build command jpm does not respect CFLAGS/CXXFLAGS.
# You can set the compilers, but no spaces seem to be allowed.
# Hence, we cannot simply append the CFLAGS/CXXFLAGS to the compiler name.
# As a workaround, create custom compilers with CFLAGS/CXXFLAGS baked in.
pre-configure {
    # create directory
    xinstall -d -m 0755 ${worksrcpath}/macports_bin
    # create empty files with the correct permissions
    foreach bin {cc cxx ar} {
        close [open ${worksrcpath}/macports_bin/${bin} w 0755]
    }
}
default configure.pre_args      {}
default configure.cmd           {
    /bin/echo \\\\#!/bin/bash >> ${worksrcpath}/macports_bin/cc  && echo exec \\\$CC  \\\$CFLAGS   \\\\\"\\\\$@\\\\\" >> ${worksrcpath}/macports_bin/cc  &&
    /bin/echo \\\\#!/bin/bash >> ${worksrcpath}/macports_bin/cxx && echo exec \\\$CXX \\\$CXXFLAGS \\\\\"\\\\$@\\\\\" >> ${worksrcpath}/macports_bin/cxx &&
    /bin/echo \\\\#!/bin/bash >> ${worksrcpath}/macports_bin/ar  && echo exec ${janet.compiler.ar} \\\\\"\\\\$@\\\\\" >> ${worksrcpath}/macports_bin/ar
}
default configure.post_args     {}

# Build with jpm.
default build.cmd               {${prefix}/bin/jpm}
default build.args              {--verbose
                                 --offline
                                 --compiler=${worksrcpath}/macports_bin/cc
                                 --cpp-compiler=${worksrcpath}/macports_bin/cxx
                                 --archiver=${worksrcpath}/macports_bin/ar
                                 build
                                }
default build.target            {}

# Install with jpm.
default destroot.cmd            {${prefix}/bin/jpm}
default destroot.args           {--verbose
                                 --offline
                                 install
                                }
default destroot.target         {}
default destroot.destdir        {}

pre-destroot {
    xinstall -d -m 0755         ${destroot}${prefix}/lib/janet
}

post-destroot {
    if {${janet.link_bin}} {
        foreach bin [glob -nocomplain -tails -directory ${destroot}${prefix}/lib/janet/bin *] {
            ln -s ${prefix}/lib/janet/bin/${bin} ${destroot}${prefix}/bin
        }
    }
}

proc janetpg::janet_setup {} {
    destroot.env-append         JANET_PATH=[option destroot][option prefix]/lib/janet
    depends_lib-delete          port:janet
    depends_lib-append          port:janet
}

port::register_callback janetpg::janet_setup
