# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2014-2017 The MacPorts Project
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
# This portgroup defines standard settings when using Qt5.
#
# Usage:
# PortGroup     qt5 1.0

global available_qt_versions
array set available_qt_versions {
    qt5  {qt5-qtbase  5.9}
    qt58 {qt58-qtbase 5.8}
    qt57 {qt57-qtbase 5.7}
    qt56 {qt56-qtbase 5.6}
    qt55 {qt55-qtbase 5.5}
}
#qt5-kde {qt5-kde 5.8}

# Qt has what is calls reference configurations, which are said to be thoroughly tested
# Qt also has configurations which are "occasionally tested" or are "[d]eployment only"
# see https://doc.qt.io/qt-5/supported-platforms.html#reference-configurations
# see https://doc.qt.io/qt-5/supported-platforms-and-configurations.html

proc qt5.get_default_name {} {
    global os.major

    # see https://doc.qt.io/qt-5/supported-platforms-and-configurations.html
    # for older versions, see https://web.archive.org/web/*/http://doc.qt.io/qt-5/supported-platforms-and-configurations.html
    if { ${os.major} <= 7 } {
        #
        # Qt 5 does not support ppc
        # see http://doc.qt.io/qt-5/osx-requirements.html
        #
        return qt55
        #
    } elseif { ${os.major} <= 9 } {
        #
        # Mac OS X Tiger (10.4)
        # Mac OS X Leopard (10.5)
        #
        # never supported by Qt 5
        #
        return qt55
        #
    } elseif { ${os.major} == 10 } {
        #
        # Mac OS X Snow Leopard (10.6)
        #
        #     Qt 5.3: Deployment only
        # Qt 5.0-5.2: Occasionally tested
        #
        return qt55
        #
    } elseif { ${os.major} == 11 } {
        #
        # Mac OS X Lion (10.7)
        #
        # Qt 5.7: Not Supported and is known not to work
        # Qt 5.6: Deployment only but seems to work (except QtWebEngine)
        # Qt 5.5: Occasionally tested
        # Qt 5.4: Supported
        #
        return qt56
        #
    } elseif { ${os.major} == 12 } {
        #
        # OS X Mountain Lion (10.8)
        #
        # Qt 5.8: Not Supported
        # Qt 5.7: Supported (except QtWebEngine)
        # Qt 5.6: Supported
        #
        return qt57
        #
    } elseif { ${os.major} == 13 } {
        #
        # OS X Mavericks (10.9)
        #
        # Qt 5.9: Not Supported
        # Qt 5.8: Supported
        # Qt 5.7: Supported
        # Qt 5.6: Supported
        #
        return qt58
        #
    } elseif { ${os.major} <= 15 } {
        #
        # OS X Yosemite (10.10)
        # OS X El Capitan (10.11)
        #
        # Qt 5.9: Supported
        # Qt 5.8: Supported
        # Qt 5.7: Supported
        # Qt 5.6: Supported
        #
        return qt5
        #
    } elseif { ${os.major} <= 16 } {
        #
        # macOS Sierra (10.12)
        #
        # Qt 5.9: Supported
        # Qt 5.8: Supported
        # Qt 5.7: Not Supported but seems to work
        #
        return qt5
        #
    } elseif { ${os.major} <= 17 } {
        #
        # macOS High Sierra (10.13)
        #
        # Qt 5.9: ???
        #
        return qt5
        #
    } else {
        #
        # macOS ??? (???)
        #
        return qt5
    }
}

global qt5.name qt5.base_port qt5.version

# get the latest Qt version that runs on current OS configuration
set qt5.name       [qt5.get_default_name]
set qt5.base_port  [lindex $available_qt_versions(${qt5.name}) 0]
set qt5.version    [lindex $available_qt_versions(${qt5.name}) 1]

# check if another version of Qt is installed
foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {![catch {set installed [lindex [registry_active ${qt_test_base_port}] 0]}]} {
        set qt5.name       ${qt_test_name}
        set qt5.base_port  ${qt_test_base_port}
        set qt5.version    [lindex $installed 1]
    }
}

