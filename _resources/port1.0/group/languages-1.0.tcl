# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2015-2017 The MacPorts Project
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
# 3. Neither the name of The MacPorts Project nor the names of its
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
# Usage:
#
#   PortGroup                 languages 1.0
#   compiler.c_standard       Standard for the C programming language
#                             Values: 1989 (Default), 1999, 2011
#   compiler.cxx_standard     Standard for the C++ programming language
#                             Values: 1998 (Default), 2011, 2014, 2017
#   compiler.require_fortran  Is a Fortran compiler required?
#                             Values: no (Default), yes
#
# This PortGroup sets the compiler, compiler dependencies,
#    and the C++ standard library switches.
#
# Ideally the functionality of this PortGroup should be integrated into
# MacPorts base as a new option.

options \
    compiler.c_standard       \
    compiler.cxx_standard     \
    compiler.require_fortran

compiler.c_standard       1989
compiler.cxx_standard     1998
compiler.require_fortran  no

# internal function to determine the latest GCC version to use for Fortran
proc portconfigure::get_gcc_fortran_version {} { return 7 }

# replacement for portconfigure.tcl version
proc portconfigure::get_compiler_fallback {} {
    global                     \
        xcodeversion           \
        default_compilers      \
        compiler.c_standard    \
        compiler.cxx_standard  \
        os.major               \
        cxx_stdlib

    # Check our override
    if {[info exists default_compilers]} {
        return $default_compilers
    }

    # Check for platforms without Xcode
    if {$xcodeversion eq "none" || $xcodeversion eq ""} {
        return {cc}
    }

    # http://releases.llvm.org/3.1/docs/ClangReleaseNotes.html#cchanges
    # https://gcc.gnu.org/c99status.html
    # https://gcc.gnu.org/wiki/C11Status
    #
    # 1989 (C89)   |     -     |   -       |    -      |
    # 1999 (C99)   |     -     | Xcode 4.2 | GCC 4.5   |
    # 2011 (C11)   | Clang 3.1 | Xcode 4.3 | GCC 4.9   |
    #
    # https://clang.llvm.org/cxx_status.html
    # https://gcc.gnu.org/projects/cxx-status.html
    # http://en.cppreference.com/w/cpp/compiler_support
    #
    # 1998 (C++98) |    -      |   -       |     -     |
    # 2011 (C++11) | Clang 3.3 | Xcode 5   | GCC 4.8.1 |
    # 2014 (C++14) | Clang 3.4 | Xcode 5.1 | GCC 5     |
    # 2017 (C++17) | Clang 5   | Xcode ??? | GCC 7     |
    #
    if {[vercmp ${xcodeversion} 4.2] < 0} {
        set default_xcode_ok [expr ${compiler.c_standard} <= 1989 && ${compiler.cxx_standard} <= 1998]
    } elseif {[vercmp ${xcodeversion} 4.3] < 0} {
        set default_xcode_ok [expr ${compiler.c_standard} <= 1999 && ${compiler.cxx_standard} <= 1998]
    } elseif {[vercmp ${xcodeversion} 5] < 0} {
        set default_xcode_ok [expr ${compiler.c_standard} <= 2011 && ${compiler.cxx_standard} <= 1998]
    } elseif {[vercmp ${xcodeversion} 5.1] < 0} {
        set default_xcode_ok [expr ${compiler.c_standard} <= 2011 && ${compiler.cxx_standard} <= 2011]
    } else {
        set default_xcode_ok [expr ${compiler.c_standard} <= 2011 && ${compiler.cxx_standard} <= 2014]
    }

    # check for non-default cases
    if {${default_xcode_ok}} {
        if {${cxx_stdlib} eq "libstdc++"} {
            set default_xcode_ok [expr ${os.major} <  13]
        } else {
            set default_xcode_ok [expr ${os.major} >= 13]
        }
    }

    # https://developer.apple.com/library/content/releasenotes/DeveloperTools/RN-Xcode/Chapters/Introduction.html
    # https://developer.apple.com/library/content/documentation/CompilerTools/Conceptual/LLVMCompilerOverview/index.html
    # Xcode 3.2 relase notes (Link?)
    # About Xcode 3.1 Tools (about_xcode_tools_3.1.pdf, Link?)
    # About Xcode 3.2 (about_xcode_3.2.pdf, Link?)
    #
    # Xcode 5 does not support use of the LLVM-GCC compiler and the GDB debugger.
    # From Xcode 4.2, Clang is the default compiler for Mac OS X.
    # llvm-gcc4.2 is now the default system compiler in Xcode 4.
    # The LLVM compiler is the next-generation compiler, introduced in Xcode 3.2
    # GCC 4.0 has been removed from Xcode 4.
    #
    if {!${default_xcode_ok}} {
        set compilers ""
    } else {
        # attempt to include all available compilers except gcc-3*
        # attempt to have the default compilers first
        if {[vercmp ${xcodeversion} 5] >= 0} {
            set compilers {clang}
        } elseif {[vercmp ${xcodeversion} 4.2] >= 0} {
            set compilers {clang llvm-gcc-4.2}
        } elseif {[vercmp ${xcodeversion} 4.0] >= 0} {
            set compilers {llvm-gcc-4.2 clang gcc-4.2}
        } else {
            # Legacy Cases
            if {[string match *10.4u* [option configure.sdkroot]]} {
                # from Xcode 3.2 release notes:
                #    GCC 4.2 cannot be used with the Mac OS X 10.4u SDK.
                #    If you want to build targets using the 10.4u SDK on Xcode 3.2, you must set the Compiler Version to GCC 4.0
                set compilers {gcc-4.0}
            } else {
                if {[vercmp ${xcodeversion} 3.2] >= 0} {
                    # from about_xcode_3.2.pdf:
                    #    GCC 4.2 is the primary system compiler for the 10.6 SDK
                    set compilers {gcc-4.2 llvm-gcc-4.2 gcc-4.0}
                } elseif {[vercmp ${xcodeversion} 3.1] >= 0} {
                    # from about_xcode_tools_3.1.pdf:
                    #     GCC 4.2 & LLVM GCC 4.2 optional compilers
                    # do not assume they exist (???)
                    set compilers {apple-gcc-4.2 gcc-4.0}
                } else {
                    set compilers {apple-gcc-4.2 gcc-4.0}
                }
            }
        }
    }

    set gcc_compilers macports-gcc-7
    if {${compiler.cxx_standard} < 2017} {
        # allow latest GCC to be blacklisted by ports
        # see https://trac.macports.org/ticket/54215#comment:36
        lappend gcc_compilers macports-gcc-6
        lappend gcc_compilers macports-gcc-5
    }

    # does Clang work on all i386 and x86_64 systems?
    # according to http://packages.macports.org/clang-5.0/,
    #    clang builds back to Mac OS X 10.6
    set clang_compilers macports-clang-5.0
    if {${compiler.cxx_standard} < 2017} {
        # allow latest Clang to be blacklisted by ports
        lappend clang_compilers macports-clang-4.0
        if {${os.major} < 17} {
            # The High Sierra SDK requires a toolchain that can apply nullability to uuid_t
            lappend clang_compilers macports-clang-3.9
        }
        if {${os.major} < 16} {
            # The Sierra SDK requires a toolchain that supports class properties
            lappend clang_compilers macports-clang-3.8 macports-clang-3.7
        }
    }

    if {${cxx_stdlib} eq "libstdc++"} {
        # when building for PowerPC architectures, prefer GCC to Clang
        if {[option configure.build_arch] eq "ppc" || [option configure.build_arch] eq "ppc64"} {
            lappend compilers {*}${gcc_compilers}
            lappend compilers {*}${clang_compilers}
        } else {
            lappend compilers {*}${clang_compilers}
            lappend compilers {*}${gcc_compilers}
        }
    } else {
        # only Clang compilers recognize libc++
        lappend compilers {*}${clang_compilers}
    }

    return $compilers
}

