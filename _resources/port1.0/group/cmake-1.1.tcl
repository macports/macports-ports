# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2009 Orville Bennett <illogical1 at gmail.com>
# Copyright (c) 2010-2015 The MacPorts Project
# Copyright (c) 2015, 2016 R.J.V. Bertin
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
# PortGroup     cmake 1.1

namespace eval cmake {
    # our directory:
    variable currentportgroupdir [file dirname [dict get [info frame 0] file]]
}

options                             cmake.build_dir \
                                    cmake.generator \
                                    cmake.install_prefix \
                                    cmake.install_rpath \
                                    cmake_share_module_dir \
                                    cmake.out_of_source \
                                    cmake.set_osx_architectures

# make out-of-source builds the default (finally)
default cmake.out_of_source         {yes}

# set CMAKE_OSX_ARCHITECTURES when necessary.
# This can be deactivated when (non-Apple) compilers are used
# that don't support the corresponding -arch options.
default cmake.set_osx_architectures {yes}

default cmake.build_dir             {${workpath}/build}

# cmake-based ports may want to modify the install prefix
default cmake.install_prefix        {${prefix}}
# minimal/initial value for the install rpath:
default cmake.install_rpath         {${prefix}/lib}
proc cmake::rpath_flags {} {
    global prefix
    if {[llength [option cmake.install_rpath]]} {
        # make sure a ${cmake.install_prefix} is included in the rpath
        # careful, we are likely to be called more than once.
        if {[lsearch -exact [option cmake.install_rpath] [option cmake.install_prefix]/lib] == -1} {
            cmake.install_rpath-append [option cmake.install_prefix]/lib
        }
        return [list \
            -DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON \
            -DCMAKE_INSTALL_RPATH="[join [option cmake.install_rpath] \;]"
        ]
    }
    # always build with full RPATH; this is the default on Mac.
    # Let ports deactivate it explicitly if they need to.
    return -DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=ON
}

proc cmake::system_prefix_path {} {
    global prefix
    if {[option cmake.install_prefix] ne ${prefix}} {
        return [list \
                 -DCMAKE_SYSTEM_PREFIX_PATH="${prefix}\;[option cmake.install_prefix]\;/usr"
        ]
    } else {
        return [list \
                 -DCMAKE_SYSTEM_PREFIX_PATH="${prefix}\;/usr"
        ]
    }
}

# CMake provides several different generators corresponding to different utilities
# (and IDEs) used for building the sources. We support "Unix Makefiles" (the default)
# and Ninja, a leaner-and-meaner alternative.
#
# In the Portfile, use
#
# cmake.generator Ninja
# or
# cmake.generator "Unix Makefiles"
# or even
# cmake.generator "Eclipse CDT4 - Ninja"
# if maintaining the port means editing it using an IDE of choice.
#
default cmake.generator             {"Unix Makefiles"}
# CMake generates Unix Makefiles that contain a special "fast" install target
# which skips the whole "let's see if there's anything left to (re)build before
# we install" you normally get with `make install`. That check should be
# redundant in normal destroot steps, because we just completed the build step.
default destroot.target             {install/fast}

# standard place to install extra CMake modules
default cmake_share_module_dir      {${prefix}/share/cmake/Modules}

# can use cmake or cmake-devel; default to cmake if not installed
depends_build-append                path:bin/cmake:cmake

proc _cmake_get_build_dir {} {
    if {[option cmake.out_of_source]} {
        return [option cmake.build_dir]
    }
    return [option worksrcpath]
}

option_proc cmake.generator cmake::handle_generator
proc cmake::handle_generator {option action args} {
    global cmake.generator destroot destroot.target build.cmd build.post_args
    global depends_build destroot.post_args build.jobs
    if {${action} eq "set"} {
        switch -glob [lindex ${args} 0] {
            "*Unix Makefiles*" {
                ui_debug "Selecting the 'Unix Makefiles' generator ($args)"
                depends_build-delete \
                                    port:ninja
                build.cmd           make
                build.post_args     VERBOSE=ON
                destroot.target     install/fast
                destroot.destdir    DESTDIR=${destroot}
                # unset the DESTDIR env. variable if it has been set before
                destroot.env-delete DESTDIR=${destroot}
            }
            "*Ninja" {
                ui_debug "Selecting the Ninja generator ($args)"
                depends_build-append \
                                    port:ninja
                build.cmd           ninja
                # force Ninja to use the exact number of requested build jobs
                build.post_args     -j${build.jobs} -v
                destroot.target     install
                # ninja needs the DESTDIR argument in the environment
                destroot.destdir
                destroot.env-append DESTDIR=${destroot}
            }
            default {
                if {[llength $args] != 1} {
                    set msg "cmake.generator requires a single value (not \"${args}\")"
                } else {
                    set msg "The \"${args}\" generator is not currently known/supported (cmake.generator is case-sensitive!)"
                }
                if {[file tail ${cmake::currentportgroupdir}] eq "group"} {
                    # we're not being run from the registry so we can raise errors
                    return -code error ${msg}
                } else {
                    ui_error "${msg} (ignoring)"
                }
            }
        }
    }
}

