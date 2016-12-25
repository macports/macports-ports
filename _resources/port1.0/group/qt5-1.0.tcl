# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2014-2016 The MacPorts Project
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
set available_qt_versions {
    qt5
    qt55
}

# standard Qt5 name
global qt_name

if { ![info exists qt_name] } {

    if { ${os.major} <= 7 } {
        #
        # Qt 5 does not support ppc
        # see http://doc.qt.io/qt-5/osx-requirements.html
        #
        set qt_name qt5
        #
    } elseif { ${os.major} <= 9 } {
        #
        # Mac OS X Tiger (10.4)
        # Mac OS X Leopard (10.5)
        #
        # never supported by Qt 5
        #
        set qt_name qt5
        #
    } elseif { ${os.major} == 10 } {
        #
        # Mac OS X Snow Leopard (10.6)
        #
        #     Qt 5.3: Deployment only
        # Qt 5.0-5.2: Occasionally tested
        #
        set qt_name qt5
        #
    } elseif { ${os.major} == 11 } {
        #
        # Mac OS X Lion (10.7)
        #
        # Qt 5.6: Deployment only
        # Qt 5.5: Occasionally tested
        # Qt 5.4: Supported
        #
        set qt_name qt5
        #
    } elseif { ${os.major} <= 12 } {
        #
        # OS X Mountain Lion (10.8)
        # OS X Mavericks (10.9)
        # OS X Yosemite (10.10)
        # OS X El Capitan (10.11)
        #
        # Qt 5.7: Supported
        # Qt 5.6: Supported
        #
        set qt_name qt5
        #
    } elseif { ${os.major} <= 16 } {
        #
        # macOS Sierra (10.12)
        # as of Qt version 5.7, there is no official support
        #
        set qt_name qt5
        #
    } else {
        #
        # macOS ??? (???)
        #
        set qt_name qt5
        #
    }
}

# Qt has what is calls reference configurations, which are said to be thoroughly tested
# Qt also has configurations which are "occasionally tested" or are "[d]eployment only"
# see http://doc.qt.io/qt-5/supported-platforms.html#reference-configurations
global qt5_min_tested_version
global qt5_max_tested_version
global qt5_min_reference_version
global qt5_max_reference_version

# see http://doc.qt.io/qt-5/supported-platforms-and-configurations.html
switch ${qt_name} {
    qt5 {
        set qt5_min_tested_version     12
        set qt5_max_tested_version     15
        set qt5_min_reference_version  12
        set qt5_max_reference_version  15
    }
    qt55 {
        set qt5_min_tested_version     11
        set qt5_max_tested_version     14
        set qt5_min_reference_version  13
        set qt5_max_reference_version  14
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

# standard Qt demos directory
#global qt_demos_dir
#set qt_demos_dir        ${qt_dir}/share/${qt_name}/demos

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

if {[tbool just_want_qt5_variables]} {
    return
}

# no universal binary support in Qt 5
#     see http://lists.qt-project.org/pipermail/interest/2012-December/005038.html
#     and https://bugreports.qt.io/browse/QTBUG-24952
default supported_archs {"i386 x86_64"}
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

# standard qmake spec
# other platforms required
#     see http://doc.qt.io/qt-5/supported-platforms.html
#     and http://doc.qt.io/QtSupportedPlatforms/index.html
global qt_qmake_spec
global qt_qmake_spec_32
global qt_qmake_spec_64
compiler.blacklist-append *gcc*

set qt_qmake_spec_32 macx-clang-32
set qt_qmake_spec_64 macx-clang

if { ![option universal_variant] || ![variant_isset universal] } {
    if { ${configure.build_arch} eq "i386" } {
        set qt_qmake_spec ${qt_qmake_spec_32}
    } else {
        set qt_qmake_spec ${qt_qmake_spec_64}
    }
} else {
    set qt_qmake_spec ""
}

# do not try to install if qt5-qtbase dependency will fail to build
# warn about non-reference configurations
if { ${os.major} < ${qt5_min_tested_version} } {
    pre-fetch {
        ui_warn "Qt dependency is not supported on this platform and may not build"
    }
}

if { ${qt_name} ne "qt5" } {
    pre-fetch {
        ui_warn "Qt dependency is not the latest version but may be the latest supported on your OS"
    }
}

if {![info exists building_qt5]} {
    depends_lib-append path:lib/pkgconfig/Qt5Core.pc:${qt_name}-qtbase
}

# use PKGCONFIG for Qt discovery in configure scripts
depends_build-append    port:pkgconfig

# standard destroot environment
if { ![option universal_variant] || ![variant_isset universal] } {
    destroot.env-append \
        INSTALL_ROOT=${destroot}
} else {
    foreach arch ${configure.universal_archs} {
        lappend merger_destroot_env($arch) INSTALL_ROOT=${workpath}/destroot-${arch}
    }
}
