# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup defines standard settings when using Qt 6.
#
# Usage:
# PortGroup     qt6 1.0

PortGroup qt6_variables 1.0

# a procedure for declaring dependencies on Qt6 components, which will
# expand them into the appropriate subports for the Qt6 flavour installed
# (e.g., qt6.depends_component qtsvg qtdeclarative)
proc qt6.depends_component {args} {
    global qt6_private_components
    foreach comp ${args} {
        lappend qt6_private_components ${comp}
    }
}
proc qt6.depends_build_component {args} {
    global qt6_private_build_components
    foreach comp ${args} {
        lappend qt6_private_build_components ${comp}
    }
}
proc qt6.depends_runtime_component {args} {
    global qt6_private_runtime_components
    foreach comp ${args} {
        lappend qt6_private_runtime_components ${comp}
    }
}

options qt6.min_version
default qt6.min_version 6.2

# use PKGCONFIG for Qt discovery in configure scripts
depends_build-delete    port:pkgconfig
depends_build-append    port:pkgconfig

# standard qmake spec
# other platforms required
#     see http://doc.qt.io/qt-6/supported-platforms.html
#     and http://doc.qt.io/QtSupportedPlatforms/index.html
options qt_qmake_spec
global qt_qmake_spec_32
global qt_qmake_spec_64
compiler.blacklist-append *gcc*

# no PPC support in Qt 6
default supported_archs "x86_64 arm64"

set qt_qmake_spec_32 macx-clang
set qt_qmake_spec_64 macx-clang

destroot.env-append INSTALL_ROOT=${destroot}

default qt_qmake_spec {[qt6pg::get_default_spec]}

namespace eval qt6pg {
    proc get_default_spec {} {
        global configure.build_arch qt_qmake_spec_32 qt_qmake_spec_64
        return ${qt_qmake_spec_64}

    }
}

set private_building_qt6 false
# check to see if this is a Qt base port being built
foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {${qt_test_base_port} eq ${subport}} {
        set private_building_qt6 true
    }
}
foreach {qt_test_name qt_test_info} [array get custom_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {${qt_test_base_port} eq ${subport}} {
        set private_building_qt6 true
    }
}

if {!${private_building_qt6}} {
    pre-configure {
        ui_debug "qt6 PortGroup: Qt is provided by ${qt6.name}"

        if { ![info exists qt6.custom_qt_name] } {
            if { ${qt6.name} ne [qt6.get_default_name] } {
                # see https://wiki.qt.io/Qt-Version-Compatibility
                ui_warn "qt6 PortGroup: default Qt for this platform is [qt6.get_default_name] but ${qt6.name} is installed"
            }
            if { ${qt6.name} ne "qt6" } {
                ui_warn "Qt dependency is not the latest version but may be the latest supported on your OS"
            }
            if { ${os.major} < 11 } {
                ui_warn "Qt dependency is not supported on this platform and may not build"
            }
        }
    }
}

namespace eval qt6pg {
    proc register_dependents {} {
        global qt6_private_components qt6_private_build_components qt6_private_runtime_components qt6.name qt6.version qt6.min_version

        if { ![exists qt6_private_components] } {
            # no Qt components have been requested
            # qt6.depends_component has never been called
            set qt6_private_components ""
        }
        if { ![exists qt6_private_build_components] } {
            # qt6.depends_build_component has never been called
            set qt6_private_build_components ""
        }
        if { ![exists qt6_private_runtime_components] } {
            # qt6.depends_build_component has never been called
            set qt6_private_runtime_components ""
        }
        foreach component "qtbase ${qt6_private_components}" {
            if { ${component} eq "qt6" } {
                depends_lib-append path:share/doc/qt6/README.txt:${qt6.name}
            } elseif { [info exists qt6pg::qt6_component_lib(${component})] } {
                set component_info $qt6pg::qt6_component_lib(${component})
                set path           [lindex ${component_info} 2]
                set version_intro  [lindex ${component_info} 0]
                if {[vercmp ${qt6.version} >= ${version_intro}]} {
                    depends_lib-append path:${path}:${qt6.name}-${component}
                } else {
                    if {[vercmp ${qt6.version} >= ${qt6.min_version}]} {
                        ui_warn "${component} does not exist in Qt ${qt6.version}"
                    } else {
                        # port will fail during pre-fetch
                    }
                }
            } else {
                return -code error "unknown component ${component}"
            }
        }
        foreach component ${qt6_private_build_components} {
            if { [info exists qt6pg::qt6_component_lib(${component})] } {
                set component_info $qt6pg::qt6_component_lib(${component})
                set path           [lindex ${component_info} 2]
                set version_intro  [lindex ${component_info} 0]
                if {[vercmp ${qt6.version} >= ${version_intro}]} {
                    depends_build-append path:${path}:${qt6.name}-${component}
                } else {
                    if {[vercmp ${qt6.version} >= ${qt6.min_version}]} {
                        ui_warn "${component} does not exist in Qt ${qt6.version}"
                    } else {
                        # port will fail during pre-fetch
                    }
                }
            } else {
                return -code error "unknown component ${component}"
            }
        }
        foreach component ${qt6_private_runtime_components} {
            if { [info exists qt6pg::qt6_component_lib(${component})] } {
                set component_info $qt6pg::qt6_component_lib(${component})
                set path           [lindex ${component_info} 2]
                set version_intro  [lindex ${component_info} 0]
                if {[vercmp ${qt6.version} >= ${version_intro}]} {
                    depends_run-append path:${path}:${qt6.name}-${component}
                } else {
                    if {[vercmp ${qt6.version} >= ${qt6.min_version}]} {
                        ui_warn "${component} does not exist in Qt ${qt6.version}"
                    } else {
                        # port will fail during pre-fetch
                    }
                }
            } else {
                return -code error "unknown component ${component}"
            }
        }
    }
}

if {!${private_building_qt6}} {
    port::register_callback qt6pg::register_dependents
}

proc qt6pg::check_min_version {} {
    global qt6.version qt6.min_version
    if {[vercmp ${qt6.version} < ${qt6.min_version}]} {
        known_fail yes
        pre-fetch {
            ui_error "Qt version ${qt6.min_version} or above is required, but Qt version ${qt6.version} is installed"
            return -code error "Qt version too old"
        }
    }
}
port::register_callback qt6pg::check_min_version

unset private_building_qt6

# If using Portgroup cmake + qt6 it means configure.cmd is set to cmake (for example by use of cmake porgroup),
# So that qt6 finds itself correctly, we use the helper script 'qt-cmake' provided by Qt
# This will permit configuration step to succeed & find the Qt6 modules
if { [string equal ${configure.cmd} "${prefix}/bin/cmake"] } {
    configure.cmd   ${qt_bins_dir}/qt-cmake
}

# Qt6 makes uses of rpath. This is managed correctly when building with qmake, but with cmake
# we have to set -DCMAKE_INSTALL_RPATH=${qt_libs_dir}
# Actually the cmake portgroup sets CMAKE_INSTALL_RPATH to a value that doesn't fit for Qt6
# This will result in a correct LC_RPATH in the binaries
if { [string equal ${configure.cmd} "${qt_bins_dir}/qt-cmake"] } {
    configure.args-append   -DCMAKE_INSTALL_RPATH=${qt_libs_dir}
}