# extension of portconfigure.tcl version
rename portconfigure::configure_get_compiler portconfigure::configure_get_compiler_real
proc portconfigure::configure_get_compiler {type {compiler {}}} {
    set ret_real [portconfigure::configure_get_compiler_real ${type} ${compiler}]

    global prefix

    if {[option compiler.require_fortran]} {
        foreach tool {f77 f90 fc} {
            if {${type} eq ${tool} && ${ret_real} eq ""} {
                return ${prefix}/bin/gfortran-mp-[portconfigure::get_gcc_fortran_version]
            }
        }
    }

    return ${ret_real}
}

# replacement for portconfigure.tcl version
proc portconfigure::add_automatic_compiler_dependencies {} {
    global configure.compiler configure.compiler.add_deps

    if {!${configure.compiler.add_deps}} {
        return
    }

    # The default value requires substitution before use.
    set compiler [subst ${configure.compiler}]

    if {[compiler_is_port ${compiler}]} {
        ui_debug "Chosen compiler ${compiler} is provided by a port, adding dependency"
        portconfigure::add_compiler_port_dependencies ${compiler}
    }

    if {[option compiler.require_fortran] && [portconfigure::configure_get_compiler_real fc ${compiler}] eq ""} {
        ui_debug "Adding Fortran compiler dependency"
        portconfigure::add_compiler_port_dependencies macports-gcc-[portconfigure::get_gcc_fortran_version]
    }
}