if {[info exists name]} {
    # check to see if this is a Qt port being built
    foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
        if {${qt_test_name} eq ${name}} {
            set qt5.name       ${name}
            set qt5.base_port  [lindex $available_qt_versions(${qt5.name}) 0]
            set qt5.version    [lindex $available_qt_versions(${qt5.name}) 1]
        }
    }
}

if {[tbool just_want_qt5_version_info]} {
    return
}

# standard install directory
global qt_dir
set qt_dir               ${prefix}/libexec/qt5

# standard Qt non-.app executables directory
global qt_bins_dir
set qt_bins_dir         ${qt_dir}/bin

# standard Qt includes directory
global qt_includes_dir
set qt_includes_dir     ${qt_dir}/include

# standard Qt libraries directory
global qt_libs_dir
set qt_libs_dir         ${qt_dir}/lib

# standard Qt libraries directory
global qt_frameworks_dir
set qt_frameworks_dir   ${qt_libs_dir}

global qt_archdata_dir
set qt_archdata_dir  ${qt_dir}

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
set qt_apps_dir         ${applications_dir}/Qt5

# standard CMake module directory for Qt-related files
#global qt_cmake_module_dir
set qt_cmake_module_dir ${qt_libs_dir}/cmake

# standard qmake command location
global qt_qmake_cmd
set qt_qmake_cmd        ${qt_dir}/bin/qmake

# standard moc command location
global qt_moc_cmd
set qt_moc_cmd          ${qt_dir}/bin/moc

# standard uic command location
global qt_uic_cmd
set qt_uic_cmd          ${qt_dir}/bin/uic

# standard lrelease command location
global qt_lrelease_cmd
set qt_lrelease_cmd     ${qt_dir}/bin/lrelease

# standard lupdate command location
global qt_lupdate_cmd
set qt_lupdate_cmd     ${qt_dir}/bin/lupdate

# standard PKGCONFIG path
global qt_pkg_config_dir
set qt_pkg_config_dir   ${qt_libs_dir}/pkgconfig

