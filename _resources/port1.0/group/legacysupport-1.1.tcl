# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup provides support for older macOS releases by:
#    * providing a library for various missing library functions
#    * ameliorating the mixing of libstdc++ libraries

# Usage:
#
#   PortGroup legacysupport 1.1
#
#   legacysupport.newest_darwin_requires_legacy: newest Darwin version that requires legacy support
#
#   legacysupport.header_search: preprocessor flag used to locate header directory
#
#   legacysupport.library_name: linker flag used to add library
#
#   legacysupport.use_static: allow static linking of legacysupport if preferred (e.g. for compilers)
#
#   legacysupport.redirect_bins: binary files that mix different versions of libstdc++
#                                create a wrapper so that only MacPorts libstdc++ is used

namespace eval legacysupport {
}

# Newest Darwin version that requires legacy support.
# Currently OS X 10.12 ( Sierra, Darwin 16) due to utimensat, fsgetpath, setattrlistat
set ls_max_darwin_support 16
options legacysupport.newest_darwin_requires_legacy
default legacysupport.newest_darwin_requires_legacy ${ls_max_darwin_support}

options legacysupport.header_search
default legacysupport.header_search     {-isystem${prefix}/include/LegacySupport}

options legacysupport.library_name
default legacysupport.library_name      {[legacysupport::get_library_name]}

options legacysupport.use_static
default legacysupport.use_static        no

options legacysupport.redirect_bins
default legacysupport.redirect_bins     {}

if {[info exists makefile.override]} {
    pre-configure {
        ui_error "The legacysupport PG must be included *before* the makefile PG"
        ui_error "otherwise the latter fails to pick up the updated compiler flags."
        return -code error "configuration error"
    }
}

proc legacysupport::get_library_name {} {
    global prefix
    if {[option legacysupport.use_static]} {
        return ${prefix}/lib/libMacportsLegacySupport.a
    } else {
        return -lMacportsLegacySupport
    }
}

proc legacysupport::get_cpp_flags {} {
    global os.platform os.major
    if {${os.platform} eq "darwin" && ${os.major} <= [option legacysupport.newest_darwin_requires_legacy]} {
        return [option legacysupport.header_search]
    } else {
        return ""
    }
}

proc legacysupport::get_library_link_flags {} {
    global prefix os.platform os.major
    if {${os.platform} eq "darwin" && ${os.major} <= [option legacysupport.newest_darwin_requires_legacy]} {
        set lib [legacysupport::get_library_name]
        if {[option legacysupport.use_static]} {
            return ${lib}
        } else {
            return -L${prefix}/lib\ ${lib}
        }
    } else {
        return ""
    }
}

# Returns the newest Darwin version for which the legacy support
# library generates missing symbols.
# https://github.com/macports/macports-legacy-support
# Current Darwin 16 for utimensat, fsgetpath, setattrlistat
proc legacysupport::get_newest_darwin_with_missing_symbols {} {
    global   ls_max_darwin_support
    return ${ls_max_darwin_support}
}

# please remove when a86f95c has been in a released MacPorts version for at least two weeks
# see https://github.com/macports/macports-base/commit/a86f95c5ab86ee52c8fec2271e005591179731de
if {![info exists compiler.limit_flags]} {
    options compiler.limit_flags
    default compiler.limit_flags        no
}

proc legacysupport::get_depends_type {} {
    if {[option legacysupport.use_static]} {
        return depends_build
    } else {
        return depends_lib
    }
}

proc legacysupport::get_dependency {} {
    return path:lib/libMacportsLegacySupport.dylib:legacy-support
}

proc legacysupport::add_once { opt where value } {
    ui_debug "Will $where $value to $opt"
    ${opt}-delete   ${value}
    ${opt}-${where} ${value}
}

proc legacysupport::set_phase_env_var { var } {
    foreach phase { extract configure build destroot test } {
        legacysupport::add_once ${phase}.env append ${var}
    }
}