# helper function to add dependencies for a given compiler
proc portconfigure::add_compiler_port_dependencies {compiler} {
    global os.major

    set compiler_port [portconfigure::compiler_port_name ${compiler}]
    if {[regexp {^apple-gcc-(4\.0)$} $compiler -> gcc_version]} {
        # compiler links against ${prefix}/lib/apple-gcc40/lib/libgcc_s.1.dylib
        ui_debug "Adding depends_lib port:$compiler_port"
        depends_lib-delete port:$compiler_port
        depends_lib-append port:$compiler_port
    } else {
        ui_debug "Adding depends_build port:$compiler_port"
        depends_build-delete port:$compiler_port
        depends_build-append port:$compiler_port

        # add C++ runtime dependency if necessary
        if {
            [regexp {^macports-gcc-(\d+(?:\.\d+)?)?$} ${compiler} -> gcc_version]
            ||
            [regexp {^macports-dragonegg-(\d+\.\d+)(?:-gcc-(\d+\.\d+))?$} ${compiler} -> llvm_version gcc_version]
        } {
            if {[info exists llvm_version] && ${gcc_version} eq ""} {
                # port dragonegg-3.4 defaults to GCC version 4.6
                set gcc_version 4.6
            }
            # compiler links against libraries in libgcc\d* and/or libgcc-devel
            if {[vercmp ${gcc_version} 4.6] < 0} {
                set libgccs "path:lib/libgcc/libgcc_s.1.dylib:libgcc port:libgcc6 port:libgcc45"
            } elseif {[vercmp ${gcc_version} 7] < 0} {
                set libgccs "path:lib/libgcc/libgcc_s.1.dylib:libgcc port:libgcc6"
            } else {
                set libgccs "path:lib/libgcc/libgcc_s.1.dylib:libgcc"
            }
            ui_debug "Adding depends_build port:$compiler_port"
            depends_build-delete port:$compiler_port
            depends_build-append port:$compiler_port
            foreach libgcc_dep $libgccs {
                ui_debug "Adding depends_lib $libgcc_dep"
                depends_lib-delete $libgcc_dep
                depends_lib-append $libgcc_dep
            }
        } elseif {[regexp {^macports-clang(?:-(\d+\.\d+))$} $compiler -> clang_version]} {
            if {[option configure.cxx_stdlib] eq "macports-libstdc++"} {
                # see https://trac.macports.org/ticket/54766
                ui_debug "Adding depends_lib path:lib/libgcc/libgcc_s.1.dylib:libgcc"
                depends_lib-delete "path:lib/libgcc/libgcc_s.1.dylib:libgcc"
                depends_lib-append "path:lib/libgcc/libgcc_s.1.dylib:libgcc"
            } elseif {[option configure.cxx_stdlib] eq "libc++"} {
                if {${os.major} < 11 } {
                    # libc++ does not exist on these systems
                    ui_debug "Adding depends_lib libcxx"
                    depends_lib-delete "port:libcxx"
                    depends_lib-append "port:libcxx"
                }
            }
        }
    }

    if {[arch_flag_supported $compiler]} {
        ui_debug "Adding depends_skip_archcheck $compiler_port"
        depends_skip_archcheck-delete $compiler_port
        depends_skip_archcheck-append $compiler_port
    }
}

