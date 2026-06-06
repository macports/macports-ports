# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup allows building with a specific version of ffmpeg.
#
# Usage:
#
#   PortGroup               ffmpeg 1.0
#   ffmpeg.version          version

namespace eval ffmpeg { }

options ffmpeg.version
default ffmpeg.version 8

options ffmpeg.prefix
default ffmpeg.prefix {${prefix}/libexec/ffmpeg${ffmpeg.version}}

proc ffmpeg::set_vars {action} {
    global cmake.prefix_path ffmpeg._version ffmpeg.prefix prefix

    ffmpeg.prefix               ${prefix}/libexec/ffmpeg${ffmpeg._version}

    depends_lib-${action}       port:ffmpeg${ffmpeg._version}
    configure.pkg_config_path-${action} \
                                ${ffmpeg.prefix}/lib/pkgconfig
    configure.cppflags-${action} \
                                -I${ffmpeg.prefix}/include
    configure.ldflags-${action} \
                                -L${ffmpeg.prefix}/lib
    if {[info exists cmake.prefix_path]} {
        cmake.prefix_path-${action} \
                                ${ffmpeg.prefix}
    }
}

proc ffmpeg::configure_build {} {
    global ffmpeg._version
    if {${ffmpeg._version} eq ""} return
    ffmpeg::set_vars        delete
    set ffmpeg._version     [option ffmpeg.version]
    ffmpeg::set_vars        prepend
}

proc ffmpeg::version_proc {option action args} {
    global ffmpeg._version
    if {${action} ne "set"} return
    if {${ffmpeg._version} eq ""} {
        set ffmpeg._version [option ffmpeg.version]
    }
    ffmpeg::configure_build
}

global ffmpeg._version
set ffmpeg._version ""
port::register_callback ffmpeg::configure_build
option_proc ffmpeg.version ffmpeg::version_proc
