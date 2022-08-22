# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#===================================================================================================
#
# This PortGroup defines a debug variant, for ports not based on CMake, Meson, etc.
#
# Usage:
#   PortGroup               debug 1.0
#
#===================================================================================================

namespace eval debug {}

if { [variant_exists debug] } {
    error "pg_debug: variant 'debug' already exists"
}

ui_debug "pg_debug: adding variant"
variant debug description {Enable debug flags and symbols} {}

proc debug::setup_debug {} {
    ui_debug "debug::setup_debug: configuring for debug build"

    configure.cflags-delete       -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.cppflags-delete     -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.cxxflags-delete     -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.objcflags-delete    -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.objcxxflags-delete  -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.fflags-delete       -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.f90flags-delete     -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.fcflags-delete      -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1

    configure.cflags-append       -g -O0
    configure.cppflags-append     -g -O0
    configure.cxxflags-append     -g -O0
    configure.objcflags-append    -g -O0
    configure.objcxxflags-append  -g -O0
    configure.fflags-append       -g -O0
    configure.f90flags-append     -g -O0
    configure.fcflags-append      -g -O0

    post-destroot {
        debug::post_destroot
    }
}

proc debug::post_destroot {} {
    global destroot prefix

    ui_debug "debug::post_destroot: Generating the .dSYM bundles"
    system -W ${destroot}${prefix} "find . -type f '(' -name '*.dylib' -or -name '*.so' ')' -exec dsymutil {} +"
}

proc debug::pg_callback {} {
    set debug_enabled [variant_isset debug]
    ui_debug "debug::pg_callback: debug enabled: ${debug_enabled}"

    if { ${debug_enabled} } {
        setup_debug
    }
}

# callback after port is parsed
port::register_callback debug::pg_callback