default configure.dir {[_cmake_get_build_dir]}
default build.dir {${configure.dir}}
default build.post_args {VERBOSE=ON}

#FIXME: ccache works with cmake on linux
configure.ccache    no

configure.cmd       ${prefix}/bin/cmake

# appropriate default settings for configure.pre_args
# variables are grouped thematically, with the more important ones
# at the beginning or end for somewhat easier at-a-glance verification.
default configure.pre_args {[list \
                    -DCMAKE_INSTALL_PREFIX="${cmake.install_prefix}" \
                    -DCMAKE_INSTALL_NAME_DIR=${cmake.install_prefix}/lib \
                    {*}[cmake::system_prefix_path] \
                    {-DCMAKE_C_COMPILER="$CC"} \
                    {-DCMAKE_CXX_COMPILER="$CXX"} \
                    -DCMAKE_VERBOSE_MAKEFILE=ON \
                    -DCMAKE_COLOR_MAKEFILE=ON \
                    -DCMAKE_FIND_FRAMEWORK=LAST \
                    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
                    -DCMAKE_MODULE_PATH=${cmake_share_module_dir} \
                    {*}[cmake::rpath_flags] \
                    -Wno-dev
]}

configure.args      -DCMAKE_BUILD_TYPE=MacPorts

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
#       <http://public.kitware.com/Bug/view.php?id=4756>)

# TODO: Handle the Fortran-specific configure.* variables:
#       configure.fflags, configure.fcflags, configure.f90flags

# TODO: Handle the Java-specific configure.classpath variable.

pre-configure {
    # create the build directory:
    file mkdir ${configure.dir}

    # The environment variable CPPFLAGS is not considered by CMake.
    # (CMake upstream ticket #12928 "CMake silently ignores CPPFLAGS"
    # <http://www.cmake.org/Bug/view.php?id=12928>).
    #
    # But adding -I${prefix}/include to CFLAGS/CXXFLAGS is a bad idea.
    # If any other flags are needed, we need to add them.

    # In addition, CMake provides build-type-specific flags for
    # Release (-O3 -DNDEBUG), Debug (-g), MinSizeRel (-Os -DNDEBUG), and
    # RelWithDebInfo (-O2 -g -DNDEBUG). If the configure.optflags have been
    # set (-Os by default), we have to remove the optimization flags from the
    # from the concerned Release build type so that configure.optflags
    # gets honored (Debug used by the +debug variant does not set
    # optimization flags by default).
    # NB: more recent CMake versions (>=3?) no longer take the env. variables into
    # account, and thus require explicit use of ${configure.c*flags} below:
    # Using a custom BUILD_TYPE we can simply append to the env. variables,
    if {![variant_isset debug]} {
        configure.cflags-append     -DNDEBUG
        configure.cxxflags-append   -DNDEBUG
    }

    # process ${configure.cppflags} because CMake ignores $CPPFLAGS
    if {${configure.cppflags} ne ""} {
        set cppflags [split ${configure.cppflags}]
        # reset configure.cppflags; we don't want options in double in CPPFLAGS and CFLAGS/CXXFLAGS
        configure.cppflags
        # copy the cppflags arguments one by one into cflags and family
        # CMake does have an INCLUDE_DIRECTORIES variable but setting it from the commandline
        # doesn't have the intended effect (any longer).
        foreach flag ${cppflags} {
            configure.cflags-append     ${flag}
            configure.cxxflags-append   ${flag}
            # append to the ObjC flags too, even if CMake ignores them:
            configure.objcflags-append  ${flag}
            configure.objcxxflags-append   ${flag}
        }
        ui_debug "CFLAGS=\"${configure.cflags}\" CXXFLAGS=\"${configure.cxxflags}\""
    }

#     if {${cmake.install_rpath} ne ""} {
#         ui_debug "Adding -DCMAKE_INSTALL_RPATH=[join ${cmake.install_rpath} \;] to configure.args"
#         configure.post_args-prepend -DCMAKE_INSTALL_RPATH="[join ${cmake.install_rpath} \;]"
#     }
    configure.pre_args-prepend "-G \"[join ${cmake.generator}]\""
    # CMake doesn't like --enable-debug, so remove it unconditionally.
    configure.args-delete --enable-debug
}

