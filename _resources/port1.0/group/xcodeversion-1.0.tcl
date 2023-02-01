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

platform macosx {
    pre-extract {
        foreach {darwin_major minimum_xcodeversion} [concat {*}${minimum_xcodeversions}] {
            if {${darwin_major} == ${os.major}} {
                if {![info exists xcodeversion] || $xcodeversion eq "none"} {
                    ui_error "Couldn't determine your Xcode version (from '/usr/bin/xcodebuild -version')."
                    ui_error ""
                    ui_error "On macOS ${macos_version_major}, ${name} @${version} requires Xcode ${minimum_xcodeversion} or later but you have none installed."
                    ui_error "See https://guide.macports.org/chunked/installing.xcode.html for download links."
                    ui_error ""
                    return -code error "unable to find Xcode"
                } elseif {[vercmp ${xcodeversion} < ${minimum_xcodeversion}]} {
                    ui_error "On macOS ${macos_version_major}, ${name} @${version} requires Xcode ${minimum_xcodeversion} or later but you have Xcode ${xcodeversion}."
                    ui_error "See https://guide.macports.org/chunked/installing.xcode.html for download links."
                    return -code error "incompatible Xcode version"
                }
            }
        }
    }
}
