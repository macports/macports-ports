# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     cmake 1.1

namespace eval cmake {
    # our directory:
    variable currentportgroupdir [file dirname [dict get [info frame 0] file]]
}

options                             cmake.build_dir \
                                    cmake.source_dir \
                                    cmake.generator \
                                    cmake.generator_blacklist \
                                    cmake.build_type \
                                    cmake.install_prefix \
                                    cmake.install_rpath \
                                    cmake.module_path \
                                    cmake_share_module_dir \
                                    cmake.out_of_source \
                                    cmake.set_osx_architectures \
                                    cmake.set_c_standard \
                                    cmake.set_cxx_standard

## Explanation of and default values for the options defined above ##

# out-of-source builds are the default
default cmake.out_of_source         yes

# cmake.build_dir defines where the build will take place
default cmake.build_dir             {${workpath}/build}
# cmake.source_dir defines where CMake will look for the toplevel CMakeLists.txt file
default cmake.source_dir            {${worksrcpath}}

# set CMAKE_OSX_ARCHITECTURES when necessary.
# This can be deactivated when (non-Apple) compilers are used
# that don't support the corresponding -arch options.
default cmake.set_osx_architectures yes

# cmake.build_type defines the type of build; it defaults to "MacPorts"
# which means only the compiler options set through configure.c*flags and configure.optflags
# are used, plus those set in the port's CMake files. Alternative pre-defined types are
# Release, Debug, RelWithDebInfo and MinSizeRel; "None" should work like "MacPorts".
default cmake.build_type            MacPorts

# cmake-based ports may want to modify the install prefix
default cmake.install_prefix        {${prefix}}

# minimal/initial value for the install rpath:
default cmake.install_rpath         {${prefix}/lib}

# standard place to install extra CMake modules
default cmake_share_module_dir      {${prefix}/share/cmake/Modules}
# extra locations to search for modules can be specified with
# cmake.module_path; they come after ${cmake_share_module_dir}
default cmake.module_path           {}

# Propagate c/c++ standards to the build
default cmake.set_c_standard        no
default cmake.set_cxx_standard      no

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
# If ports package code that cannot be built with certain generators this
# fact can be signalled:
#
# cmake.generator_blacklist <generator-pattern>
# (patterns are case-insensitive, e.g. "*ninja*")
#
default cmake.generator             "CodeBlocks - Unix Makefiles"
default cmake.generator_blacklist   {}
# CMake generates Unix Makefiles that contain a special "fast" install target
# which skips the whole "let's see if there's anything left to (re)build before
# we install" you normally get with `make install`. That check should be
# redundant in normal destroot steps, because we just completed the build step.
default destroot.target             install/fast

## ############################################################### ##

# make sure cmake is available:
# can use cmake or cmake-devel; default to cmake if not installed
depends_build-append                path:bin/cmake:cmake


