# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     boost 1.0
#
# This port group handles setting ports up to build against specific boost versions

namespace eval boost { }

options boost.version
default boost.version 1.76

options boost.depends_type
default boost.depends_type lib

set boost_last_version_nodot ""
set boost_last_depends       ""
set boost_last_cxxflags      ""
set boost_last_ldflags       ""
set boost_last_cmake_flags   ""
set boost_last_cmake         0

proc boost::version {} {
    return [option boost.version]
}

proc boost::version_nodot {} {
    return [string map {. {}} [boost::version]]
}

proc boost::install_area {} {
    global prefix
    return ${prefix}/libexec/boost/boost[boost::version_nodot]
}

proc boost::include_dir {} {
    return [boost::install_area]/include
}

proc boost::lib_dir {} {
    return [boost::install_area]/lib
}

proc boost::configure_build {} {
    global cmake.build_dir
    global boost_last_version_nodot boost_last_depends boost_last_cxxflags
    global boost_last_ldflags boost_last_cmake_flags boost_last_cmake

    if { ${boost_last_version_nodot} eq [boost::version_nodot] &&
         ${boost_last_depends} eq [option boost.depends_type] &&
         ${boost_last_cmake} eq [info exists cmake.build_dir] } return

    ui_debug "Configure build [boost::version]"

    # Set the requested boost dependency
    if { ${boost_last_version_nodot} ne "" && ${boost_last_depends} ne "" } {
        depends_${boost_last_depends}-delete port:boost${boost_last_version_nodot} 
    }
    set boost_last_depends       [option boost.depends_type]
    set boost_last_version_nodot [boost::version_nodot]
    depends_[option boost.depends_type]-append port:boost[boost::version_nodot]

    # Append to the build flags to find the isolated headers/libs
    if { ${boost_last_cxxflags} ne "" } {
        configure.cxxflags-delete ${boost_last_cxxflags}
    }
    if { ${boost_last_ldflags} ne "" } {
        configure.ldflags-delete ${boost_last_ldflags}
    }
    set boost_last_cxxflags -isystem[boost::include_dir]
    set boost_last_ldflags  -L[boost::lib_dir]
    configure.cxxflags-prepend ${boost_last_cxxflags}
    configure.ldflags-prepend  ${boost_last_ldflags}

    # are we using cmake ?
    if { [info exists cmake.build_dir] } {
        ui_debug "Detected Cmake PG in use"
        set boost_last_cmake 1
        if { ${boost_last_cmake_flags} ne "" } {
            foreach flag ${boost_last_cmake_flags} {
                configure.args-delete ${flag}
            }
        }
        set boost_last_cmake_flags [list -DBoost_INCLUDE_DIR=[boost::include_dir] -DBoost_DIR=[boost::install_area]]
        foreach flag ${boost_last_cmake_flags} {
            configure.args-append ${flag}
        }
    }

}

port::register_callback boost::configure_build

boost::configure_build

proc boost::set_boost_parameters {option action args} {
    if {$action ne  "set"} return
    boost::configure_build
}
option_proc boost.version      boost::set_boost_parameters
option_proc boost.depends_type boost::set_boost_parameters