namespace eval qt5pg {
    ############################################################################### Component Format
    #
    # "Qt Component Name" {
    #     Qt version introduced
    #     Qt version removed
    #     file installed by component
    #     blank if module; "-plugin" if plugin
    # }
    #
    # module info found at https://doc.qt.io/qt-5/qtmodules.html
    #
    ###############################################################################
    array set qt5_component_lib {
        qt3d {
            5.5
            6.0
            lib/pkgconfig/Qt53DCore.pc
            ""
        }
        qtbase {
            5.0
            6.0
            lib/pkgconfig/Qt5Core.pc
            ""
        }
        qtcanvas3d {
            5.5
            6.0
            libexec/qt5/qml/QtCanvas3D/libqtcanvas3d.dylib
            ""
        }
        qtcharts {
            5.7
            6.0
            lib/pkgconfig/Qt5Charts.pc
            ""
        }
        qtconnectivity {
            5.2
            6.0
            lib/pkgconfig/Qt5Bluetooth.pc
            ""
        }
        qtdatavis3d {
            5.7
            6.0
            lib/pkgconfig/Qt5DataVisualization.pc
            ""
        }
        qtdeclarative {
            5.0
            6.0
            lib/pkgconfig/Qt5Qml.pc
            ""
        }
        qtdeclarative-render2d {
            5.7
            5.8
            lib/cmake/Qt5Quick/Qt5Quick_ContextPlugin.cmake
            ""
        }
        qtdoc {
            5.0
            6.0
            libexec/qt5/doc/qtdoc.qch
            ""
        }
        qtgamepad {
            5.7
            6.0
            lib/pkgconfig/Qt5Gamepad.pc
            ""
        }
        qtenginio {
            5.3
            5.7
            lib/pkgconfig/Enginio.pc
            ""
        }
        qtgraphicaleffects {
            5.0
            6.0
            libexec/qt5/qml/QtGraphicalEffects/libqtgraphicaleffectsplugin.dylib
            ""
        }
        qtimageformats {
            5.0
            6.0
            lib/cmake/Qt5Gui/Qt5Gui_QTiffPlugin.cmake
            ""
        }
        qtlocation {
            5.2
            6.0
            lib/pkgconfig/Qt5Location.pc
            ""
        }
        qtmacextras {
            5.2
            6.0
            lib/pkgconfig/Qt5MacExtras.pc
            ""
        }
        qtmultimedia {
            5.0
            6.0
            lib/pkgconfig/Qt5Multimedia.pc
            ""
        }
        qtnetworkauth {
            5.8
            6.0
            lib/pkgconfig/Qt5NetworkAuth.pc
            ""
        }
        qtpurchasing {
            5.7
            6.0
            lib/pkgconfig/Qt5Purchasing.pc
            ""
        }
        qtquick1 {
            5.0
            5.6
            lib/pkgconfig/Qt5Declarative.pc
            ""
        }
        qtquickcontrols {
            5.1
            6.0
            libexec/qt5/qml/QtQuick/Controls/libqtquickcontrolsplugin.dylib
            ""
        }
        qtquickcontrols2 {
            5.6
            6.0
            lib/pkgconfig/Qt5QuickControls2.pc
            ""
        }
        qtremoteobjects {
            5.9
            6.0
            lib/pkgconfig/Qt5RemoteObjects.pc
            ""
        }
        qtscript {
            5.0
            6.0
            lib/pkgconfig/Qt5Script.pc
            ""
        }
        qtscxml {
            5.7
            6.0
            lib/pkgconfig/Qt5Scxml.pc
            ""
        }
        qtsensors {
            5.1
            6.0
            lib/pkgconfig/Qt5Sensors.pc
            ""
        }
        qtserialbus {
            5.6
            6.0
            lib/pkgconfig/Qt5SerialBus.pc
            ""
        }
        qtserialport {
            5.1
            6.0
            lib/pkgconfig/Qt5SerialPort.pc
            ""
        }
        qtspeech {
            5.8
            6.0
            lib/pkgconfig/Qt5TextToSpeech.pc
            ""
        }
        qtsvg {
            5.0
            6.0
            lib/pkgconfig/Qt5Svg.pc
            ""
        }
        qttools {
            5.0
            6.0
            lib/pkgconfig/Qt5Designer.pc
            ""
        }
        qttranslations {
            5.0
            6.0
            libexec/qt5/translations/qt_ar.qm
            ""
        }
        qtvirtualkeyboard {
            5.7
            6.0
            lib/cmake/Qt5Gui/Qt5Gui_QVirtualKeyboardPlugin.cmake
            ""
        }
        qtwebchannel {
            5.4
            6.0
            lib/pkgconfig/Qt5WebChannel.pc
            ""
        }
        qtwebengine {
            5.4
            6.0
            lib/pkgconfig/Qt5WebEngine.pc
            ""
        }
        qtwebkit {
            5.0
            6.0
            lib/pkgconfig/Qt5WebKit.pc
            ""
        }
        qtwebkit-examples {
            5.0
            6.0
            libexec/qt5/examples/webkitwidgets/webkitwidgets.pro
            ""
        }
        qtwebsockets {
            5.3
            6.0
            lib/pkgconfig/Qt5WebSockets.pc
            ""
        }
        qtwebview {
            5.6
            6.0
            lib/pkgconfig/Qt5WebView.pc
            ""
        }
        qtxmlpatterns {
            5.0
            6.0
            lib/pkgconfig/Qt5XmlPatterns.pc
            ""
        }
        sqlite-plugin {
            5.0
            6.0
            lib/cmake/Qt5Sql/Qt5Sql_QSQLiteDriverPlugin.cmake
            "-plugin"
        }
        psql-plugin {
            5.0
            6.0
            lib/cmake/Qt5Sql/Qt5Sql_QPSQLDriverPlugin.cmake
            "-plugin"
        }
        mysql-plugin {
            5.0
            6.0
            lib/cmake/Qt5Sql/Qt5Sql_QMYSQLDriverPlugin.cmake
            "-plugin"
        }
    }
    #
    #
    #qtjsbackend {
    #    5.0
    #    5.2
    #    ""
    #}
    #
    # qtwebkit: official support dropped in 5.6.0
    #           as of 5.9, still maintained by community
}

