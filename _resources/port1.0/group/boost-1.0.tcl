# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     boost 1.0
#
# This port group handles setting ports up to build against specific boost versions

namespace eval boost { }

options boost.version
default boost.version 1.71

options boost.depends_type
default boost.depends_type lib

proc boost::version {} {
    return [option boost.version]
}

proc boost::version_nodot {} {
    return [string map {. {}} [boost::version]]
}

proc boost::install_area {} {
    global prefix
    return ${prefix}/libexec/boost[boost::version_nodot]
}

proc boost::include_dir {} {
    return [boost::install_area]/include
}

proc boost::lib_dir {} {
    return [boost::install_area]/lib
}

proc boost::configure {} {
    global cmake.build_dir

    # Set the requested boost dependency
    depends_[option boost.depends_type]-append port:boost[boost::version_nodot]

    # Append to the build flags to find the isolated headers/libs
    configure.cxxflags-prepend -isystem[boost::include_dir]
    configure.ldflags-prepend  -L[boost::lib_dir]

    # are we using cmake ?
    if { [info exists cmake.build_dir] } {
        ui_debug "Detected Cmake PG in use"
        configure.args-append -DBoost_INCLUDE_DIR=[boost::include_dir] \
                              -DBoost_DIR=[boost::install_area]
    }

}
port::register_callback boost::configure