proc cmake::rpath_flags {} {
    global prefix
    if {[llength [option cmake.install_rpath]]} {
        # make sure a single ${cmake.install_prefix} is included in the rpath
        # careful, we are likely to be called more than once.
        if {"[option cmake.install_prefix]/lib" ni [option cmake.install_rpath]} {
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

proc cmake::framework_path {} {
    global prefix
    if {[option cmake.install_prefix] ne ${prefix}} {
        return [list \
                 -DCMAKE_FRAMEWORK_PATH="${prefix}/Library/Frameworks\;[option cmake.install_prefix]/Library/Frameworks\;/System/Library/Frameworks"
        ]
    } else {
        return [list \
                 -DCMAKE_FRAMEWORK_PATH="${prefix}/Library/Frameworks\;/System/Library/Frameworks"
        ]
    }
}

proc cmake::module_path {} {
    if {[llength [option cmake.module_path]]} {
        set modpath "[join [concat [option cmake_share_module_dir] [option cmake.module_path]] \;]"
    } else {
        set modpath [option cmake_share_module_dir]
    }
    return [list \
        -DCMAKE_MODULE_PATH="${modpath}" \
        -DCMAKE_PREFIX_PATH="${modpath}"
    ]
}

proc cmake::build_dir {} {
    if {[option cmake.out_of_source]} {
        return [option cmake.build_dir]
    }
    return [option cmake.source_dir]
}

option_proc cmake.generator cmake::handle_generator
proc cmake::handle_generator {option action args} {
    global cmake.generator destroot destroot.target build.cmd build.post_args
    global depends_build destroot.post_args build.jobs subport
    if {${action} eq "set"} {
        switch -glob [lindex ${args} 0] {
            "*Unix Makefiles*" {
                ui_debug "Selecting the 'Unix Makefiles' generator ($args)"
                depends_build-delete \
                                port:ninja
                build.cmd       make
                build.post_args VERBOSE=ON
                destroot.target install/fast
                destroot.destdir \
                                DESTDIR=${destroot}
                # unset the DESTDIR env. variable if it has been set before
                destroot.env-delete \
                                DESTDIR=${destroot}
            }
            "*Ninja" {
                ui_debug "Selecting the Ninja generator ($args)"
                depends_build-append \
                                port:ninja
                build.cmd       ninja
                # force Ninja to use the exact number of requested build jobs
                # Need to check use_parallel_build here, as build.jobs is still > 1
                # even if use_parallel_build=no ....
                set njobs ${build.jobs}
                if { ![option use_parallel_build] } {
                    set njobs 1
                }
                build.post_args -j${njobs} -v
                destroot.target install
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

default configure.dir {[cmake::build_dir]}
default build.dir {${configure.dir}}
default build.post_args VERBOSE=ON

# cache the configure.ccache variable (it will be overridden in the pre-configure step)
set cmake::ccache_cache ${configure.ccache}

# tell CMake to use ccache via the CMAKE_<LANG>_COMPILER_LAUNCHER variable
# and unset the global configure.ccache option which is not compatible
# with CMake.
# See https://stackoverflow.com/questions/1815688/how-to-use-ccache-with-cmake
proc cmake::ccaching {} {
    global prefix
    namespace upvar ::cmake ccache_cache cccache
    if {${cccache} && [file exists ${prefix}/bin/ccache]} {
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

# appropriate default settings for configure.pre_args
# variables are grouped thematically, with the more important ones
# at the beginning or end for somewhat easier at-a-glance verification.
# Policy 25=new: identify Apple Clang as AppleClang to ensure
#                consistency in compiler feature determination
# Policy 60=new: don't rewrite ${prefix}/lib/libfoo.dylib as -lfoo
default configure.pre_args {[list \
                    -DCMAKE_BUILD_TYPE=${cmake.build_type} \
                    -DCMAKE_INSTALL_PREFIX="${cmake.install_prefix}" \
                    -DCMAKE_INSTALL_NAME_DIR="${cmake.install_prefix}/lib" \
                    {*}[cmake::system_prefix_path] \
                    {*}[cmake::framework_path] \
                    {*}[cmake::ccaching] \
                    {-DCMAKE_C_COMPILER="$CC"} \
                    {-DCMAKE_CXX_COMPILER="$CXX"} \
                    {-DCMAKE_OBJC_COMPILER="$CC"} \
                    {-DCMAKE_OBJCXX_COMPILER="$CXX"} \
                    -DCMAKE_POLICY_DEFAULT_CMP0025=NEW \
                    -DCMAKE_POLICY_DEFAULT_CMP0060=NEW \
                    -DCMAKE_VERBOSE_MAKEFILE=ON \
                    -DCMAKE_COLOR_MAKEFILE=ON \
                    -DCMAKE_FIND_FRAMEWORK=LAST \
                    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
                    -DCMAKE_MAKE_PROGRAM=${build.cmd} \
                    {*}[cmake::module_path] \
                    {*}[cmake::rpath_flags] \
                    -Wno-dev
]}

# make sure configure.args is set but don't reset it
configure.args-append

default configure.post_args {[option cmake.source_dir]}

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
    # create the build directory as the first step
    file mkdir ${configure.dir}

    # check and bail early if we'd be using an incompatible cmake generator
    foreach genpattern ${cmake.generator_blacklist} {
        if {[string match -nocase ${genpattern} ${cmake.generator}]} {
            ui_error "port:${subport} doesn't support CMake's ${cmake.generator} generator"
            return -code error "unsupported CMake generator requested (port:${subport})"
        }
    }

    # The environment variable CPPFLAGS is not considered by CMake.
    # (CMake upstream ticket #12928 "Add support for CPPFLAGS environment variable"
    # <https://gitlab.kitware.com/cmake/cmake/-/issues/12928>).
    #
    # But adding -I${prefix}/include to CFLAGS/CXXFLAGS is a bad idea.
    # If any other flags are needed, we need to add them.

    # In addition, CMake provides build-type-specific flags for
    # Release (-O3 -DNDEBUG), Debug (-g), MinSizeRel (-Os -DNDEBUG), and
    # RelWithDebInfo (-O2 -g -DNDEBUG). If the configure.optflags have been
    # set (-Os by default), we have to remove the optimisation flags from
    # the concerned Release build type so that configure.optflags
    # gets honored (Debug used by the +debug variant does not set
    # optimisation flags by default).
    # We use a custom BUILD_TYPE (MacPorts) so we can simply append all desired
    # arguments to the CFLAGS and CXXFLAGS env. variables, which will be used
    # to set CMAKE_C_FLAGS and CMAKE_CXX_FLAGS, and those will control the build.
    if {![variant_isset debug]} {
        configure.cflags-append     -DNDEBUG
        configure.cxxflags-append   -DNDEBUG
    }

    # process ${configure.cppflags} because CMake ignores $CPPFLAGS
    if {${configure.cppflags} ne ""} {
        # copy the cppflags arguments one by one into cflags and family
        # CMake does have an INCLUDE_DIRECTORIES variable but setting it from the commandline
        # doesn't have the intended effect (any longer).
        configure.cflags-append     {*}${configure.cppflags}
        configure.cxxflags-append   {*}${configure.cppflags}
        # append to the ObjC flags too, even if CMake ignores them:
        configure.objcflags-append  {*}${configure.cppflags}
        configure.objcxxflags-append   {*}${configure.cppflags}
        ui_debug "CPPFLAGS=\"[join ${configure.cppflags}]\" inserted into CFLAGS=\"[join ${configure.cflags}]\" CXXFLAGS=\"[join ${configure.cxxflags}]\""
        # reset configure.cppflags; we don't want options in double in CPPFLAGS and CFLAGS/CXXFLAGS
        configure.cppflags
    }

    configure.pre_args-prepend -G \"[join ${cmake.generator}]\"
    # undo a counterproductive action from the debug PG:
    configure.args-delete -DCMAKE_BUILD_TYPE=debugFull

    # The configure.ccache variable has been cached so we can restore it in the post-configure
    # (pre-configure and post-configure are always run in a single `port` invocation.)
    configure.ccache        no
    # surprising but intended behaviour that's impossible to work around more gracefully:
    # overriding configure.ccache fails if the user set it directly from the commandline
    if {[tbool configure.ccache]} {
        ui_error "Please don't use configure.ccache=yes on the commandline for port:${subport}, use configureccache=yes"
        return -code error "invalid invocation (port:${subport})"
    }
    if {${cmake::ccache_cache}} {
        ui_info "        (using ccache)"
    }
}

post-configure {
    # restore configure.ccache:
    if {[info exists cmake::ccache_cache]} {
        configure.ccache    {*}${cmake::ccache_cache}
        ui_debug "configure.ccache restored to ${cmake::ccache_cache}"
    }
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

proc cmake.save_configure_cmd {{save_log_too ""}} {
    if {${save_log_too} ne ""} {
        pre-configure {
            configure.pre_args-prepend -cf '${configure.cmd}
            configure.post_args-append |& tee ${workpath}/.macports.${subport}.configure.log'
            configure.cmd /bin/csh
            ui_debug "configure command set to `[join [concat ${configure.cmd} ${configure.pre_args} ${configure.args} ${configure.post_args}]]`"
        }
    }
    post-configure {
        if {![catch {set fd [open "${workpath}/.macports.${subport}.configure.cmd" "w"]} err]} {
            foreach var [array names ::env] {
                puts ${fd} "${var}=$::env(${var})"
            }
            puts ${fd} [join ${configure.env} \n]
            # the following variables are no longer set in the environment at this point:
            puts ${fd} CPP=\"[join ${configure.cpp}]\"
            # these are particularly relevant because referenced in the configure.pre_args:
            puts ${fd} CC=\"[join ${configure.cc}]\"
            puts ${fd} CXX=\"[join ${configure.cxx}]\"
            if {${configure.objcxx} ne ${configure.cxx}} {
                puts ${fd} OBJCXX=\"[join ${configure.objcxx}]\"
            }
            puts ${fd} CFLAGS=\"[join ${configure.cflags}]\"
            puts ${fd} CXXFLAGS=\"[join ${configure.cxxflags}]\"
            if {${configure.objcflags} ne ${configure.cflags}} {
                puts ${fd} OBJCFLAGS=\"[join ${configure.objcflags}]\"
            }
            if {${configure.objcxxflags} ne ${configure.cxxflags}} {
                puts ${fd} OBJCXXFLAGS=\"[join ${configure.objcxxflags}]\"
            }
            puts ${fd} LDFLAGS=\"[join ${configure.ldflags}]\"
            if {${configure.optflags} ne ""} {
                puts ${fd} configure.optflags=\"[join ${configure.optflags}]\"
            }
            puts ${fd} "\ncd ${worksrcpath}"
            puts ${fd} "[join [concat ${configure.cmd} ${configure.pre_args} ${configure.args} ${configure.post_args}]]"
            close ${fd}
            unset fd
        }
        if {[file exists ${build.dir}/CMakeCache.txt]} {
            # keep a backup of the CMake cache file
            file copy -force ${build.dir}/CMakeCache.txt ${build.dir}/CMakeCache-MacPorts.txt
        }
    }
}

platform darwin {
    set cmake._archflag_vars [list cc_archflags cxx_archflags ld_archflags objc_archflags objcxx_archflags \
        universal_cflags universal_cxxflags universal_ldflags universal_objcflags universal_objcxxflags]
    pre-configure {
        # cmake will add the correct -arch flag(s) based on the value of CMAKE_OSX_ARCHITECTURES.
        if {[variant_exists universal] && [variant_isset universal]} {
            if {[info exists muniversal.arch_flag]} {
                foreach arch ${muniversal.architectures} {
                    configure.args.${arch}-append -DCMAKE_OSX_ARCHITECTURES=${arch}
                }
            } elseif {[info exists universal_archs_supported]} {
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

        # C/C++ standard
        if {[option cmake.set_cxx_standard] && ${compiler.cxx_standard} ne ""} {
            # https://cmake.org/cmake/help/latest/prop_tgt/CXX_STANDARD.html
            if {${compiler.cxx_standard} < 1998} {
                compiler.cxx_standard 1998
            }
            configure.args-append -DCMAKE_CXX_STANDARD=[string range ${compiler.cxx_standard} end-1 end]
        }
        if {[option cmake.set_c_standard] && ${compiler.c_standard} ne ""} {
            # Base defaults to 1989 which is not valid as a C standard
            # (at least as far as CMake is concerned)
            # https://cmake.org/cmake/help/latest/prop_tgt/C_STANDARD.html#prop_tgt:C_STANDARD
            if {${compiler.c_standard} < 1990} {
                compiler.c_standard 1990
            }
            configure.args-append -DCMAKE_C_STANDARD=[string range ${compiler.c_standard} end-1 end]
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

        configure.args-append -DCMAKE_OSX_SYSROOT="${configure.sysroot}"
    }
    post-configure {
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
    pre-configure {
        # this PortGroup uses a custom CMAKE_BUILD_TYPE giving complete control over
        # the compiler flags. We use that here: replace the default -O2 with -O0, add
        # debugging options and do otherwise an exactly identical build.
        configure.cflags-replace         -O2 -O0
        configure.cxxflags-replace       -O2 -O0
        configure.objcflags-replace      -O2 -O0
        configure.objcxxflags-replace    -O2 -O0
        configure.ldflags-replace        -O2 -O0
        # get most if not all possible debug info
        if {[string match *clang* [file tail ${configure.cxx}]] || [string match *clang* [file tail ${configure.cc}]]} {
            set cmake::debugopts [list -g -fno-limit-debug-info -DDEBUG]
        } else {
            set cmake::debugopts [list -g -DDEBUG]
        }
        configure.cflags-append         {*}${cmake::debugopts}
        configure.cxxflags-append       {*}${cmake::debugopts}
        configure.objcflags-append      {*}${cmake::debugopts}
        configure.objcxxflags-append    {*}${cmake::debugopts}
        configure.ldflags-append        {*}${cmake::debugopts}
        # try to ensure that info won't get stripped
        configure.args-append           -DCMAKE_STRIP:FILEPATH=/bin/echo
    }
}
