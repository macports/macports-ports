# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup defines standard settings when using Qt 6.
#
# Usage:
# PortGroup     qt6 1.0

PortGroup       qt6_info 1.0

# method used to find Qt 6 libraries
# possible values:
#     qt_dirs:        set the Q{...}_DIR environment variables
#     toolchain_file: set the CMAKE_TOOLCHAIN_FILE environment variable
#     module_path:    use cmake.module_path from cmake PG
#     qt-cmake:       attempt to use the Qt version of cmake
#     none:           do not attempt to find Qt (useful for variants)
options         qt6.find_method
default         qt6.find_method     {qt_dirs}

# options for declaring dependencies on Qt6 components, which will expand them
# into the appropriate subports for the Qt6 flavor installed
foreach phase {build lib run test} {
    options     qt6.depends_${phase}
}
default         qt6.depends_build   {}
default         qt6.depends_lib     {[expr {"qtbase" in [option qt6.depends_build] ? "" : "qtbase"}]}
option_proc     qt6.depends_lib     qt6::depends_lib_trace ; # qtbase is always part of qt6.depends_lib unless qtbase is in qt6.depends_build
default         qt6.depends_run     {}
default         qt6.depends_test    {}

####################################################################################################################################
# utility procedures
####################################################################################################################################
proc qt6::depends_lib_trace {opt action args} {
    if {${action} ne "set"} {
        return
    }
    if { "qtbase" ni [option qt6.depends_build] } {
        ${opt}-delete                       qtbase
        ${opt}-prepend                      qtbase
    }
}

proc qt6::callback {} {
    if { [option qt6.find_method] eq "none" } {
        # do nothing
        return
    }

    if { [option qt6.base] eq "" } {
        # no valid Qt version can be found
        known_fail                          yes
        pre-fetch {
            ui_error                        "All Qt 6 versions are either blacklisted or are known not to work on this system configuration"
            return -code error              "No version of Qt 6 is available"
        }
        return
    }

    if { [option supported_archs] eq "" } {
        supported_archs                     arm64 x86_64
    } else {
        supported_archs-delete              i386 ppc ppc64
    }

    foreach phase {build lib run test} {
        foreach module [option qt6.depends_${phase}] {

            if {[vercmp [option qt6.version] < [lindex $qt6::components(${module}) 0]] || [vercmp [lindex $qt6::components(${module}) 1] < [option qt6.version]]} {
                known_fail                  yes
                pre-fetch "
                    ui_error                \"Module ${module} does not exist in Qt version [option qt6.version]\"
                    return -code error      {Module is unavailable}
                "

                # do not add dependency on a non-existent port
                continue
            }

            depends_${phase}-delete         path:[lindex $qt6::components(${module}) 2]:[option qt6.base]-${module}
            depends_${phase}-append         path:[lindex $qt6::components(${module}) 2]:[option qt6.base]-${module}
        }
    }

    # find Qt6 libraries
    # Qt 6's cmake files are not linked to ${prefix}/lib/cmake since they use _IMPORT_PREFIX
    switch -exact [option qt6.find_method] {
        qt_dirs {
            configure.env-append            QT_DIR=[option qt6.dir]
            foreach module {"" CoreTools GuiTools} {
                configure.env-append        Qt6${module}_DIR=[option qt6.dir]
            }
        }
        toolchain_file {
            configure.env-append            CMAKE_TOOLCHAIN_FILE=[option qt6.dir]/lib/cmake/Qt6/qt.toolchain.cmake
        }
        module_path {
            global cmake.module_path
            if { [info exists cmake.module_path] } {
                cmake.module_path-append    [option qt6.dir]/lib/cmake
            } else {
                ui_warn                     "[option qt6.find_method] as qt6.find_method only work if cmake PG is used"
            }
        }
        qt-cmake {
            configure.cmd-replace           [option prefix]/bin/cmake \
                                            [option qt6.dir]/bin/qt-cmake
        }
        none {
            # do nothing
        }
        default {
            return -code error              "unknown value for qt6.find_method: [option qt6.find_method]"
        }
    }
}
port::register_callback                     qt6::callback
