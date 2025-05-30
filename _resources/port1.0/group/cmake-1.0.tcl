# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     cmake 1.0

options cmake.build_dir cmake.install_prefix cmake.out_of_source

default cmake.build_dir         {${workpath}/build}
default cmake.install_prefix    {${prefix}}
default cmake.out_of_source     no

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

# cache the configure.ccache variable (it will be overridden in the pre-configure step)
set cmake_ccache    ${configure.ccache}

# tell CMake to use ccache via the CMAKE_<LANG>_COMPILER_LAUNCHER variable
# and unset the global configure.ccache option which is not compatible
# with CMake.
# See https://stackoverflow.com/questions/1815688/how-to-use-ccache-with-cmake
proc cmake_ccaching_flags {} {
    global prefix
    upvar cmake_ccache ccache
    if {${ccache} && [file exists ${prefix}/bin/ccache]} {
        return [list \
            -DCMAKE_C_COMPILER_LAUNCHER=${prefix}/bin/ccache \
            -DCMAKE_CXX_COMPILER_LAUNCHER=${prefix}/bin/ccache \
            -DCMAKE_Fortran_COMPILER_LAUNCHER=${prefix}/bin/ccache \
            -DCMAKE_OBJC_COMPILER_LAUNCHER=${prefix}/bin/ccache \
            -DCMAKE_OBJCXX_COMPILER_LAUNCHER=${prefix}/bin/ccache \
            -DCMAKE_ISPC_COMPILER_LAUNCHER=${prefix}/bin/ccache ]
    }
}

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
                   {*}[cmake_ccaching_flags] \
                   {-DCMAKE_C_COMPILER="$CC"} \
                    -DCMAKE_COLOR_MAKEFILE=ON \
                   {-DCMAKE_CXX_COMPILER="$CXX"} \
                    -DCMAKE_FIND_FRAMEWORK=LAST \
                    -DCMAKE_INSTALL_NAME_DIR=${cmake.install_prefix}/lib \
                    -DCMAKE_INSTALL_RPATH=${cmake.install_prefix}/lib \
                    -DCMAKE_MAKE_PROGRAM=${build.cmd} \
                    -DCMAKE_MODULE_PATH=${cmake_share_module_dir} \
                    -DCMAKE_SYSTEM_PREFIX_PATH="${cmake.install_prefix}\;${prefix}\;/usr" \
                    -DCMAKE_FRAMEWORK_PATH="${cmake.install_prefix}/Library/Frameworks\;${prefix}/Library/Frameworks\;/Library/Frameworks\;/System/Library/Frameworks" \
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
    # (CMake upstream ticket #12928 "Add support for CPPFLAGS environment variable"
    # <https://gitlab.kitware.com/cmake/cmake/-/issues/12928>).
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

        if {${configure.sdkroot} ne ""} {
            configure.args-append -DCMAKE_OSX_SYSROOT="${configure.sdkroot}"
        } else {
            configure.args-append -DCMAKE_OSX_SYSROOT="/"
        }

        # The configure.ccache variable has been cached so we can restore it in the post-configure
        # (pre-configure and post-configure are always run in a single `port` invocation.)
        configure.ccache        no
        # surprising but intended behaviour that's impossible to work around more gracefully:
        # overriding configure.ccache fails if the user set it directly from the commandline
        if {[tbool configure.ccache]} {
            ui_error "Please don't use configure.ccache=yes on the commandline for port:${subport}, use configureccache=yes"
            return -code error "invalid invocation (port:${subport})"
        }
        if {${cmake_ccache}} {
            ui_info "        (using ccache)"
        }
    }

    post-configure {
        # restore configure.ccache:
        if {[info exists cmake_ccache]} {
            configure.ccache    ${cmake_ccache}
            ui_debug "configure.ccache restored to ${cmake_ccache}"
        }
        # Although cmake wants us not to set -arch flags ourselves when we run cmake,
        # ports might have need to access these variables at other times.
        foreach archflag_var ${cmake._archflag_vars} {
            global cmake._saved_${archflag_var}
            configure.${archflag_var} {*}[set cmake._saved_${archflag_var}]
        }
    }
}

configure.universal_args-delete --disable-dependency-tracking

variant debug description "Enable debug binaries" {
    configure.args-replace  -DCMAKE_BUILD_TYPE=Release -DCMAKE_BUILD_TYPE=Debug
}

default build.dir {${configure.dir}}

default build.post_args VERBOSE=ON

# Generated Unix Makefiles contain a "fast" install target that begins
# installing immediately instead of checking build dependencies again.
default destroot.target install/fast
