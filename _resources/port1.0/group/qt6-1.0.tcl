# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup defines standard settings when using Qt 6.
#
# Usage:
# PortGroup     qt6 1.0

global available_qt_versions
array set available_qt_versions {
    qt6 {qt6-qtbase 6.2}
}

# Qt has what is calls reference configurations, which are said to be thoroughly tested
# Qt also has configurations which are "occasionally tested" or are "[d]eployment only"
# see https://doc.qt.io/qt-6/supported-platforms.html#reference-configurations
# see https://doc.qt.io/qt-6/supported-platforms-and-configurations.html

proc qt6.get_default_name {} {
    global os.major

    # see https://doc.qt.io/qt-6/supported-platforms-and-configurations.html
    # for older versions, see https://web.archive.org/web/*/http://doc.qt.io/qt-6/supported-platforms-and-configurations.html
    #
    # macOS Mojave (10.14) and later
    #
    # # Qt 6.0 - 6.2: Supported
    #
    return qt6
}

global qt6.name qt6.base_port qt6.version

# get the latest Qt version that runs on current OS configuration
set qt6.name        [qt6.get_default_name]
set qt6.base_port   [lindex $available_qt_versions(${qt6.name}) 0]
set qt6.version     [lindex $available_qt_versions(${qt6.name}) 1]

# check if another version of Qt is installed
foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {![catch {set installed [lindex [registry_active ${qt_test_base_port}] 0]}]} {
        set qt6.name        ${qt_test_name}
        set qt6.base_port   ${qt_test_base_port}
        set qt6.version     [lindex $installed 1]
    }
}

if {[info exists name]} {
    # check to see if this is a Qt port being built
    foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
        if {${qt_test_name} eq ${name}} {
            set qt6.name       ${name}
            set qt6.base_port  [lindex $available_qt_versions(${qt6.name}) 0]
            set qt6.version    [lindex $available_qt_versions(${qt6.name}) 1]
        }
    }
}

if {[info exists qt6.custom_qt_name]} {
    set qt6.name        ${qt6.custom_qt_name}
    set qt6.base_port   [lindex $custom_qt_versions(${qt6.name}) 0]
    set qt6.version     [lindex $custom_qt_versions(${qt6.name}) 1]
}

if {[tbool just_want_qt6_version_info]} {
    return
}

# standard install directory
global qt_dir
set qt_dir              ${prefix}/libexec/qt6
if {[info exists qt6.custom_qt_name]} {
    set qt_dir          ${prefix}/libexec/${qt6.custom_qt_name}
}

# standard Qt non-.app executables directory
global qt_bins_dir
set qt_bins_dir         ${qt_dir}/bin

# standard Qt includes directory
global qt_includes_dir
set qt_includes_dir     ${qt_dir}/include

# standard Qt libraries directory
global qt_libs_dir
set qt_libs_dir         ${qt_dir}/lib

# standard Qt frameworks directory
global qt_frameworks_dir
set qt_frameworks_dir   ${qt_libs_dir}

global qt_archdata_dir
set qt_archdata_dir     ${qt_dir}

# standard Qt plugins directory
global qt_plugins_dir
set qt_plugins_dir      ${qt_archdata_dir}/plugins

# standard Qt imports directory
global qt_imports_dir
set qt_imports_dir      ${qt_archdata_dir}/imports

# standard Qt qml directory
global qt_qml_dir
set qt_qml_dir          ${qt_archdata_dir}/qml

# standard Qt data directory
global qt_data_dir
set qt_data_dir         ${qt_dir}

# standard Qt documents directory
global qt_docs_dir
set qt_docs_dir         ${qt_data_dir}/doc

# standard Qt translations directory
global qt_translations_dir
set qt_translations_dir ${qt_data_dir}/translations

# standard Qt sysconf directory
global qt_sysconf_dir
set qt_sysconf_dir      ${qt_dir}/etc/xdg

# standard Qt examples directory
global qt_examples_dir
set qt_examples_dir     ${qt_dir}/examples

# standard Qt tests directory
global qt_tests_dir
set qt_tests_dir        ${qt_dir}/tests

# data used by qmake
global qt_host_data_dir
set qt_host_data_dir    ${qt_dir}

# standard Qt mkspecs directory
global qt_mkspecs_dir
set qt_mkspecs_dir      ${qt_dir}/mkspecs

# standard Qt .app executables directory, if created
global qt_apps_dir
set qt_apps_dir         ${applications_dir}/Qt6

# standard CMake module directory for Qt-related files
global qt_cmake_module_dir
set qt_cmake_module_dir ${qt_libs_dir}/cmake

# standard qt-cmake command location
global qt_cmake_cmd
set qt_cmake_cmd        ${qt_dir}/bin/qt-cmake

# standard qt-configure-module command location
global qt_configure_module_cmd
set qt_configure_module_cmd ${qt_dir}/bin/qt-configure-module

# standard qmake command location
global qt_qmake_cmd
set qt_qmake_cmd        ${qt_dir}/bin/qmake

# standard moc command location
global qt_moc_cmd
set qt_moc_cmd          ${qt_dir}/moc

# standard uic command location
global qt_uic_cmd
set qt_uic_cmd          ${qt_dir}/uic

namespace eval qt6pg {
    ###############################################################################
    # Component Format
    #
    # "Qt Component Name" {
    #     Qt version introduced
    #     Qt version removed
    #     file installed by component
    #     blank if module; "-plugin" if plugin
    # }
    #
    # module info found at https://doc.qt.io/qt-6/qtmodules.html
    #
    ###############################################################################
    array set qt6_component_lib {
        qtbase {
            6.2
            7.0
            lib/pkgconfig/Qt6Core.pc
            ""
        }
        sqlite-plugin {
            6.2
            7.0
            lib/cmake/Qt6Sql/Qt6Sql_QSQLiteDriverPlugin.cmake
            "-plugin"
        }
        psql-plugin {
            6.2
            7.0
            lib/cmake/Qt6Sql/Qt6Sql_QPSQLDriverPlugin.cmake
            "-plugin"
        }
        mysql-plugin {
            6.2
            7.0
            lib/cmake/Qt6Sql/Qt6Sql_QMYSQLDriverPlugin.cmake
            "-plugin"
        }
    }
}

if {[tbool just_want_qt6_variables]} {
    return
}

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
                if {[vercmp ${qt6.version} ${version_intro}] >= 0} {
                    depends_lib-append path:${path}:${qt6.name}-${component}
                } else {
                    if {[vercmp ${qt6.version} ${qt6.min_version}] >= 0} {
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
                if {[vercmp ${qt6.version} ${version_intro}] >= 0} {
                    depends_build-append path:${path}:${qt6.name}-${component}
                } else {
                    if {[vercmp ${qt6.version} ${qt6.min_version}] >= 0} {
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
                if {[vercmp ${qt6.version} ${version_intro}] >= 0} {
                    depends_run-append path:${path}:${qt6.name}-${component}
                } else {
                    if {[vercmp ${qt6.version} ${qt6.min_version}] >= 0} {
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
    if {[vercmp ${qt6.version} ${qt6.min_version}] < 0} {
        known_fail yes
        pre-fetch {
            ui_error "Qt version ${qt6.min_version} or above is required, but Qt version ${qt6.version} is installed"
            return -code error "Qt version too old"
        }
    }
}
port::register_callback qt6pg::check_min_version

unset private_building_qt6
