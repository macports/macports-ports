# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2009 Orville Bennett <illogical1 at gmail.com>
# Copyright (c) 2010-2016 The MacPorts Project
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

options cmake.build_dir cmake.install_prefix cmake.out_of_source

default cmake.build_dir         {${workpath}/build}
default cmake.install_prefix    {${prefix}}
default cmake.out_of_source     {no}

# standard place to install extra CMake modules
set cmake_share_module_dir ${prefix}/share/cmake/Modules

# can use cmake or cmake-devel; default to cmake if not installed
depends_build-append path:bin/cmake:cmake

proc _cmake_get_build_dir {} {
    if {[option cmake.out_of_source]} {
        return [option cmake.build_dir]
    }
    return [option worksrcpath]
}

default configure.dir {[_cmake_get_build_dir]}

pre-configure {
    file mkdir ${configure.dir}
}

#FIXME: ccache works with cmake on linux
configure.ccache    no

configure.cmd       ${prefix}/bin/cmake

default configure.pre_args {-DCMAKE_INSTALL_PREFIX='${cmake.install_prefix}'}

# Policy 0025=NEW : identify Apple Clang compiler as "AppleClang";
# MacPorts Clang is then handled separately from AppleClang. This
# setting ensures consistency in compiler feature determination and
# use, which is especially useful for older Mac OS X installs --
# e.g., ones that use MacPorts Clang 4.0 via the cxx11 1.1 PortGroup.

default configure.args {[list \
                    -DCMAKE_BUILD_TYPE=Release \
                    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                   {-DCMAKE_C_COMPILER="$CC"} \
                    -DCMAKE_COLOR_MAKEFILE=ON \
                   {-DCMAKE_CXX_COMPILER="$CXX"} \
                    -DCMAKE_FIND_FRAMEWORK=LAST \
                    -DCMAKE_INSTALL_NAME_DIR=${prefix}/lib \
                    -DCMAKE_INSTALL_RPATH=${prefix}/lib \
                    -DCMAKE_MODULE_PATH=${cmake_share_module_dir} \
                    -DCMAKE_SYSTEM_PREFIX_PATH="${prefix}\;/usr" \
                    -DCMAKE_VERBOSE_MAKEFILE=ON \
                    -DCMAKE_POLICY_DEFAULT_CMP0025=NEW \
                    -Wno-dev
                    ]}

default configure.post_args {${worksrcpath}}

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
#       <https://public.kitware.com/Bug/view.php?id=4756>)

# TODO: Handle the Fortran-specific configure.* variables:
#       configure.fflags, configure.fcflags, configure.f90flags

# TODO: Handle the Java-specific configure.classpath variable.

pre-configure {
    # The environment variable CPPFLAGS is not considered by CMake.
    # (CMake upstream ticket #12928 "CMake silently ignores CPPFLAGS"
    # <https://www.cmake.org/Bug/view.php?id=12928>).
    #
    # But adding -I${prefix}/include to CFLAGS/CXXFLAGS is a bad idea.
    # If any other flags are needed, we need to add them.

    # In addition, CMake provides build-type-specific flags for Release (-O3
    # -DNDEBUG), Debug (-g), MinSizeRel (-Os -DNDEBUG), and RelWithDebInfo
    # (-O2 -g -DNDEBUG). If the configure.optflags have been set (-Os by
    # default), we have to remove the optimization flags from the concerned
    # Release build type so that configure.optflags gets honored (Debug used
    # by the +debug variant does not set optimization flags by default).
    if {${configure.optflags} ne ""} {
        configure.args-append -DCMAKE_C_FLAGS_RELEASE="-DNDEBUG" \
                              -DCMAKE_CXX_FLAGS_RELEASE="-DNDEBUG"
    }

    # CMake doesn't like --enable-debug, so remove it unconditionally.
    configure.args-delete --enable-debug
}

platform darwin {
    set cmake._archflag_vars {cc_archflags cxx_archflags ld_archflags objc_archflags objcxx_archflags universal_cflags universal_cxxflags universal_ldflags universal_objcflags universal_objcxxflags}

    pre-configure {
        # cmake will add the correct -arch flag(s) based on the value of CMAKE_OSX_ARCHITECTURES.
        if {[variant_exists universal] && [variant_isset universal]} {
            if {[info exists universal_archs_supported]} {
                merger_arch_compiler no
                merger_arch_flag no
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

        # Setting our own -arch flags is unnecessary (in the case of a non-universal build) or even
        # harmful (in the case of a universal build, because it causes the compiler identification to
        # fail; see https://public.kitware.com/pipermail/cmake-developers/2015-September/026586.html).
        # Save all archflag-containing variables before changing any of them, because some of them
        # declare their default value based on the value of another.
        foreach archflag_var ${cmake._archflag_vars} {
            global cmake._saved_${archflag_var}
            set cmake._saved_${archflag_var} [option configure.${archflag_var}]
        }
        foreach archflag_var ${cmake._archflag_vars} {
            configure.${archflag_var}
        }

        configure.args-append -DCMAKE_OSX_DEPLOYMENT_TARGET="${macosx_deployment_target}"

        if {${configure.sdkroot} != ""} {
            configure.args-append -DCMAKE_OSX_SYSROOT="${configure.sdkroot}"
        } else {
            configure.args-append -DCMAKE_OSX_SYSROOT="/"
        }
    }

    post-configure {
        # Although cmake wants us not to set -arch flags ourselves when we run cmake,
        # ports might have need to access these variables at other times.
        foreach archflag_var ${cmake._archflag_vars} {
            global cmake._saved_${archflag_var}
            configure.${archflag_var} [set cmake._saved_${archflag_var}]
        }
    }
}

configure.universal_args-delete --disable-dependency-tracking

variant debug description "Enable debug binaries" {
    configure.args-replace  -DCMAKE_BUILD_TYPE=Release -DCMAKE_BUILD_TYPE=Debug
}

default build.dir {${configure.dir}}

default build.post_args {VERBOSE=ON}

# Generated Unix Makefiles contain a "fast" install target that begins
# installing immediately instead of checking build dependencies again.
default destroot.target {install/fast}
