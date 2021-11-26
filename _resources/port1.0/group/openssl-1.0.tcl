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
default openssl.configure {env_vars pkgconfig build_flags}

# cache variables storing current configuration state
default openssl_cache_branch_nodot ""
default openssl_cache_depends      ""
default openssl_cache_incdir       ""
default openssl_cache_libdir       ""
default openssl_cache_cpath        ""
default openssl_cache_cmake_flags  ""
default openssl_cache_configure    ""
default openssl_cache_env_vars     [list ]

proc openssl::default_branch {} {
    # NOTE - Whenever the default branch is bumped, the revision
    # in the openssl shim port should be reset back to 0.
    return 3
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

proc openssl::known_branches {} {
    return [list no_version 1.0 1.1 3]
}

proc openssl::check_branch {} {
    set branch_ok [ expr { [option openssl.branch] in [openssl::known_branches] } ]
    if { !${branch_ok} } {
        ui_error "Invalid OpenSSL branch '[option openssl.branch]'"
        ui_error "Valid branches are '[openssl::known_branches]'"
        return -code error "Invalid OpenSSL branch"
    }
    return ${branch_ok}
}

proc openssl::is_enabled {} {
    return [expr [openssl::check_branch] && {[option openssl.branch] != "no_version"} ]
}

proc openssl::set_openssl_dependency {} {
    global openssl_cache_branch_nodot openssl_cache_depends
    
    if { [openssl::is_enabled] } {

        ui_debug "openssl: Set OpenSSL Branch dependency [option openssl.branch]"

        # Just in case, remove this dep
        depends_lib-delete path:lib/libssl.dylib:openssl

        # Set the requested opensslX dependency
        if { ${openssl_cache_branch_nodot} ne "" && ${openssl_cache_depends} ne "" } {
            depends_${openssl_cache_depends}-delete port:openssl${openssl_cache_branch_nodot}
        }
        set openssl_cache_depends      [option openssl.depends_type]
        set openssl_cache_branch_nodot [openssl::branch_nodot]
        set openssl_cache_configure    ""
        depends_[option openssl.depends_type]-append port:openssl[openssl::branch_nodot]
    }
}
port::register_callback openssl::set_openssl_dependency

# Detect if cmake is being used
proc openssl::check_for_cmake {} {
    if { [openssl::is_enabled] } {
        if { [string match *cmake* [option configure.cmd] ] } {
            if { ![string match *cmake* [option openssl.configure] ] } {
                ui_debug "openssl: Appending cmake to openssl configuration types"
                openssl.configure-append cmake
            }
        }
    }
}
port::register_callback openssl::check_for_cmake

proc openssl::add_once { opt where value } {
    ui_debug "openssl:  -> Will $where $value to $opt"
    ${opt}-delete   ${value}
    ${opt}-${where} ${value}
}

proc openssl::set_phase_env_var { var } {
    foreach phase { extract configure build destroot test } {
        openssl::add_once ${phase}.env append ${var}
    }
}

proc openssl::remove_phase_env_var { var } {
    foreach phase { extract configure build destroot test } {
        ui_debug "openssl:  -> removing env var ${var}"
        ${phase}.env-delete ${var}
    }
}

proc openssl::configure_build {} {
    global prefix
    global openssl_cache_branch_nodot openssl_cache_depends openssl_cache_env_vars
    global openssl_cache_incdir openssl_cache_libdir openssl_cache_cmake_flags
    global openssl_cache_configure openssl_cache_cpath

    if { [openssl::is_enabled] } {

        # Has configuration changed in any way ?
        if { ${openssl_cache_branch_nodot} ne [openssl::branch_nodot] ||
             ${openssl_cache_depends} ne [option openssl.depends_type] ||
             ${openssl_cache_configure} ne [option openssl.configure] } {

            ui_debug "openssl: Configure Types '[option openssl.configure]' Branch [option openssl.branch]"

            # If no configure method(s) given do nothing
            set openssl_cache_configure [option openssl.configure]
            if { [option openssl.configure] ne "" } {

                foreach meth [option openssl.configure] {
                    switch ${meth} {
                        env_vars {
                            ui_debug "openssl: -> Setting openssl environment variable configuration"
                            foreach var ${openssl_cache_env_vars} {
                                openssl::remove_phase_env_var ${var}
                            }
                            # Set various env vars. that may help ports locate the correct openssl installation
                            set openssl_cache_env_vars [list \
                                                            OPENSSLDIR=[openssl::install_area] \
                                                            OPENSSL_DIR=[openssl::install_area]
                                                       ]
                            foreach var ${openssl_cache_env_vars} {
                                openssl::set_phase_env_var ${var}
                            }
                        }
                        pkgconfig {
                            ui_debug "openssl: -> Setting openssl pkgconfig configuration"
                            configure.pkg_config_path-prepend [openssl::pkgconfig_dir]
                            depends_build-delete port:pkgconfig
                            depends_build-append port:pkgconfig
                        }
                        build_flags {
                            ui_debug "openssl: -> Setting openssl build flags configuration"
                            if { ${openssl_cache_incdir} ne "" } {
                                configure.cppflags-delete -I${openssl_cache_incdir}
                                configure.cflags-delete   -I${openssl_cache_incdir}
                            }
                            if { ${openssl_cache_libdir} ne "" } {
                                configure.ldflags-prepend  -L${openssl_cache_libdir}
                            }
                            set openssl_cache_incdir [openssl::include_dir]
                            set openssl_cache_libdir [openssl::lib_dir]
                            configure.cppflags-prepend -I${openssl_cache_incdir}
                            configure.cflags-prepend   -I${openssl_cache_incdir}
                            configure.ldflags-prepend  -L${openssl_cache_libdir}
                            # Look in specific install areas before the main prefix
                            configure.cppflags-replace -I${prefix}/include -isystem${prefix}/include
                            # prepend to CPATH
                            if { ${openssl_cache_cpath} ne "" } {
                                compiler.cpath-delete ${openssl_cache_cpath}
                            }
                            set openssl_cache_cpath [openssl::include_dir]
                            compiler.cpath-prepend ${openssl_cache_cpath}
                        }
                        cmake {
                            ui_debug "openssl: -> Setting openssl cmake configuration"
                            if { ${openssl_cache_cmake_flags} ne "" } {
                                foreach flag ${openssl_cache_cmake_flags} {
                                    configure.args-delete ${flag}
                                }
                            }
                            # Try and cover all bases here and set all possible variables ...
                            # See https://cmake.org/cmake/help/latest/module/FindOpenSSL.html
                            set openssl_cache_cmake_flags [list \
                                                               -DOPENSSL_ROOT_DIR=[openssl::install_area] \
                                                               -DOPENSSL_INCLUDE_DIR=[openssl::include_dir] \
                                                               -DWITH_SSL=[openssl::install_area]
                                                          ]
                            foreach flag ${openssl_cache_cmake_flags} {
                                configure.args-append ${flag}
                            }
                        }
                        default {
                            return -code error "invalid method \"${meth}\" for openssl.configure"
                        }
                    }
                }

            }

        }

    }
}
port::register_callback openssl::configure_build

proc openssl::branch_proc {option action args} {
    if {$action ne "set"} return
    ui_debug "openssl: branch_proc $action : Branch [option openssl.branch]"
    openssl::set_openssl_dependency
    openssl::configure_build
}
option_proc openssl.branch openssl::branch_proc

proc openssl::configure_proc {option action args} {
    if {$action ne "set"} return
    ui_debug "openssl: configure_proc $action : Configure '[option openssl.configure]'"
    openssl::configure_build
}
option_proc openssl.configure openssl::configure_proc
