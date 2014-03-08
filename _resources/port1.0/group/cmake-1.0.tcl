# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2009 Orville Bennett <illogical1 at gmail.com>
# Copyright (c) 2010-2013 The MacPorts Project
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

configure.cmd       ${prefix}/bin/cmake

configure.pre_args  -DCMAKE_INSTALL_PREFIX=${prefix}

configure.args      -DCMAKE_VERBOSE_MAKEFILE=ON \
                    -DCMAKE_COLOR_MAKEFILE=ON \
                    -DCMAKE_BUILD_TYPE=Release \
                    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                    -DCMAKE_INSTALL_RPATH=${prefix}/lib \
                    -DCMAKE_INSTALL_NAME_DIR=${prefix}/lib \
                    -DCMAKE_SYSTEM_PREFIX_PATH="${prefix}\;/usr" \
                    -DCMAKE_MODULE_PATH=${cmake_share_module_dir} \
                    -DCMAKE_FIND_FRAMEWORK=LAST \
                    -Wno-dev

# CMake honors set environment variables CFLAGS, CXXFLAGS, and LDFLAGS when it
# is first run in a build directory to initialize CMAKE_C_FLAGS,
# CMAKE_CXX_FLAGS, CMAKE_[EXE|SHARED|MODULE]_LINKER_FLAGS. However, be aware
# that a CMake script can always override these flags when it runs, as they
# are frequently set internally in functions of other CMake build variables!
#
# Attention: If you want to be sure that no compiler flags are passed via
# configure.args, you have to manually clear configure.optflags, as it is set
# to "-Os" by default and added to all language-specific flags. If you want to
# turn off optimization, explicitly set configure.optflags to "-O0".

# TODO: Handle configure.objcflags (cf. to CMake upstream ticket #4756
#       "CMake needs an Objective-C equivalent of CMAKE_CXX_FLAGS"
#       <http://public.kitware.com/Bug/view.php?id=4756>)

# TODO: Handle the Fortran-specific configure.* variables:
#       configure.fflags, configure.fcflags, configure.f90flags

# TODO: Handle the Java-specific configure.classpath variable.

pre-configure {
    # The environment variable CPPFLAGS is not considered by CMake.
    # (CMake upstream ticket #12928 "CMake silently ignores CPPFLAGS"
    # <http://www.cmake.org/Bug/view.php?id=12928>).
    # Thus, we have to add them manually to the CFLAGS and CXXFLAGS in the
    # pre-configure phase.
    if {${configure.cppflags} ne ""} {
        configure.cflags-append ${configure.cppflags}
        configure.cxxflags-append ${configure.cppflags}
    }

    # In addition, CMake provides build-type-specific flags for
    # Release (-O3 -DNDEBUG), Debug (-g), MinSizeRel (-Os -DNDEBUG), and
    # RelWithDebInfo (-O2 -g -DNDEBUG). If the configure.optflags have been
    # set (-Os by default), we have to remove the optimization flags from the
    # from the concerned Release build type so that configure.optflags
    # gets honored (Debug used by the +debug variant does not set
    # optimization flags by default).
    if {${configure.optflags} ne ""} {
        configure.args-append -DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
                              -DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG"
    }

    platform darwin {
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
            # Witout this, cmake will choose an SDK and deployment target on its own.
            configure.args-append -DCMAKE_OSX_SYSROOT=/ -DCMAKE_OSX_DEPLOYMENT_TARGET=""
        }
    }
}

configure.universal_args-delete --disable-dependency-tracking

variant debug description "Enable debug binaries" {
    configure.args-delete   -DCMAKE_BUILD_TYPE=Release
    configure.args-append   -DCMAKE_BUILD_TYPE=Debug
}

# cmake doesn't like --enable-debug, so in case a portfile sets
# --enable-debug (regardless of variant) we remove it
if {[string first "--enable-debug" ${configure.args}] > -1} {
    configure.args-delete     --enable-debug
}
