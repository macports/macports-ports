# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     openssl 1.0
#
# This port group handles setting ports up to build against specific openssl versions

namespace eval openssl { }

options openssl.branch
default openssl.branch {[openssl::default_branch]}

options openssl.depends_type
default openssl.depends_type lib

options openssl.configure
default openssl.configure {}

# cache variables storing current configuration state
default openssl_cache_branch_nodot ""
default openssl_cache_depends      ""

proc openssl::default_branch {} {
    return 1.1
}

proc openssl::branch {} {
    return [option openssl.branch]
}

proc openssl::branch_nodot {} {
    return [string map {. {}} [openssl::branch]]
}

proc openssl::install_area {} {
    global prefix
    return ${prefix}/libexec/openssl[openssl::branch_nodot]
}

proc openssl::include_dir {} {
    return [openssl::install_area]/include
}

proc openssl::lib_dir {} {
    return [openssl::install_area]/lib
}

proc openssl::pkgconfig_dir {} {
    return [openssl::install_area]/lib/pkgconfig
}

proc openssl::bin_dir {} {
    return [openssl::install_area]/bin
}

proc openssl::depends_portname {} {
    return openssl[openssl::branch_nodot]
}

proc openssl::set_openssl_dependency {} {
    global openssl_cache_branch_nodot openssl_cache_depends
    
    # Just incase, remove this dep
    depends_lib-delete path:lib/libssl.dylib:openssl
    
    # Set the requested opensslX dependency
    if { ${openssl_cache_branch_nodot} ne "" && ${openssl_cache_depends} ne "" } {
        depends_${openssl_cache_depends}-delete port:openssl${openssl_cache_branch_nodot}
    }
    set openssl_cache_depends      [option openssl.depends_type]
    set openssl_cache_branch_nodot [openssl::branch_nodot]
    depends_[option openssl.depends_type]-append port:openssl[openssl::branch_nodot]
}

proc openssl::configure_build {} {

    ui_debug "Configure Types '[option openssl.configure]'"
    
    # If no configure method(s) given do nothing
    if { [option openssl.configure] ne "" } {

        openssl::set_openssl_dependency
        
        foreach meth [option openssl.configure] {
            switch ${meth} {
                pkgconfig {
                    ui_debug " -> Setting openssl pkgconfig configuration"
                    configure.pkg_config_path-prepend [openssl::pkgconfig_dir]
                    depends_build-delete port:pkgconfig
                    depends_build-append port:pkgconfig
                }
                build_flags {
                    ui_debug " -> Setting openssl build flags configuration"
                    configure.cppflags-prepend -I[openssl::include_dir]
                    configure.cflags-prepend   -I[openssl::include_dir]
                    configure.ldflags-prepend  -L[openssl::lib_dir]
                }
                default {
                    return -code error "invalid method \"${meth}\" for openssl.configure"
                }
            }
        }
        
    }

}

proc openssl::configure_proc {option action args} {
    if {$action ne "set"} return
    openssl::configure_build
}

option_proc openssl.configure openssl::configure_proc
