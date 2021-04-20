# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup lets a port check that the user's Xcode is sufficiently new.
#
# Usage:
#
#   PortGroup               xcodeversion 1.0
#   minimum_xcodeversions   {darwin_major minimum_xcodeversion}
#
# where darwin_major is the major version of the underlying Darwin OS (e.g. 16
# for macOS 10.12 Sierra) and minimum_xcodeversion is the minimum version
# of Xcode the port requires (e.g. 3.1).

options minimum_xcodeversions
default minimum_xcodeversions {}

proc xcodeversions_get_minimum { } {
    global minimum_xcodeversions os.major
    foreach {darwin_major minimum_xcodeversion} [join ${minimum_xcodeversions}] {
        if {${darwin_major} == ${os.major}} {
            return ${minimum_xcodeversion}
        }
    }
    return "none"
}

proc xcodeversions_run_check { } {
    global os.major xcodeversion
    platform macosx {
        set minimum_xcodeversion [xcodeversions_get_minimum]
        if { $minimum_xcodeversion ne "none" } {
            if {![info exists xcodeversion] || $xcodeversion eq "none"} {
                pre-extract {
                    ui_error "Could not determine your Xcode version (from '/usr/bin/xcodebuild -version')."
                    ui_error ""
                    ui_error "On macOS ${macosx_version}, ${name} @${version} requires Xcode [xcodeversions_get_minimum] or later but you have none installed."
                    ui_error "See https://guide.macports.org/chunked/installing.xcode.html for download links."
                    ui_error ""
                    return -code error "unable to find Xcode"
                }
            }
            if {[vercmp ${xcodeversion} ${minimum_xcodeversion}] < 0} {
                known_fail yes
                pre-extract {
                    ui_error "On macOS ${macosx_version}, ${name} @${version} requires Xcode [xcodeversions_get_minimum] or later but you have Xcode ${xcodeversion}."
                    ui_error "See https://guide.macports.org/chunked/installing.xcode.html for download links."
                    return -code error "incompatible Xcode version"
                }
            }
        }
    }
}
port::register_callback xcodeversions_run_check
