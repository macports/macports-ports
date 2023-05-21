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

if { [variant_exists debugoptimized] } {
    error "pg_debug: variant 'debugoptimized' already exists"
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

default debugoptimized.flags.delete \
    [list]
default debugoptimized.flags.add \
    [list -g]

ui_debug "pg_debug: adding variants"
variant debug conflicts debugoptimized description {Enable debug flags and symbols} {}
variant debugoptimized conflicts debug description {Enable debug flags and symbols, while building optimized code} {}

proc debug::setup_debug {p_debug_mode} {
    ui_debug "debug::setup_debug: configuring for debug mode: ${p_debug_mode}"

    set conf_names   [option debug.configure]
    set flags_delete [option ${p_debug_mode}.flags.delete]
    set flags_add    [option ${p_debug_mode}.flags.add]

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
    set debug_enabled          [variant_isset debug]
    set debugoptimized_enabled [variant_isset debugoptimized]

    if { ${debug_enabled} } {
        set debug_mode debug
    } elseif { ${debugoptimized_enabled} } {
        set debug_mode debugoptimized
    } else {
        set debug_mode disabled
    }

    ui_debug "debug::pg_callback: debug mode: ${debug_mode}"

    if { ${debug_mode} ne "disabled" } {
        debug::setup_debug ${debug_mode}
    }
}

# callback after port is parsed
port::register_callback debug::pg_callback