if {[tbool just_want_qt5_variables]} {
    return
}

# a procedure for declaring dependencies on Qt5 components, which will expand them
# into the appropriate subports for the Qt5 flavour installed
# e.g. qt5.depends_component qtsvg qtdeclarative
proc qt5.depends_component {args} {
    global qt5_private_components
    foreach comp ${args} {
        lappend qt5_private_components ${comp}
    }
}
proc qt5.depends_build_component {args} {
    global qt5_private_build_components
    foreach comp ${args} {
        lappend qt5_private_build_components ${comp}
    }
}

options qt5.kde_variant
default qt5.kde_variant no

# use PKGCONFIG for Qt discovery in configure scripts
depends_build-append    port:pkgconfig

# standard qmake spec
# other platforms required
#     see http://doc.qt.io/qt-5/supported-platforms.html
#     and http://doc.qt.io/QtSupportedPlatforms/index.html
options qt_qmake_spec
global qt_qmake_spec_32
global qt_qmake_spec_64
compiler.blacklist-append *gcc*

if {[vercmp ${qt5.version} 5.10]>=0} {
    # see https://bugreports.qt.io/browse/QTBUG-58401
    default supported_archs {"x86_64"}
} else {
    # no PPC support in Qt 5
    #     see http://lists.qt-project.org/pipermail/interest/2012-December/005038.html
    default supported_archs {"i386 x86_64"}
}

if {[vercmp ${qt5.version} 5.9]>=0} {
    # in version 5.9, QT changed how it handles multiple architectures
    # see http://web.archive.org/web/20170621174843/http://doc.qt.io/qt-5/osx.html

    set qt_qmake_spec_32 macx-clang
    set qt_qmake_spec_64 macx-clang

    destroot.env-append INSTALL_ROOT=${destroot}
} else {
    # no universal binary support in Qt 5 versions < 5.9
    #     see http://lists.qt-project.org/pipermail/interest/2012-December/005038.html
    #     and https://bugreports.qt.io/browse/QTBUG-24952
    # override universal_setup found in portutil.tcl so it uses muniversal PortGroup
    # see https://trac.macports.org/ticket/51643
    proc universal_setup {args} {
        if {[variant_exists universal]} {
            ui_debug "universal variant already exists, so not adding the default one"
        } elseif {[exists universal_variant] && ![option universal_variant]} {
            ui_debug "universal_variant is false, so not adding the default universal variant"
        } elseif {[exists use_xmkmf] && [option use_xmkmf]} {
            ui_debug "using xmkmf, so not adding the default universal variant"
        } elseif {![exists os.universal_supported] || ![option os.universal_supported]} {
            ui_debug "OS doesn't support universal builds, so not adding the default universal variant"
        } elseif {[llength [option supported_archs]] == 1} {
            ui_debug "only one arch supported, so not adding the default universal variant"
        } else {
            ui_debug "adding universal variant via PortGroup muniversal"
            uplevel "PortGroup muniversal 1.0"
            uplevel "default universal_archs_supported {\"i386 x86_64\"}"
        }
    }

    # standard destroot environment
    pre-destroot {
        global merger_destroot_env
        if { ![option universal_variant] || ![variant_isset universal] } {
            destroot.env-append \
                INSTALL_ROOT=${destroot}
        } else {
            foreach arch ${configure.universal_archs} {
                lappend merger_destroot_env($arch) INSTALL_ROOT=${workpath}/destroot-${arch}
            }
        }
    }

    set qt_qmake_spec_32 macx-clang-32
    set qt_qmake_spec_64 macx-clang
}

default qt_qmake_spec {[qt5pg::get_default_spec]}

namespace eval qt5pg {
    proc get_default_spec {} {
        global configure.build_arch qt_qmake_spec_32 qt_qmake_spec_64
        if { ![option universal_variant] || ![variant_isset universal] } {
            if { ${configure.build_arch} eq "i386" } {
                return ${qt_qmake_spec_32}
            } else {
                return ${qt_qmake_spec_64}
            }
        } else {
            return ${qt_qmake_spec_64}
        }
    }
}

