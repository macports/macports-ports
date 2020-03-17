# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup provides support older OS releases by:
#    * providing a library for various missing library functions
#    * ameliorate the mixing of libstdc++ libraries

# Usage:
#
#   PortGroup legacysupport 1.1
#
#   legacysupport.newest_darwin_requires_legacy: newest macOS release that requires legacy support
#
#   legacysupport.header_search: preprocessor flag used to locate header directory
#
#   legacysupport.library_name: linker flag used to add library
#
#   legacysupport.redirect_bins: binary files that mix different versions of libstdc++
#                                create a wrapper so that only MacPorts libstdc++ is used

options legacysupport.newest_darwin_requires_legacy
default legacysupport.newest_darwin_requires_legacy {}

options legacysupport.header_search
default legacysupport.header_search     {-isystem${prefix}/include/LegacySupport}

options legacysupport.library_name
default legacysupport.library_name      {${prefix}/lib/libMacportsLegacySupport.dylib}

options legacysupport.redirect_bins
default legacysupport.redirect_bins     {}

# please remove when a86f95c has been in a released MacPorts version for at least two weeks
# see https://github.com/macports/macports-base/commit/a86f95c5ab86ee52c8fec2271e005591179731de
if {![info exists compiler.limit_flags]} {
    options compiler.limit_flags
    default compiler.limit_flags        no
}

namespace eval legacysupport {
}

proc legacysupport::add_legacysupport {} {
    global prefix \
           os.platform \
           os.major

    if {${os.platform} eq "darwin" && ${os.major} <= [option legacysupport.newest_darwin_requires_legacy]} {
        ui_debug "Adding legacy build support"

        # depend on the support library or devel version if installed
        depends_lib-delete path:lib/libMacportsLegacySupport.dylib:legacy-support
        depends_lib-append path:lib/libMacportsLegacySupport.dylib:legacy-support

        configure.ldflags-delete    [option legacysupport.library_name]
        configure.ldflags-append    [option legacysupport.library_name]

        if {![option compiler.limit_flags]} {
            configure.cppflags-delete   [option legacysupport.header_search]
            configure.cppflags-prepend  [option legacysupport.header_search]
        }

        compiler.cpath-delete      ${prefix}/include/LegacySupport
        compiler.cpath-prepend     ${prefix}/include/LegacySupport
    }

    # see https://trac.macports.org/ticket/59832
    if {${os.platform} eq "darwin" && [option configure.cxx_stdlib] eq "macports-libstdc++"} {
        foreach phase {configure build destroot test} {
            ${phase}.env-delete    DYLD_LIBRARY_PATH=${prefix}/lib/libgcc
            ${phase}.env-append    DYLD_LIBRARY_PATH=${prefix}/lib/libgcc
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
