# $Id: $

# Copyright (c) 2010 The MacPorts Project
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
# This portgroup defined standard settings when using Qt4.
#
# Usage:
# PortGroup     qt4 1.0

# standard Qt4 name
set qt_name             qt4

# standard install directory
set qt_dir              ${prefix}

# standard Qt documents directory
set qt_docs_dir         ${qt_dir}/share/doc/${qt_name}

# standard Qt plugins directory
set qt_plugins_dir      ${qt_dir}/share/${qt_name}/plugins

# standard Qt mkspecs directory
set qt_mkspecs_dir      ${qt_dir}/share/${qt_name}/mkspecs

# standard Qt imports directory
set qt_imports_dir      ${qt_dir}/share/${qt_name}/imports

# standard Qt includes directory
set qt_includes_dir     ${qt_dir}/includes

# standard Qt libraries directory
set qt_libs_dir         ${qt_dir}/lib

# standard Qt data directory
set qt_data_dir         ${qt_dir}/share/${qt_name}

# standard Qt translations directory
set qt_translations_dir ${qt_dir}/share/${qt_name}/translations

# standard Qt sysconf directory
set qt_sysconf_dir      ${qt_dir}/etc/${qt_name}

# standard Qt examples directory
set qt_examples_dir     ${qt_dir}/share/${qt_name}/examples

# standard Qt demos directory
set qt_demos_dir        ${qt_dir}/share/${qt_name}/demos

# standard CMake module directory for Qt-related files
set qt_cmake_module_dir ${qt_dir}/share/cmake/modules

# standard qmake command location
set qt_qmake_cmd        ${qt_dir}/bin/qmake

# standard moc command location
set qt_moc_cmd          ${qt_dir}/bin/moc

# standard uic command location
set qt_uic_cmd          ${qt_dir}/bin/uic

# standard lrelease command location
set qt_lrelease_cmd     ${qt_dir}/bin/lrelease

# standard cmake info for Qt4
set qt_cmake_defines    "-DQT_QT_INCLUDE_DIR=${qt_includes_dir} \
                         -DQT_LIBRARY_DIR=${qt_libs_dir} \
                         -DQT_QMAKE_EXECUTABLE=${qt_qmake_cmd}"

# allow for both qt4 and qt4 devel
depends_lib-append      bin:qmake:qt4-mac

# standard configure environment
configure.env-append    QTDIR=${qt_dir} \
                        QMAKE=${qt_qmake_cmd} \
                        MOC=${qt_moc_cmd}

# standard build environment
build.env-append        QTDIR=${qt_dir} \
                        QMAKE=${qt_qmake_cmd} \
                        MOC=${qt_moc_cmd}

# use PKGCONFIG for Qt discovery in configure scripts
depends_build-append    bin:pkg-config:pkgconfig

# use a parallel build by default
use_parallel_build      yes

# standard destroot environment
destroot.env-append     QTDIR=${qt_dir} \
                        QMAKE=${qt_qmake_cmd} \
                        MOC=${qt_moc_cmd} \
                        INSTALL_ROOT=${destroot} \
                        DESTDIR=${destroot}

# append Qt's PKGCONFIG path to whatever is there now.
set qt_pkg_config_path ${qt_dir}/lib/pkgconfig
if {${qt_dir} != ${prefix}} {
    set qt_pkg_config_path ${pkg_config_path}:${prefix}/lib/pkgconfig
}
if {${configure.pkg_config_path} == ""} {
    configure.pkg_config_path ${qt_pkg_config_path}
} else {
    configure.pkg_config_path ${qt_pkg_config_path}:${configure.pkg_config_path}
}
unset qt_pkg_config_path
