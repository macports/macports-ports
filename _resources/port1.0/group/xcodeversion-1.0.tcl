# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2009-2013, 2016 The MacPorts Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of The MacPorts Project nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
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
        foreach {darwin_major minimum_xcodeversion} [join ${minimum_xcodeversions}] {
            if {${darwin_major} == ${os.major}} {
                if {![info exists xcodeversion] || $xcodeversion == "none"} {
                    ui_error "Couldn't determine your Xcode version (from '/usr/bin/xcodebuild -version')."
                    ui_error ""
                    ui_error "If you have not installed Xcode, install it now; see:"
                    ui_error "https://guide.macports.org/chunked/installing.xcode.html"
                    ui_error ""
                    return -code error "unable to find Xcode"
                }
                if {[vercmp ${xcodeversion} ${minimum_xcodeversion}] < 0} {
                    ui_error "On macOS ${macosx_version}, ${name} @${version} requires Xcode ${minimum_xcodeversion} or later but you have Xcode ${xcodeversion}."
                    ui_error "See https://guide.macports.org/chunked/installing.xcode.html for download links."
                    return -code error "incompatible Xcode version"
                }
            }
        }
    }
}
