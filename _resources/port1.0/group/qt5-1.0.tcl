# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id: qt5-1.0.tcl 113952 2013-11-26 18:01:53Z michaelld@macports.org $

# Copyright (c) 2014 The MacPorts Project
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

# no universal binary support in Qt 5
#     see http://lists.qt-project.org/pipermail/interest/2012-December/005038.html
#     see also https://bugreports.qt-project.org/browse/QTBUG-24952
if { ![exists universal_variant] || [option universal_variant] } {
    PortGroup muniversal 1.0
    #universal_archs_supported i386 x86_64
}

# check for +debug variant of this port, and make sure Qt was
# installed with +debug as well; if not, error out.
platform darwin {
    pre-extract {
        if {[variant_exists debug] && \
            [variant_isset debug] && \
           ![info exists building_qt5]} {
            if {![file exists ${qt_frameworks_dir}/QtCore.framework/QtCore_debug]} {
                return -code error "\n\nERROR:\n\
In order to install this port as +debug,
Qt5 must also be installed with +debug.\n"
            }
        }
    }
}

# standard Qt5 name
global qt_name
set qt_name             qt5

# standard install directory
global qt_dir
set qt_dir               ${prefix}/libexec/qt5-mac

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

# standard Qt .app executables directory, if created?
global qt_apps_dir
set qt_apps_dir         ${qt_bins_dir}

# standard CMake module directory for Qt-related files
#global qt_cmake_module_dir
#set qt_cmake_module_dir ${qt_libs_dir}/cmake

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

# standard PKGCONFIG path
global qt_pkg_config_dir
set qt_pkg_config_dir   ${qt_libs_dir}/pkgconfig

# standard qmake spec
# other platforms required? (see http://doc.qt.io/qt-5/supported-platforms.html and http://doc.qt.io/QtSupportedPlatforms/index.html)
global qt_qmake_spec
global qt_qmake_spec_32
global qt_qmake_spec_64
compiler.whitelist clang

set qt_qmake_spec_32 macx-clang-32
set qt_qmake_spec_64 macx-clang

if { ![option universal_variant] || ![variant_isset universal] } {
    if { ${build_arch} eq "i386" } {
        set qt_qmake_spec ${qt_qmake_spec_32}
    } else {
        set qt_qmake_spec ${qt_qmake_spec_64}
    }
} else {
    set qt_qmake_spec ""
}

# standard cmake info for Qt5
global qt_cmake_defines
set qt_cmake_defines    \
    "-DQT_QT_INCLUDE_DIR=${qt_includes_dir} \
     -DQT_QMAKESPEC=${qt_qmake_spec} \
     -DQT_ZLIB_LIBRARY=${prefix}/lib/libz.dylib \
     -DQT_PNG_LIBRARY=${prefix}/lib/libpng.dylib"

# set Qt understood arch types, based on user preference
options qt_arch_types
default qt_arch_types   {[string map {i386 x86} [get_canonical_archs]]}

# allow for depending on either qt5-mac and qt5-mac-devel, simultaneously

if {![info exists building_qt5]} {
    if {${os.platform} eq "darwin"} {

        # see if the framework install exists, and if so depend on it;
        # if not, depend on the library version

        if {[file exists ${qt_frameworks_dir}/QtCore/QtCore]} {
            depends_lib-append path:Library/Frameworks/QtCore/QtCore:qt5-mac
        } else {
            depends_lib-append path:lib/libQtCore.5.dylib:qt5-mac
        }
    }
}

# standard configure environment, when not building qt5

if {![info exists building_qt5]} {
    configure.env-append \
        QTDIR=${qt_dir} \
        QMAKE=${qt_qmake_cmd} \
        MOC=${qt_moc_cmd}

    if { ![option universal_variant] || ![variant_isset universal] } {
        configure.env-append QMAKESPEC=${qt_qmake_spec}
    } else {
        set merger_configure_env(i386)   "QMAKESPEC=${qt_qmake_spec_32}"
        set merger_configure_env(x86_64) "QMAKESPEC=${qt_qmake_spec_64}"
    }

    # make sure the Qt binaries' directory is in the path, if it is
    # not the current prefix

    if {${qt_dir} ne ${prefix}} {
        configure.env-append PATH=${qt_dir}/bin:$env(PATH)
    }
} else {
    configure.env-append QMAKE_NO_DEFAULTS=""
}

# standard build environment, when not building qt5

if {![info exists building_qt5]} {
    build.env-append \
        QTDIR=${qt_dir} \
        QMAKE=${qt_qmake_cmd} \
        MOC=${qt_moc_cmd}

    if { ![option universal_variant] || ![variant_isset universal] } {
        build.env-append QMAKESPEC=${qt_qmake_spec}
    } else {
        set merger_build_env(i386)   "QMAKESPEC=${qt_qmake_spec_32}"
        set merger_build_env(x86_64) "QMAKESPEC=${qt_qmake_spec_64}"
    }

    # make sure the Qt binaries' directory is in the path, if it is
    # not the current prefix

    if {${qt_dir} ne ${prefix}} {
        build.env-append    PATH=${qt_dir}/bin:$env(PATH)
    }
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

# standard destroot environment, when not building qt5

if {![info exists building_qt5]} {
    destroot.env-append \
        QTDIR=${qt_dir} \
        QMAKE=${qt_qmake_cmd} \
        MOC=${qt_moc_cmd}

    if { ![option universal_variant] || ![variant_isset universal] } {
        build.env-append QMAKESPEC=${qt_qmake_spec}
    } else {
        set destroot_build_env(i386)   "QMAKESPEC=${qt_qmake_spec_32}"
        set destroot_build_env(x86_64) "QMAKESPEC=${qt_qmake_spec_64}"
    }

    # make sure the Qt binaries' directory is in the path, if it is
    # not the current prefix

    if {${qt_dir} ne ${prefix}} {
        destroot.env-append PATH=${qt_dir}/bin:$env(PATH)
    }
}
