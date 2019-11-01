# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup attempts to work around a bug in Xcode 11 on Catalina.
# See https://forums.developer.apple.com/thread/121887
#
# Usage:
#
#   PortGroup        xcode_workaround 1.0
#
#   xcode_workaround.type:
#      append_to_compiler_flags (add -fno-stack-check to compiler flags)
#      append_to_compiler_name  (add -fno-stack-check to compiler name)
#      avoid_xcode_compiler     (blacklist broken compiler)
#
#   xcode_workaround.fixed_xcode_version: minimum developer version in which bug is fixed

PortGroup cltversion 1.0

namespace eval xcode_workaround {
}

options xcode_workaround.type
options xcode_workaround.fixed_xcode_version

default xcode_workaround.type                {append_to_compiler_flags}
default xcode_workaround.fixed_xcode_version {11.3}

proc xcode_workaround::xcode_workaround.appy_fix {} {
    global \
        os.major \
        xcodeversion \
        cltversion \
        developerversion \
        xcode_workaround.type \
        xcode_workaround.fixed_xcode_version \
        configure.cc \
        configure.cxx \
        configure.cflags \
        configure.cxxflags \
        configure.objcflags \
        configure.objcxxflags \
        compiler.blacklist \
        use_xcode

    if {${os.major} != 19} {
        # -fno-stack-check is the default prior to macOS 10.15
        # assume this issue will be fixed by macOS 10.16
        set apply_fix no
    } else {
        # N.B. vercmp should properly handle none or "" for $xcodeversion or $cltversion
        set xcode_is_ok [expr [vercmp $xcodeversion ${xcode_workaround.fixed_xcode_version}] >= 0]

        if {${use_xcode}} {
            set apply_fix [expr !${xcode_is_ok}]
        } else {
            set clt_is_ok [expr [vercmp $cltversion ${xcode_workaround.fixed_xcode_version}] >= 0]

            if {${xcode_is_ok} && !${clt_is_ok}} {
                # MacPorts defaults to CLTs, but Xcode can easily be ahead
                ui_debug "xcode_workaround: using Xcode since the bug is fixed there"
                use_xcode yes
                set apply_fix no
            } else {
                set apply_fix [expr !${clt_is_ok}]
            }
        }
    }

    if {${apply_fix}} {
        switch -- ${xcode_workaround.type} {
            append_to_compiler_flags  {
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
            append_to_compiler_name {
                ui_debug "xcode_workaround: Adding -fno-stack-check to compiler name."
                configure.cc-delete  -fno-stack-check
                configure.cc-append  -fno-stack-check
                configure.cxx-delete -fno-stack-check
                configure.cxx-append -fno-stack-check
            }
            avoid_xcode_compiler {
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
    if {$action ne  "set"} return
    xcode_workaround.appy_fix
}

option_proc xcode_workaround.type xcode_workaround::xcode_workaround._proc