# replacement for portconfigure.tcl version
default configure.cxx_stdlib            {[portconfigure::configure_cxx_stdlib]}

# helper function to set configure.cxx_stdlib
proc portconfigure::configure_cxx_stdlib {} {
    global cxx_stdlib

    set is_macports_clang [string match *clang++-mp-* [option configure.cxx]]

    if {${is_macports_clang} && ${cxx_stdlib} eq "libstdc++" && [option compiler.cxx_standard] >= 2011} {
        return "macports-libstdc++"
    } else {
        return ${cxx_stdlib}
    }
}

proc portconfigure::should_add_libstdlib_abi {} {
    global os.major cxx_stdlib
    # prior to OS X Mavericks, libstdc++ was the default C++ runtime, so
    #    assume MacPorts libstdc++ must be ABI compatable with system libstdc++
    # for OS X Maverick and above, users must select libstdc++, so
    #    assume they want default ABI compatibility
    # see https://gcc.gnu.org/onlinedocs/gcc-5.2.0/libstdc++/manual/manual/using_dual_abi.html
    return [expr {${cxx_stdlib} eq "libstdc++" && [option compiler.cxx_standard] >= 2011 && ${os.major} < 13}]
}

# replacement for portconfigure.tcl version
proc portconfigure::construct_cxxflags {flags} {
    if {[portconfigure::should_add_stdlib]} {
        lappend flags -stdlib=[option configure.cxx_stdlib]
    }
    if {[portconfigure::should_add_libstdlib_abi]} {
        lappend flags -D_GLIBCXX_USE_CXX11_ABI=0
    }
    return $flags
}

# replacement for portconfigure.tcl version
proc portconfigure::stdlib_trace {opt action args} {
    foreach flag [lsearch -all -inline [option $opt] -stdlib=*] {
        $opt-delete $flag
    }
    if {$action eq "read" && [portconfigure::should_add_stdlib]} {
        $opt-append -stdlib=[option configure.cxx_stdlib]
    }
    foreach flag [lsearch -all -inline [option $opt] -D_GLIBCXX_USE_CXX11_ABI=0] {
        $opt-delete $flag
    }
    if {$action eq "read" && [portconfigure::should_add_libstdlib_abi]} {
        $opt-append -D_GLIBCXX_USE_CXX11_ABI=0
    }
}

# replacement for portutil.tcl version
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
    } elseif {
              [regexp {^macports-gcc-(\d+(?:\.\d+)?)?$} [option configure.compiler] -> gcc_version]
              ||
              [regexp {^macports-dragonegg-(\d+\.\d+)(?:-gcc-(\d+\.\d+))?$} [option configure.compiler] -> llvm_version gcc_version]
          } {
        ui_debug "Compiler doesn't support universal builds, so not adding the default universal variant"
    } else {
        ui_debug "adding the default universal variant"
        variant universal {}
    }
}
