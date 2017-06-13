# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2010-2015 The MacPorts Project
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
# This portgroup defines standard settings when using Qt4.
#
# Usage:
# PortGroup     qt4 1.0

# standard Qt4 name
global qt_name
set qt_name             qt4

# standard install directory
global qt_dir
set qt_dir              ${prefix}/libexec/qt4

# standard Qt includes directory
global qt_includes_dir
set qt_includes_dir     ${qt_dir}/include

# standard Qt libraries directory
global qt_libs_dir
set qt_libs_dir         ${qt_dir}/lib

# standard Qt libraries directory
global qt_frameworks_dir
set qt_frameworks_dir   ${qt_dir}/Library/Frameworks

# standard Qt non-.app executables directory
global qt_bins_dir
set qt_bins_dir         ${qt_dir}/bin

# standard Qt .app executables directory, if created
global qt_apps_dir
set qt_apps_dir         ${applications_dir}/Qt4

# standard Qt share directory
global qt_share_dir
set qt_share_dir        ${qt_dir}/share

# standard Qt documents directory
global qt_docs_dir
if {${qt_dir} ne ${prefix}} {
    set qt_docs_dir         ${qt_share_dir}/doc
} else {
    set qt_docs_dir         ${qt_share_dir}/doc/${qt_name}
}

# standard Qt plugins directory
global qt_plugins_dir
if {${qt_dir} ne ${prefix}} {
    set qt_plugins_dir      ${qt_share_dir}/plugins
} else {
    set qt_plugins_dir      ${qt_share_dir}/${qt_name}/plugins
}

# standard Qt mkspecs directory
global qt_mkspecs_dir
if {${qt_dir} ne ${prefix}} {
    set qt_mkspecs_dir      ${qt_share_dir}/mkspecs
} else {
    set qt_mkspecs_dir      ${qt_share_dir}/${qt_name}/mkspecs
}

# standard Qt imports directory
global qt_imports_dir
if {${qt_dir} ne ${prefix}} {
    set qt_imports_dir      ${qt_share_dir}/imports
} else {
    set qt_imports_dir      ${qt_share_dir}/${qt_name}/imports
}

# standard Qt data directory
# Don't append /data. Here be dragons.
global qt_data_dir
if {${qt_dir} ne ${prefix}} {
    set qt_data_dir         ${qt_share_dir}
} else {
    set qt_data_dir         ${qt_share_dir}/${qt_name}
}

# standard Qt translations directory
global qt_translations_dir
if {${qt_dir} ne ${prefix}} {
    set qt_translations_dir ${qt_share_dir}/translations
} else {
    set qt_translations_dir ${qt_share_dir}/${qt_name}/translations
}

# standard Qt sysconf directory
global qt_sysconf_dir
if {${qt_dir} ne ${prefix}} {
    set qt_sysconf_dir      ${qt_share_dir}/sysconf
} else {
    set qt_sysconf_dir      ${qt_share_dir}/${qt_name}/sysconf
}

# standard Qt examples directory
global qt_examples_dir
if {${qt_dir} ne ${prefix}} {
    set qt_examples_dir     ${qt_share_dir}/examples
} else {
    set qt_examples_dir     ${qt_share_dir}/${qt_name}/examples
}

# standard Qt demos directory
global qt_demos_dir
if {${qt_dir} ne ${prefix}} {
    set qt_demos_dir        ${qt_share_dir}/demos
} else {
    set qt_demos_dir        ${qt_share_dir}/${qt_name}/demos
}

# standard CMake module directory for Qt-related files
global qt_cmake_module_dir
set qt_cmake_module_dir ${qt_share_dir}/cmake/Modules

# standard qmake command location
global qt_qmake_cmd
set qt_qmake_cmd        ${qt_bins_dir}/qmake

# standard qmake spec
global qt_qmake_spec
set qt_qmake_spec       macx-g++

