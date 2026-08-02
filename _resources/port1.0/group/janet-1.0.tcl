# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Usage:
# PortGroup     janet 1.0
#
# This PortGroup allows projects to be built with jpm
#     (see https://janet-lang.org/docs/jpm.html).
#

PortGroup compiler_wrapper      1.0
compwrap.print_compiler_command no

# search in ${prefix}/lib/janet/bin and create link in ${prefix}/bin
options janet.link_bin
default janet.link_bin          yes

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
# Use compiler_wrapper PG to do this.

use_configure                   no

pre-build {
    # Generate the wrappers
    foreach bin {cc cxx} {
        compwrap::wrap_compiler ${bin}
    }
}

# Build with jpm.
default build.cmd               {${prefix}/bin/jpm}
default build.args              {--verbose
                                 --offline
                                 --cc=[compwrap::wrapped_compiler_path cc]
                                 --c++=[compwrap::wrapped_compiler_path cxx]
                                 --ar=[janetpg::get_default_ar]
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
    xinstall -d -m 0755         ${destroot}${prefix}/lib/jpm/.manifests
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
    destroot.env-append         JANET_MODPATH=[option destroot][option prefix]/lib/jpm
    depends_lib-delete          port:janet
    depends_lib-delete          port:jpm
    depends_lib-append          port:janet
    depends_lib-append          port:jpm
}

port::register_callback janetpg::janet_setup