post-configure {
    # either compile_commands.json was created because of -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    # in which case touch'ing it won't change anything. Or else it wasn't created, in which case
    # we'll create a file that corresponds, i.e. containing an empty json array.
    if {![file exists ${build.dir}/compile_commands.json]} {
        if {![catch {set fd [open "${build.dir}/compile_commands.json" "w"]} err]} {
            puts ${fd} "\[\n\]"
            close ${fd}
        }
    }
}

proc cmake.save_configure_cmd {} {
    post-configure {
        if {![catch {set fd [open "${workpath}/.macports.${subport}.configure.cmd" "w"]} err]} {
            foreach var [array names ::env] {
                puts ${fd} "${var}=$::env(${var})"
            }
            puts ${fd} "[join [lrange [split ${configure.env} " "] 0 end] "\n"]"
            # the following variables are no longer set in the environment at this point:
            puts ${fd} "CPP=\"${configure.cpp}\""
            # these are particularly relevant because referenced in the configure.pre_args:
            puts ${fd} "CC=\"${configure.cc}\""
            puts ${fd} "CXX=\"${configure.cxx}\""
            if {${configure.objcxx} ne ${configure.cxx}} {
                puts ${fd} "OBJCXX=\"${configure.objcxx}\""
            }
            puts ${fd} "CFLAGS=\"${configure.cflags}\""
            puts ${fd} "CXXFLAGS=\"${configure.cxxflags}\""
            if {${configure.objcflags} ne ${configure.cflags}} {
                puts ${fd} "OBJCFLAGS=\"${configure.objcflags}\""
            }
            if {${configure.objcxxflags} ne ${configure.cxxflags}} {
                puts ${fd} "OBJCXXFLAGS=\"${configure.objcxxflags}\""
            }
            puts ${fd} "LDFLAGS=\"${configure.ldflags}\""
            if {${configure.optflags} ne ""} {
                puts ${fd} "configure.optflags=\"${configure.optflags}\""
            }
            puts ${fd} "\ncd ${worksrcpath}"
            puts ${fd} "${configure.cmd} [join ${configure.pre_args}] [join ${configure.args}] [join ${configure.post_args}]"
            close ${fd}
            unset fd
        }
    }
}

platform darwin {
    set cmake._archflag_vars {cc_archflags cxx_archflags ld_archflags objc_archflags objcxx_archflags \
        universal_cflags universal_cxxflags universal_ldflags universal_objcflags universal_objcxxflags}
    pre-configure {
        # cmake will add the correct -arch flag(s) based on the value of CMAKE_OSX_ARCHITECTURES.
        if {[variant_exists universal] && [variant_isset universal]} {
            if {[info exists universal_archs_supported]} {
                merger_arch_compiler no
                merger_arch_flag no
                if {${cmake.set_osx_architectures}} {
                    global merger_configure_args
                    foreach arch ${universal_archs_to_use} {
                        lappend merger_configure_args(${arch}) -DCMAKE_OSX_ARCHITECTURES=${arch}
                    }
                }
            } elseif {${cmake.set_osx_architectures}} {
                configure.universal_args-append \
                    -DCMAKE_OSX_ARCHITECTURES="[join ${configure.universal_archs} \;]"
            }
        } elseif {${cmake.set_osx_architectures}} {
            configure.args-append \
                -DCMAKE_OSX_ARCHITECTURES="${configure.build_arch}"
        }

        # Setting our own -arch flags is unnecessary (in the case of a non-universal build) or even
        # harmful (in the case of a universal build, because it causes the compiler identification to
        # fail; see http://public.kitware.com/pipermail/cmake-developers/2015-September/026586.html).
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
    # this PortGroup uses a custom CMAKE_BUILD_TYPE giving complete control over
    # the compiler flags. We use that here: replace the default -O2 with -O0, add
    # debugging options and do otherwise an exactly identical build.
    configure.cflags-replace         -O2 -O0
    configure.cxxflags-replace       -O2 -O0
    configure.objcflags-replace      -O2 -O0
    configure.objcxxflags-replace    -O2 -O0
    configure.ldflags-replace        -O2 -O0
    # get most if not all possible debug info
    configure.cflags-append         -g -fno-limit-debug-info -DDEBUG
    configure.cxxflags-append       -g -fno-limit-debug-info -DDEBUG
    configure.objcflags-append      -g -fno-limit-debug-info -DDEBUG
    configure.objcxxflags-append    -g -fno-limit-debug-info -DDEBUG
    configure.ldflags-append        -g -fno-limit-debug-info
    # try to ensure that info won't get stripped
    configure.args-append           -DCMAKE_STRIP:FILEPATH=/bin/echo
}

# cmake doesn't like --enable-debug, so in case a portfile sets
# --enable-debug (regardless of variant) we remove it
if {[string first "--enable-debug" ${configure.args}] > -1} {
    configure.args-delete     --enable-debug
}
