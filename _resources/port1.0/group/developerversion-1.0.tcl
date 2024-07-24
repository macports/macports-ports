# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup lets a port check that the user's Developer Tools is sufficiently new.
#
# Usage:
#
#   PortGroup                   developerversion 1.0
#   minimum_developerversions   {darwin_major minimum_developerversion}
#
# where darwin_major is the major version of the underlying Darwin OS (e.g. 16
# for macOS 10.12 Sierra) and minimum_developerversion is the minimum version
# of the developer tools (either Xcode or the Command Line Tools) the port requires (e.g. 3.1).

namespace eval developerversion {}

options minimum_developerversions \
        developerversion
default minimum_developerversions {}
default developerversion {[developerversion::get_default_developerversion]}

platform macosx {
    pre-extract {
        foreach {darwin_major minimum_developerversion} [concat {*}${minimum_developerversions}] {
            if {${darwin_major} == ${os.major}} {
                if {![info exists developerversion] || $developerversion eq "none" || $developerversion eq ""} {
                    ui_error "Couldn't determine your Developer Tools version."
                    ui_error ""
                    ui_error "On macOS ${macosx_version}, ${name} @${version} requires Developer Tools ${developerversion} or later but you have none installed."
                    ui_error ""
                    return -code error "unable to find Developer Tools"
                }
                if {[vercmp ${developerversion} < ${minimum_developerversion}]} {
                    ui_error "On macOS ${macosx_version}, ${subport} @${version} requires Developer Tools ${minimum_developerversion} or later, but you have Developer Tools ${developerversion}."
                    return -code error "incompatible Developer Tools"
                }
            }
        }
    }
}

proc developerversion::get_default_developerversion {} {
    global use_xcode xcodeversion xcodecltversion
    if {${use_xcode}} {
        return ${xcodeversion}
    } else {
        return ${xcodecltversion}
    }
}