proc legacysupport::set_label_environment_vars { } {
    global os.platform os.major
    set env_name MACPORTS_LEGACY_SUPPORT_DISABLED
    if {${os.platform} eq "darwin" && ${os.major} <= [option legacysupport.newest_darwin_requires_legacy]} {
        set env_name MACPORTS_LEGACY_SUPPORT_ENABLED
    }
    legacysupport::set_phase_env_var ${env_name}=1
}

proc legacysupport::add_legacysupport {} {
    global prefix os.platform os.major

    if {${os.platform} eq "darwin" && ${os.major} <= [option legacysupport.newest_darwin_requires_legacy]} {
        ui_debug "Adding legacy build support"

        # depend on the support library or devel version if installed
        legacysupport::add_once [legacysupport::get_depends_type] append [legacysupport::get_dependency]

        # Add the library link flags
        legacysupport::add_once configure.ldflags append [option legacysupport.library_name]
        legacysupport::set_phase_env_var MACPORTS_LEGACY_SUPPORT_LDFLAGS=[legacysupport::get_library_link_flags]

        if {![option compiler.limit_flags]} {
            legacysupport::add_once configure.cppflags prepend [option legacysupport.header_search]
            legacysupport::set_phase_env_var MACPORTS_LEGACY_SUPPORT_CPPFLAGS=[option legacysupport.header_search]
        }

        # do not use compiler.cpath since it behaves like -I, while ${lang}_INCLUDE_PATH behaves like -isystem
        # since legacy-support uses GNU language extensions, this prevents warnings when `-pedantic` is
        # used and error when `-pedantic-errors` is used. see, e.g., llvm-devel
        foreach lang {C OBJC CPLUS OBJCPLUS} {
            legacysupport::set_phase_env_var ${lang}_INCLUDE_PATH=${prefix}/include/LegacySupport
        }
    }

    # Sets some indicator env vars to see if support is ENABLED or DISABLED.
    # Useful if scripts downstream need to check legacy support status.
    legacysupport::set_label_environment_vars

    # see https://trac.macports.org/ticket/59832
    if {${os.platform} eq "darwin" && [option configure.cxx_stdlib] eq "macports-libstdc++"} {
        foreach phase {configure build destroot test} {
            legacysupport::add_once ${phase}.env append DYLD_LIBRARY_PATH=${prefix}/lib/libgcc
        }
    }
}

port::register_callback legacysupport::add_legacysupport

proc legacysupport::legacysupport_proc {option action args} {
    if {$action ne  "set"} return
    legacysupport::add_legacysupport
}

option_proc legacysupport.newest_darwin_requires_legacy legacysupport::legacysupport_proc

# see https://trac.macports.org/ticket/59832
post-destroot {
    if {${os.platform} eq "darwin" && ${configure.cxx_stdlib} eq "macports-libstdc++"} {
        foreach rbin ${legacysupport.redirect_bins} {
            set dir [file dirname ${rbin}]
            if {${dir} eq "."} {
                set dir ${prefix}/bin
            }
            set bin ${dir}/[file tail ${rbin}]

            move    ${destroot}${bin} \
                    ${destroot}${bin}-orig

            set  wrapper    [open "${destroot}${bin}" w 0755]
            puts ${wrapper} "#!/bin/bash"
            puts ${wrapper} ""
            puts ${wrapper} {if [ -n "$DYLD_LIBRARY_PATH" ]; then}
            puts ${wrapper} "   DYLD_LIBRARY_PATH=${prefix}/lib/libgcc:\${DYLD_LIBRARY_PATH}"
            puts ${wrapper} {else}
            puts ${wrapper} "   DYLD_LIBRARY_PATH=${prefix}/lib/libgcc"
            puts ${wrapper} {fi}
            puts ${wrapper} {export DYLD_LIBRARY_PATH}
            puts ${wrapper} ""
            puts ${wrapper} {exec "${0}-orig" "$@"}
            close $wrapper

        }
    }
}
