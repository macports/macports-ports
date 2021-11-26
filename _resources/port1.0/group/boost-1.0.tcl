# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     boost 1.0
#
# This port group handles setting ports up to build against specific boost versions

namespace eval boost { }

options boost.version
default boost.version {[boost::default_version]}

options boost.depends_type
default boost.depends_type lib

options boost.require_numpy
default boost.require_numpy no

# cache variables storing current configuration state
default boost_cache_version_nodot ""
default boost_cache_depends       ""
default boost_cache_cpath         ""
default boost_cache_cppflags      ""
default boost_cache_cxxflags      ""
default boost_cache_ldflags       ""
default boost_cache_cmake_flags   ""
default boost_cache_env_vars      ""

proc boost::default_version {} {
    global os.platform os.major
    # Pin version on Darwin9 and older to pre-c++11 version (1.71)
    if { ${os.platform} eq "darwin" && ${os.major} <= 9 } {
        return 1.71
    } else {
        return 1.76
    }
}

proc boost::version {} {
    return [option boost.version]
}

proc boost::version_nodot {} {
    return [string map {. {}} [boost::version]]
}

proc boost::install_area {} {
    global prefix
    return ${prefix}/libexec/boost/[boost::version]
}

proc boost::include_dir {} {
    return [boost::install_area]/include
}

proc boost::lib_dir {} {
    return [boost::install_area]/lib
}

proc boost::depends_portname {} {
    return boost[boost::version_nodot]
}

proc boost::cxx_flags {} {
    return -I[boost::include_dir]
}

proc boost::ld_flags {} {
    return -L[boost::lib_dir]
}

proc boost::cpp_flags {} {
    return -I[boost::include_dir]
}

proc boost::configure_build {} {
    global cmake.build_dir meson.build_type
    global boost_cache_version_nodot boost_cache_depends boost_cache_cxxflags
    global boost_cache_ldflags boost_cache_cmake_flags boost_cache_cmake
    global boost_cache_env_vars boost_cache_cpath boost_cache_cppflags

    ui_debug "boost PG: Configure build for boost [boost::version]"

    # Set the requested boost dependency
    if { ${boost_cache_version_nodot} ne "" && ${boost_cache_depends} ne "" } {
        depends_${boost_cache_depends}-delete port:boost${boost_cache_version_nodot}
        if { [option boost.require_numpy] } {
            depends_${boost_cache_depends}-delete port:boost${boost_cache_version_nodot}-numpy
        }
    }
    set boost_cache_depends       [option boost.depends_type]
    set boost_cache_version_nodot [boost::version_nodot]
    depends_[option boost.depends_type]-append port:boost[boost::version_nodot]
    if { [option boost.require_numpy] } {
        depends_[option boost.depends_type]-append port:boost[boost::version_nodot]-numpy
    }

    # Append to the build flags to find the isolated headers/libs
    if { ${boost_cache_cppflags} ne "" } {
        configure.cppflags-delete ${boost_cache_cppflags}
    }
    if { ${boost_cache_cxxflags} ne "" } {
        configure.cxxflags-delete ${boost_cache_cxxflags}
    }
    if { ${boost_cache_ldflags} ne "" } {
        configure.ldflags-delete ${boost_cache_ldflags}
    }
    set boost_cache_cppflags [boost::cpp_flags]
    set boost_cache_cxxflags [boost::cxx_flags]
    set boost_cache_ldflags  [boost::ld_flags]
    configure.cppflags-prepend ${boost_cache_cppflags}
    configure.cxxflags-prepend ${boost_cache_cxxflags}
    configure.ldflags-prepend  ${boost_cache_ldflags}

    # Some build systems (meson,makefile) need configure/build env vars to be set.
    # Do this unconditionally, as setting env vars shouldn't harm builds
    # that do not use them.
    if { ${boost_cache_env_vars} ne "" } {
        foreach var ${boost_cache_env_vars} {
            foreach phase {configure build} {
                ${phase}.env-delete ${var}
            }
        }
    }
    set boost_cache_env_vars [list \
                                  BOOSTDIR=[boost::install_area] \
                                  BOOST_DIR=[boost::install_area] \
                                  BOOSTROOT=[boost::install_area] \
                                  BOOST_ROOT=[boost::install_area] \
                                  BOOST_LIBRARYDIR=[boost::lib_dir] \
                                  BOOST_INCLUDEDIR=[boost::include_dir] \
                                 ]
    foreach var ${boost_cache_env_vars} {
        foreach phase {configure build destroot} {
            ${phase}.env-append ${var}
        }
    }

    # Add to compiler.cpath. Helps with e.g. meson builds. See discussion at
    # https://github.com/macports/macports-ports/commit/f55147262b22ec1f81831cd58295bd0bdfc25f01
    if { ${boost_cache_cpath} ne "" } {
        compiler.cpath-delete ${boost_cache_cpath}
    }
    set boost_cache_cpath [boost::include_dir]
    compiler.cpath-prepend ${boost_cache_cpath}

    # Are we using cmake ?
    # As we are appending to configure flags, need to check if cmake is in use
    # before appending the cmake specific flags
    if { [string match *cmake* [option configure.cmd] ] } {
        if { ${boost_cache_cmake_flags} ne "" } {
            foreach flag ${boost_cache_cmake_flags} {
                configure.args-delete ${flag}
            }
        }
        # Try and cover all bases here and set all possible variables ...
        # See https://cmake.org/cmake/help/latest/module/FindBoost.html
        set boost_cache_cmake_flags [list \
                                        -DBOOST_ROOT=[boost::install_area] \
                                        -DBOOSTROOT=[boost::install_area] \
                                        -DBOOST_INCLUDEDIR=[boost::include_dir] \
                                        -DBOOST_LIBRARYDIR=[boost::lib_dir] \
                                        -DBOOST_INCLUDE_DIR=[boost::include_dir] \
                                        -DBOOST_LIBRARY_DIR=[boost::lib_dir] \
                                        -DBOOST_LIB_DIR=[boost::lib_dir] \
                                        -DBoost_NO_SYSTEM_PATHS=ON \
                                        -DBoost_INCLUDE_DIR=[boost::include_dir] \
                                        -DBoost_DIR=[boost::install_area] \
                                       ]
        foreach flag ${boost_cache_cmake_flags} {
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
option_proc boost.version       boost::set_boost_parameters
option_proc boost.depends_type  boost::set_boost_parameters
option_proc boost.require_numpy boost::set_boost_parameters
