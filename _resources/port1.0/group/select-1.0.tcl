# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2009 Rainer Mueller <raimue@macports.org>
# Copyright (c) 2009-2012, 2015-2017 The MacPorts Project
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
# 3. Neither the name of Apple Computer, Inc. nor the names of its
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
# This portgroup provides access to the port selection mechanism exposed
# by the `port select` command. (Refer to the port(1) and port-select(1)
# man pages for end-user information).

options select.group select.file select.entries

default select.group {}
default select.file {}
default select.entries {}

namespace eval select {}

proc select::install {group file {name ""}} {
    global applications_dir destroot developer_dir filespath \
            frameworks_dir prefix

    if {[file pathtype $file] eq "relative"} {
        set file ${filespath}/$file
    }

    # Optional argument specifies file name
    if {$name eq ""} {
        set name [file tail $file]
    }

    set selectFile ${destroot}${prefix}/etc/select/$group/$name

    xinstall -m 755 -d [file dirname $selectFile]
    xinstall -m 644 $file $selectFile

    reinplace -q s|\${prefix}|${prefix}|g $selectFile
    reinplace -q s|\${frameworks_dir}|${frameworks_dir}|g $selectFile
    reinplace -q s|\${applications_dir}|${applications_dir}|g $selectFile
    reinplace -q s|\${developer_dir}|${developer_dir}|g $selectFile
}

post-destroot {
    if {${select.file} ne "" || ${select.group} ne ""} {
        select.entries-prepend [list ${select.group} ${select.file}]
    }
    ui_debug {PortGroup select: Installing select files to destroot}
    foreach selectEntry ${select.entries} {
        set extras [lassign $selectEntry selectGroup selectFile selectName]
        if {[llength $extras] > 0} {
            ui_debug "PortGroup select:\
                    Ignoring entry with too many elements: '$selectEntry'"
            continue
        }
        if {$selectGroup eq ""} {
            ui_debug "PortGroup select:\
                    Ignoring entry with missing group name: '$selectEntry'"
            continue
        }
        if {$selectFile eq ""} {
            ui_debug "PortGroup select:\
                    Ignoring entry with missing file name: '$selectEntry'"
            continue
        }
        select::install $selectGroup $selectFile $selectName
    }
}
