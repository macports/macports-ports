# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
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

    xinstall -m 0755 -d [file dirname $selectFile]
    xinstall -m 0644 $file $selectFile

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