# standard moc command location
global qt_moc_cmd
set qt_moc_cmd          ${qt_bins_dir}/moc

# standard uic command location
global qt_uic_cmd
set qt_uic_cmd          ${qt_bins_dir}/uic

# standard lrelease command location
global qt_lrelease_cmd
set qt_lrelease_cmd     ${qt_bins_dir}/lrelease

# standard lupdate command location
global qt_lupdate_cmd
set qt_lupdate_cmd     ${qt_dir}/bin/lupdate

# standard PKGCONFIG path
global qt_pkg_config_dir
set qt_pkg_config_dir   ${qt_libs_dir}/pkgconfig

# standard cmake info for Qt4
global qt_cmake_defines
set qt_cmake_defines    \
    "-DQT_QT_INCLUDE_DIR=${qt_includes_dir} \
     -DQT_QMAKESPEC=${qt_qmake_spec} \
     -DQT_ZLIB_LIBRARY=${prefix}/lib/libz.dylib \
     -DQT_PNG_LIBRARY=${prefix}/lib/libpng.dylib"

# set Qt understood arch types, based on user preference
options qt_arch_types
default qt_arch_types {[string map {i386 x86} [get_canonical_archs]]}

# allow for depending on either qt4-mac and qt4-mac-devel, simultaneously

if {![info exists building_qt4]} {
    if {${os.platform} eq "darwin"} {

        # see if the framework install exists, and if so depend on it;
        # if not, depend on the library version

        if {[file exists ${qt_frameworks_dir}/QtCore/QtCore]} {
            depends_lib-append path:Library/Frameworks/QtCore/QtCore:qt4-mac
        } else {
            depends_lib-append path:lib/libQtCore.4.dylib:qt4-mac
        }

    } else {
        depends_lib-append      path:lib/libQtCore.so.4:qt4-x11
    }
}

# standard configure environment, when not building qt4

if {![info exists building_qt4]} {
    configure.env-append \
        QTDIR=${qt_dir} \
        QMAKE=${qt_qmake_cmd} \
        QMAKESPEC=${qt_qmake_spec} \
        MOC=${qt_moc_cmd}

    # make sure Qt directories are in various paths, if Qt is not
    # directly installed into ${prefix}

    if {${qt_dir} ne ${prefix}} {
        configure.env-append PATH=${qt_dir}/bin:$env(PATH)
        configure.pkg_config_path-append ${qt_pkg_config_dir}
    }
} else {
    configure.env-append QMAKE_NO_DEFAULTS=""
}

# standard build environment, when not building qt4

if {![info exists building_qt4]} {
    build.env-append \
        QTDIR=${qt_dir} \
        QMAKE=${qt_qmake_cmd} \
        QMAKESPEC=${qt_qmake_spec} \
        MOC=${qt_moc_cmd}

    # make sure the Qt binaries' directory is in the path, if it is
    # not the current prefix

    if {${qt_dir} ne ${prefix}} {
        build.env-append    PATH=${qt_dir}/bin:$env(PATH)
    }
} else {
    build.env-append QMAKE_NO_DEFAULTS=""
}

# use PKGCONFIG for Qt discovery in configure scripts
depends_build-append    port:pkgconfig

# standard destroot environment

destroot.env-append \
    INSTALL_ROOT=${destroot} \
    DESTDIR=${destroot}

# standard destroot environment, when not building qt4

if {![info exists building_qt4]} {
    destroot.env-append \
        QTDIR=${qt_dir} \
        QMAKE=${qt_qmake_cmd} \
        QMAKESPEC=${qt_qmake_spec} \
        MOC=${qt_moc_cmd}

    # make sure the Qt binaries' directory is in the path, if it is
    # not the current prefix

    if {${qt_dir} ne ${prefix}} {
        destroot.env-append PATH=${qt_dir}/bin:$env(PATH)
    }
} else {
    destroot.env-append QMAKE_NO_DEFAULTS=""
}
