# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2009 Orville Bennett <illogical1 at gmail.com>
# Copyright (c) 2010-2012 The MacPorts Project
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
# Usage:
# PortGroup     cmake 1.0

# standard place to install extra CMake modules
set cmake_share_module_dir ${prefix}/share/cmake/modules

depends_build-append port:cmake

#FIXME: ccache works with cmake on linux
configure.ccache    no

configure.cmd       cmake

configure.pre_args  -DCMAKE_INSTALL_PREFIX=${prefix}

configure.args      -DCMAKE_VERBOSE_MAKEFILE=ON \
                    -DCMAKE_COLOR_MAKEFILE=ON \
                    -DCMAKE_BUILD_TYPE=Release \
                    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                    -DCMAKE_INSTALL_NAME_DIR=${prefix}/lib \
                    -DCMAKE_SYSTEM_PREFIX_PATH="${prefix}\;/usr" \
                    -DCMAKE_MODULE_PATH=${cmake_share_module_dir} \
                    -Wno-dev

platform darwin {
    pre-configure {
        if {[variant_exists universal] && [variant_isset universal]} {
            if {[info exists universal_archs_supported]} {
                global merger_configure_args
                foreach arch ${universal_archs_to_use} {
                    lappend merger_configure_args(${arch}) -DCMAKE_OSX_ARCHITECTURES=${arch}
                }
            } else {
                configure.universal_args-append \
                    -DCMAKE_OSX_ARCHITECTURES="[join ${configure.universal_archs} \;]"
            }
        } else {
            configure.args-append \
                -DCMAKE_OSX_ARCHITECTURES="${configure.build_arch}"
        }
        if {${configure.sdkroot} != ""} {
            configure.args-append -DCMAKE_OSX_SYSROOT="${configure.sdkroot}"
        } else {
            configure.args-append -DCMAKE_OSX_SYSROOT=/
        }
    }
}

configure.universal_args-delete --disable-dependency-tracking

variant debug description "Enable debug binaries" {
    configure.args-delete   -DCMAKE_BUILD_TYPE=Release
    configure.args-append   -DCMAKE_BUILD_TYPE=debugFull
}