set private_building_qt5 false
# check to see if this is a Qt base port being built
foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {${qt_test_base_port} eq ${subport}} {
        set private_building_qt5 true
    }
}

if {!${private_building_qt5}} {
    pre-configure {
        ui_debug "qt5 PortGroup: Qt is provided by ${qt5.name}"

        if { [variant_exists qt5kde] && [variant_isset qt5kde] } {
            if { ${qt5.base_port} ne "qt5-kde" } {
                ui_error "qt5 PortGroup: Qt is installed but not qt5-kde, as is required by this variant"
                ui_error "qt5 PortGroup: please run `sudo port uninstall --follow-dependents ${qt5.base_port} and try again"
                return -code error "improper Qt installed"
            }
        } else {
            if { ${qt5.name} ne [qt5.get_default_name] } {
                # see https://wiki.qt.io/Qt-Version-Compatibility
                ui_warn "qt5 PortGroup: default Qt for this platform is [qt5.get_default_name] but ${qt5.name} is installed"
            }
            if { ${qt5.name} ne "qt5" } {
                ui_warn "Qt dependency is not the latest version but may be the latest supported on your OS"
            }
            if { ${os.major} < 11 } {
                ui_warn "Qt dependency is not supported on this platform and may not build"
            }
        }
    }
}

# add qt5kde variant if one does not exist and one is requested via qt5.kde_variant
# variant is added in eval_variants so that qt5.kde_variant can be set anywhere in the Portfile
rename ::eval_variants ::real_qt5_eval_variants
proc eval_variants {variations} {
    global qt5.kde_variant
    if { ![variant_exists qt5kde] && [tbool qt5.kde_variant] } {
        variant qt5kde description {use Qt patched for KDE compatibility} {}
    }
    uplevel ::real_qt5_eval_variants $variations
}

namespace eval qt5pg {
    proc register_dependents {} {
        global qt5_private_components qt5_private_build_components qt5.name

        if { ![exists qt5_private_components] } {
            # no Qt components have been requested
            # qt5.depends_component has never been called
            set qt5_private_components ""
        }
        if { ![exists qt5_private_build_components] } {
            # qt5.depends_build_component has never been called
            set qt5_private_build_components ""
        }

        if { [variant_exists qt5kde] && [variant_isset qt5kde] } {
            set qt_kde_name qt5-kde

            depends_lib-append port:${qt_kde_name}

            foreach component ${qt5_private_components} {
                switch -exact ${component} {
                    qtwebkit -
                    qtwebengine -
                    qtwebview -
                    qtenginio {
                        # these components are subports
                        depends_lib-append port:${qt_kde_name}-${component}
                    }
                    default {
                        # qt5-kde provides all components except those above
                    }
                }
            }
            foreach component ${qt5_private_build_components} {
                switch -exact ${component} {
                    qtwebkit -
                    qtwebengine -
                    qtwebview -
                    qtenginio {
                        # these components are subports
                        depends_build-append port:${qt_kde_name}-${component}
                    }
                    default {
                        # qt5-kde provides all components except those above
                    }
                }
            }
        } else {
            # ![variant_isset qt5kde]
            foreach component "qtbase ${qt5_private_components}" {
                if { ${component} eq "qt5" } {
                    depends_lib-append path:share/doc/qt5/README.txt:${qt5.name}
                } elseif { [info exists qt5pg::qt5_component_lib(${component})] } {
                    set component_info $qt5pg::qt5_component_lib(${component})
                    set path           [lindex ${component_info} 2]
                    depends_lib-append path:${path}:${qt5.name}-${component}
                } else {
                    return -code error "unknown component ${component}"
                }
            }
            foreach component ${qt5_private_build_components} {
                if { [info exists qt5pg::qt5_component_lib(${component})] } {
                    set component_info $qt5pg::qt5_component_lib(${component})
                    set path           [lindex ${component_info} 2]
                    depends_build-append path:${path}:${qt5.name}-${component}
                } else {
                    return -code error "unknown component ${component}"
                }
            }
        }
    }
}

if {!${private_building_qt5}} {
    port::register_callback qt5pg::register_dependents
}

unset private_building_qt5
