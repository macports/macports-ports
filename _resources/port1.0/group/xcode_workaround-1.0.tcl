# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup attempts to work around problematic Xcode versions
# See https://forums.developer.apple.com/thread/121887
#
# -fno-stack-check issue only applies to macOS 10.15 but in general this PG
# could be used to address issues in other Xcode versions as well.
#
# Usage:
#
#   PortGroup        xcode_workaround 1.0
#
#   xcode_workaround.type:
#      append_to_compiler_flags (e.g. add -fno-stack-check to compiler flags)
#      append_to_compiler_name  (e.g. add -fno-stack-check to compiler name)
#      avoid_xcode_compiler     (blacklist broken compiler)
#
#   xcode_workaround.fixed_xcode_version: minimum developer version in which bug is fixed
#
#   xcode_workaround.os_versions: major Darwin versions to attempt to apply workarounds

namespace eval xcode_workaround {
}

options xcode_workaround.type
options xcode_workaround.fixed_xcode_version
options xcode_workaround.os_versions

default xcode_workaround.type                {append_to_compiler_flags}
default xcode_workaround.fixed_xcode_version {11.3}
default xcode_workaround.os_versions         {19}

proc xcode_workaround::xcode_workaround.appy_fix {} {

    global \
        os.major \
        xcodeversion \
        xcodecltversion \
        xcode_workaround.type \
        xcode_workaround.fixed_xcode_version \
        xcode_workaround.os_versions \
        configure.cc \
        configure.cxx \
        configure.cflags \
        configure.cxxflags \
        configure.objcflags \
        configure.objcxxflags \
        compiler.blacklist \
        use_xcode

    # Xcode 11 fixes (applicable to macOS 10.14 and macOS 10.15)
    set attempt_fix no
    if { [lsearch -exact ${xcode_workaround.os_versions} ${os.major}] != -1 } {
        if { ${os.major} == 19 } {
            set attempt_fix yes
        }
        if { ${os.major} == 18 && [vercmp $xcodeversion >= 11]} {
            set attempt_fix yes
        }
    }

    if { ${attempt_fix} } {

        # Check if Xcode is newer than defined fixed version
        # N.B. vercmp should properly handle none or "" for $xcodeversion or $xcodecltversion
        set xcode_is_ok [vercmp $xcodeversion >= ${xcode_workaround.fixed_xcode_version}]

        # Check flag from cltversion PG to see if Xcode or CLT should be used
        if {${use_xcode}} {
            set attempt_fix [expr {!${xcode_is_ok}}]
        } else {
            # Check if CLT version is fixed or not
            set clt_is_ok [vercmp $xcodecltversion >= ${xcode_workaround.fixed_xcode_version}]
            # If broken, but Xcode OK, use that instead
            if {${xcode_is_ok} && !${clt_is_ok}} {
                # MacPorts defaults to CLTs, but Xcode can easily be ahead
                ui_debug "xcode_workaround: using Xcode since the bug is fixed there"
                use_xcode yes
                set attempt_fix no
            } else {
                set attempt_fix [expr {!${clt_is_ok}}]
            }
        }

    }

    # Apply the configured fix type
    if { ${attempt_fix} } {
        switch -- ${xcode_workaround.type} {
            append_to_compiler_flags  {
                # -fno-stack-check workaround only needed on Darwin 19
                if { ${os.major} == 19 } {
                    ui_debug "xcode_workaround: Adding -fno-stack-check to compiler flags."
                    configure.cflags-delete      -fno-stack-check
                    configure.cflags-append      -fno-stack-check
                    configure.cxxflags-delete    -fno-stack-check
                    configure.cxxflags-append    -fno-stack-check
                    configure.objcflags-delete   -fno-stack-check
                    configure.objcflags-append   -fno-stack-check
                    configure.objcxxflags-delete -fno-stack-check
                    configure.objcxxflags-append -fno-stack-check
                }
            }
            append_to_compiler_name {
                # -fno-stack-check workaround only needed on Darwin 19
                if { ${os.major} == 19 } {
                    ui_debug "xcode_workaround: Adding -fno-stack-check to compiler name."
                    configure.cc-delete  -fno-stack-check
                    configure.cc-append  -fno-stack-check
                    configure.cxx-delete -fno-stack-check
                    configure.cxx-append -fno-stack-check
                }
            }
            avoid_xcode_compiler {
                # Applicable to both Darwin 18 and 19
                ui_debug "xcode_workaround: blacklisting Clang compiler."
                compiler.blacklist-delete clang
                compiler.blacklist-append clang
            }
            default {
                ui_error "${xcode_workaround.type} is an unrecognized option for xcode_workaround.type"
                return -code error "unrecognized Xcode 11 workaround type"
            }
        }
    }

}

port::register_callback xcode_workaround::xcode_workaround.appy_fix

proc xcode_workaround::xcode_workaround._proc {option action args} {
    if {$action ne "set"} return
    xcode_workaround.appy_fix
}

option_proc xcode_workaround.type xcode_workaround::xcode_workaround._proc
