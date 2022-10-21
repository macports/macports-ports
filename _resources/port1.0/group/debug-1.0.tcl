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

default debug.configure \
    [list \
        cflags \
        cppflags \
        cxxflags \
        objcflags \
        objcxxflags \
        fflags \
        f90flags \
        fcflags \
    ]

default debug.flags.delete \
    [list -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1]

default debug.flags.add \
    [list -g -O0]

ui_debug "pg_debug: adding variant"
variant debug description {Enable debug flags and symbols} {}

proc debug::setup_debug {} {
    ui_debug "debug::setup_debug: configuring for debug build"

    set conf_names   [option debug.configure]
    set flags_delete [option debug.flags.delete]
    set flags_add    [option debug.flags.add]

    foreach c ${conf_names} {
        foreach f ${flags_delete} {
            configure.${c}-delete ${f}
        }

        foreach f ${flags_add} {
            configure.${c}-append ${f}
        }
    }

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
        debug::setup_debug
    }
}

# callback after port is parsed
port::register_callback debug::pg_callback
