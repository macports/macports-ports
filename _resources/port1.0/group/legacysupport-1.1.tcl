# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup provides support for older macOS releases by:
#    * providing a library for various missing library functions
#    * ameliorating the mixing of libstdc++ libraries
#
# Usage:
#
#   PortGroup legacysupport 1.1
#
#   legacysupport.newest_darwin_requires_legacy: newest Darwin version that requires legacy support
#
#   legacysupport.use_static: allow static linking of legacysupport if preferred (e.g. for compilers)
#
#   legacysupport.redirect_bins: binary files that mix different versions of libstdc++
#                                create a wrapper so that only MacPorts libstdc++ is used
#
#   legacysupport.use_mp_libcxx: Use an update libcxx runtime from a recent macports clang build

namespace eval legacysupport {
}

# Newest Darwin version that requires legacy support.
# Currently OS X 10.12 ( Sierra, Darwin 16) due to utimensat, fsgetpath, setattrlistat
set ls_max_darwin_support 16
options legacysupport.newest_darwin_requires_legacy
default legacysupport.newest_darwin_requires_legacy ${ls_max_darwin_support}

options legacysupport.use_static
default legacysupport.use_static        no

options legacysupport.redirect_bins
default legacysupport.redirect_bins     {}

options legacysupport.use_mp_libcxx
default legacysupport.use_mp_libcxx     no

options legacysupport.disable_function_wrap
default legacysupport.disable_function_wrap no

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
    global os.platform os.major prefix
    if {${os.platform} eq "darwin" && ${os.major} <= [option legacysupport.newest_darwin_requires_legacy]} {
        if { [option legacysupport.disable_function_wrap] } {
            return "-isystem${prefix}/include/LegacySupport -D__DISABLE_MP_LEGACY_SUPPORT_REALPATH_WRAP__=1 -D__DISABLE_MP_LEGACY_SUPPORT_SYSCONF_WRAP__=1"
        } else {
            return  -isystem${prefix}/include/LegacySupport
        }
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
    ui_debug "legacysupport: Will $where $value to $opt"
    ${opt}-delete   ${value}
    ${opt}-${where} ${value}
}

proc legacysupport::set_phase_env_var { var } {
    foreach phase { extract configure build destroot test } {
        legacysupport::add_once ${phase}.env append ${var}
    }
}

proc legacysupport::remove_phase_env_var { var } {
    foreach phase { extract configure build destroot test } {
        ${phase}.env-delete ${var}
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

proc legacysupport::relink_libSystem { exe } {
    global os.major prefix
    if { ${os.major} <= [option legacysupport.newest_darwin_requires_legacy] } {
        set         sLib /usr/lib/libSystem.B.dylib
        set         lLib ${prefix}/lib/libMacportsLegacySystem.B.dylib
        ui_debug "legacysupport: Relinking ${exe} against ${lLib}"
        system "install_name_tool -change ${sLib} ${lLib} ${exe}"
    }
}

set ls_cache_incpath  [list]
set ls_cache_ldflags  [list]
set ls_cache_cppflags [list]

proc legacysupport::add_legacysupport {} {
    global prefix os.platform os.major
    global ls_cache_incpath ls_cache_ldflags ls_cache_cppflags

    if { ${os.platform} eq "darwin" && ${os.major} <= [option legacysupport.newest_darwin_requires_legacy] } {

        # depend on the support library or devel version if installed
        legacysupport::add_once [legacysupport::get_depends_type] append [legacysupport::get_dependency]

        # First clean out any old settings
        if { ${ls_cache_incpath} ne "" } {
            foreach f ${ls_cache_ldflags}  { configure.ldflags-delete ${f} }
            foreach f ${ls_cache_cppflags} { configure.cppflags-delete ${f} }
            foreach lang {C OBJC CPLUS OBJCPLUS} {
                legacysupport::remove_phase_env_var ${lang}_INCLUDE_PATH=[string map {" " ":"} ${ls_cache_incpath}]
            }
        }

        # Add flags for legacy-support library
        set ls_cache_incpath  "${prefix}/include/LegacySupport"
        set ls_cache_ldflags  "[join [legacysupport::get_library_link_flags]]"
        set ls_cache_cppflags "[legacysupport::get_cpp_flags]"

        # Flags for using MP libcxx
        if { [option legacysupport.use_mp_libcxx] } {
            legacysupport::add_once depends_lib append port:macports-libcxx
            append ls_cache_incpath  " ${prefix}/include/libcxx/v1"
            append ls_cache_ldflags  " -L${prefix}/lib/libcxx"
            append ls_cache_cppflags " -nostdinc++ -isystem${prefix}/include/libcxx/v1"
        }

        ui_debug "legacysupport: ldflags  ${ls_cache_ldflags}"
        ui_debug "legacysupport: cppflags ${ls_cache_cppflags}"
        ui_debug "legacysupport: incpath  ${ls_cache_incpath}"

        # Add the flags
        foreach f ${ls_cache_ldflags} { legacysupport::add_once configure.ldflags append ${f} }
        legacysupport::set_phase_env_var MACPORTS_LEGACY_SUPPORT_LDFLAGS=[join ${ls_cache_ldflags}]
        if {![option compiler.limit_flags]} {
            foreach f ${ls_cache_cppflags} { legacysupport::add_once configure.cppflags prepend ${f} }
            legacysupport::set_phase_env_var MACPORTS_LEGACY_SUPPORT_CPPFLAGS=[join ${ls_cache_cppflags}]
        }

        # do not use compiler.cpath since it behaves like -I, while ${lang}_INCLUDE_PATH behaves like -isystem
        # since legacy-support uses GNU language extensions, this prevents warnings when `-pedantic` is
        # used and error when `-pedantic-errors` is used. see, e.g., llvm-devel
        foreach lang {C OBJC CPLUS OBJCPLUS} {
            legacysupport::set_phase_env_var ${lang}_INCLUDE_PATH=[string map {" " ":"} ${ls_cache_incpath}]
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

# callback after port is parsed
port::register_callback legacysupport::add_legacysupport

proc legacysupport::legacysupport_proc {option action args} {
    if {$action ne "set"} return
    legacysupport::add_legacysupport
}

# Reconfigure if any options are explicitly set
option_proc legacysupport.newest_darwin_requires_legacy legacysupport::legacysupport_proc
option_proc legacysupport.legacysupport.use_mp_libcxx   legacysupport::legacysupport_proc
option_proc legacysupport.legacysupport.use_static      legacysupport::legacysupport_proc

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
