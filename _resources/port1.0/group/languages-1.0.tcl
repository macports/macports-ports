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
#   PortGroup                  languages 1.0
#
#   compiler.c_standard        Standard for the C programming language
#                              Values: 1989 (Default), 1999, 2011
#
#   compiler.cxx_standard      Standard for the C++ programming language
#                              Values: 1998 (Default), 2011, 2014, 2017
#
#   compiler.require_fortran   Is a Fortran compiler required?
#                              Values: no (Default), yes
#
#   compiler.fortran_fallback  If Fortran is required and is not provides by compiler,
#                                  list of compilers to use
#                              Devault value is the Fortran compilers in compiler.fallback
#
#   compiler.openmp_version   Version of OpenMP required (blank for none)
#                             Values: blank (Default) 2.5, 3.0, 3.1, 4.0, 4.5
#
#   compiler.mpi              MacPorts port that provides MPI
#                             Values: blank (Default), mpich, openmpi
#
# This PortGroup sets the compiler, compiler dependencies,
#    and the C++ standard library switches.
#
# Ideally the functionality of this PortGroup should be integrated into
# MacPorts base as a new option.

options                        \
    compiler.c_standard        \
    compiler.cxx_standard      \
    compiler.require_fortran   \
    compiler.fortran_fallback  \
    compiler.openmp_version    \
    compiler.mpi

default compiler.c_standard        1989
default compiler.cxx_standard      1998
default compiler.require_fortran   no
default compiler.fortran_fallback  {[portconfigure::get_fortran_fallback]}
default compiler.openmp_version    {}
default compiler.mpi               {}

# replacement for portconfigure.tcl version
proc portconfigure::configure_start {args} {
    global UI_PREFIX

    ui_notice "$UI_PREFIX [format [msgcat::mc "Configuring %s"] [option subport]]"

    set compiler [option configure.compiler]
    set valid_compilers {
        {^apple-gcc-(4\.[02])$}             {MacPorts Apple GCC %s}
        {^cc$}                              {System cc}
        {^clang$}                           {Xcode Clang}
        {^gcc$}                             {System GCC}
        {^gcc-(3\.3|4\.[02])$}              {Xcode GCC %s}
        {^llvm-gcc-4\.2$}                   {Xcode LLVM-GCC 4.2}
        {^macports-clang$}                  {MacPorts Clang (port select)}
        {^macports-clang-(\d+\.\d+)$}       {MacPorts Clang %s}
        {^macports-dragonegg-(\d+\.\d+)$}   {MacPorts DragonEgg %s}
        {^macports-dragonegg-(\d+\.\d+)-gcc-(\d+\.\d+)$}
            {MacPorts DragonEgg %s with GCC %s}
        {^macports-gcc$}                    {MacPorts GCC (port select)}
        {^macports-gcc-(\d+(?:\.\d+)?)$}    {MacPorts GCC %s}
        {^macports-llvm-gcc-4\.2$}          {MacPorts LLVM-GCC 4.2}
        {^macports-g95$}                    {MacPorts G95}
        {^macports-mpich-clang$}
            {MacPorts MPICH Wrapper for Xcode Clang}
        {^macports-openmpi-clang$}
            {MacPorts Open MPI Wrapper for Xcode Clang}
        {^macports-mpich-clang-(\d+\.\d+)$}
            {MacPorts MPICH Wrapper for Clang %s}
        {^macports-openmpi-clang-(\d+\.\d+)$}
            {MacPorts Open MPI Wrapper for Clang %s}
        {^macports-mpich-gcc-(\d+(?:\.\d+)?)$}
            {MacPorts MPICH Wrapper for GCC %s}
        {^macports-openmpi-gcc-(\d+(?:\.\d+)?)$}
            {MacPorts Open MPI Wrapper for GCC %s}
    }
    foreach {re fmt} $valid_compilers {
        if {[set matches [regexp -inline $re $compiler]] ne ""} {
            set compiler_name [format $fmt {*}[lrange $matches 1 end]]
            break
        }
    }
    if {![info exists compiler_name]} {
        return -code error "Invalid value for configure.compiler: $compiler"
    }
    ui_debug "Preferred compilers: [option compiler.fallback]"
    ui_debug "Using compiler '$compiler_name'"

    # Additional ccache directory setup
    global configure.ccache ccache_dir ccache_size macportsuser
    if {${configure.ccache}} {
        # Create ccache directory with correct permissions with root privileges
        elevateToRoot "configure ccache"
        if {[catch {
                file mkdir ${ccache_dir}
                file attributes ${ccache_dir} -owner ${macportsuser} -permissions 0755
            } result]} {
            ui_warn "ccache_dir ${ccache_dir} could not be created; disabling ccache: $result"
            set configure.ccache no
        }
        dropPrivileges

        # Initialize ccache directory with the given maximum size
        if {${configure.ccache}} {
            if {[catch {
                exec ccache -M ${ccache_size} >/dev/null
            } result]} {
                ui_warn "ccache_dir ${ccache_dir} could not be initialized; disabling ccache: $result"
                set configure.ccache no
            }
        }
    }
}

# replacement for portconfigure.tcl version
proc portconfigure::get_compiler_fallback {} {
    global                       \
        default_compilers        \
        xcodeversion

    # Check our override
    if {[info exists default_compilers]} {
        return $default_compilers
    }

    # Check for platforms without Xcode
    if {$xcodeversion eq "none" || $xcodeversion eq ""} {
        return {cc}
    }

    return [portconfigure::get_valid_compilers]
}

# if full_list is yes, then get all possible possible compiler that might work on this configuration
# if full_list is no, reducde the compiler list to the "best" compilers
proc portconfigure::get_valid_compilers {{full_list no}} {
    global                       \
        xcodeversion             \
        compiler.c_standard      \
        compiler.cxx_standard    \
        compiler.openmp_version  \
        os.major                 \
        cxx_stdlib

    # https://releases.llvm.org/3.1/docs/ClangReleaseNotes.html#cchanges
    # https://gcc.gnu.org/c99status.html
    # https://gcc.gnu.org/wiki/C11Status
    #
    # 1989 (C89)   |     -     |   -       |    -      |
    # 1999 (C99)   |     -     | Xcode 4.2 | GCC 4.5   |
    # 2011 (C11)   | Clang 3.1 | Xcode 4.3 | GCC 4.9   |
    #
    # https://clang.llvm.org/cxx_status.html
    # https://gcc.gnu.org/projects/cxx-status.html
    # https://en.cppreference.com/w/cpp/compiler_support
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

    if {${cxx_stdlib} eq "libstdc++" && ${os.major} >= 13} {
        # user has changed the default value of cxx_stdlib
        # for C++11 applications, MacPorts compilers are required
        set default_xcode_ok 0
    }

    if {${cxx_stdlib} eq "libc++" && ${os.major} < 11} {
        # user has changed the default value of cxx_stdlib
        # only Clang compilers use libc++
        set default_xcode_ok 0
    }

    # for 11 <= ${os.major} && ${os.major} < 13,
    # user has changed the default value of cxx_stdlib, but Xcode clang can still use libc++

    # Xcode compilers do not support OpenMP
    if {${compiler.openmp_version} ne ""} {
        set default_xcode_ok 0
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
            if {${cxx_stdlib} eq "libstdc++"} {
                set compilers {clang llvm-gcc-4.2}
            } else {
                set compilers {clang}
            }
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

    # https://openmp.llvm.org
    # https://gcc.gnu.org/wiki/openmp
    #
    # OpenMP Version | Clang Version | GCC Version
    #      2.5       |      3.8      |     4.2
    #      3.0       |      3.8      |     4.4
    #      3.1       |      3.8      |     4.7
    #      4.0       |    Partial    |     4.9
    #      4.5       |    Partial    |     ???
    #
    set gcc_compilers macports-gcc-7
    if {${compiler.cxx_standard} < 2017} {
        # allow latest GCC to be blacklisted by ports
        # see https://trac.macports.org/ticket/54215#comment:36
        lappend gcc_compilers macports-gcc-6
        lappend gcc_compilers macports-gcc-5
    }

    # does Clang work on all i386 and x86_64 systems?
    # according to https://packages.macports.org/clang-5.0/,
    #    clang builds back to Mac OS X 10.6
    set clang_compilers macports-clang-5.0
    if {${compiler.cxx_standard} < 2017 && [vercmp ${compiler.openmp_version} 4] < 0} {
        # allow latest Clang to be blacklisted by ports
        lappend clang_compilers macports-clang-4.0
        if {${os.major} < 17} {
            # The High Sierra SDK requires a toolchain that can apply nullability to uuid_t
            lappend clang_compilers macports-clang-3.9
        }
        if {${os.major} < 16} {
            # The Sierra SDK requires a toolchain that supports class properties
            lappend clang_compilers macports-clang-3.8

            if {[expr [vercmp ${compiler.openmp_version} 0] <= 0]} {
                lappend clang_compilers macports-clang-3.7
            }
        }
    }

    if {${cxx_stdlib} eq "libc++"} {
        # only Clang compilers recognize libc++
        lappend compilers {*}${clang_compilers}

        # Clang does not provide Fortran compiler
        if {[option compiler.require_fortran]} {
            lappend compilers {*}${gcc_compilers}
        }
    } else {
        # when building for PowerPC architectures, prefer GCC to Clang
        if {[option configure.build_arch] eq "ppc" || [option configure.build_arch] eq "ppc64"} {
            lappend compilers {*}${gcc_compilers}
            lappend compilers {*}${clang_compilers}
        } else {
            lappend compilers {*}${clang_compilers}
            lappend compilers {*}${gcc_compilers}
        }
    }

    if {[option compiler.require_fortran]} {
        lappend compilers macports-g95
    }

    # generate list of MPI wrappers of current compilers
    set mpi_compilers {}
    if {[option compiler.mpi] ne ""} {
        set mpis [option compiler.mpi]
    } else {
        set mpis {mpich openmpi}
    }
    foreach mpi ${mpis} {
        foreach c ${compilers} {
            set parts [split ${c} -]
            if {[lindex ${parts} 0] eq "clang"} {
                lappend mpi_compilers macports-${mpi}-[lindex ${parts} 0]
            } elseif {[lindex ${parts} 0] eq "macports"} {
                if {
                    [lindex ${parts} 1] eq "clang"
                    &&
                    [vercmp [lindex ${parts} 2] 3.3] >= 0
                } {
                    lappend mpi_compilers [lindex ${parts} 0]-${mpi}-[lindex ${parts} 1]-[lindex ${parts} 2]
                } elseif {
                          [lindex ${parts} 1] eq "gcc"
                          &&
                          [vercmp [lindex ${parts} 2] 4.3] >= 0
                      } {
                    lappend mpi_compilers [lindex ${parts} 0]-${mpi}-[lindex ${parts} 1]-[lindex ${parts} 2]
                }
            }
        }
    }

    # if required, replace compiler with equivalent MPI wrapper
    if {[option compiler.mpi] ne ""} {
        # only MPI compilers are valid
        set compilers ${mpi_compilers}
    } elseif {${full_list}} {
        # MPI compilers could work, so include it in the full list
        lappend compilers {*}${mpi_compilers}
    }

    return $compilers
}

# replacement for portconfigure.tcl version
proc portconfigure::compiler_port_name {compiler} {
    set valid_compiler_ports {
        {^apple-gcc-(\d+)\.(\d+)$}                          {apple-gcc%s%s}
        {^macports-clang-(\d+\.\d+)$}                       {clang-%s}
        {^macports-dragonegg-(\d+\.\d+)(-gcc-\d+\.\d+)?$}   {dragonegg-%s%s}
        {^macports-(llvm-)?gcc-(\d+)(?:\.(\d+))?$}          {%sgcc%s%s}
        {^macports-([^-]+)-clang$}                          {%s-clang}
        {^macports-([^-]+)-clang-(\d+)\.(\d+)$}             {%s-clang%s%s}
        {^macports-([^-]+)-gcc-(\d+)(?:\.(\d+))?$}          {%s-gcc%s%s}
        {^macports-g95$}                                    {g95}
    }
    foreach {re fmt} $valid_compiler_ports {
        if {[set matches [regexp -inline $re $compiler]] ne ""} {
            return [format $fmt {*}[lrange $matches 1 end]]
        }
    }
    return {}
}

# helper function to get the default value of compiler.fortran_fallback
proc portconfigure::get_fortran_fallback {} {
    set ret {}
    foreach compiler [option compiler.fallback] {
        if {[configure_get_compiler_real fc $compiler] ne ""} {
            lappend ret ${compiler}
        }
    }
    return $ret
}

# replacement for portconfigure.tcl version
proc portconfigure::configure_get_default_compiler {} {
    if {[option compiler.whitelist] ne ""} {
        set search_list [option compiler.whitelist]
    } else {
        set search_list [option compiler.fallback]
    }
    return [portconfigure::configure_get_first_compiler cc ${search_list}]
}

# find the first working Fortran compiler in compiler.fortran_fallback
proc portconfigure::configure_get_first_fortran_compiler {} {
    return [portconfigure::configure_get_first_compiler fc [option compiler.fortran_fallback]]
}

# find the first working compiler in the search_list
proc portconfigure::configure_get_first_compiler {compilerName search_list} {
    foreach compiler $search_list {
        set allowed yes
        foreach pattern [option compiler.blacklist] {
            if {[string match $pattern $compiler]} {
                set allowed no
                break
            }
        }
        if {[lsearch [portconfigure::get_valid_compilers yes] ${compiler}] < 0} {
            set allowed no
        }
        if {$allowed &&
            [configure_get_compiler_real ${compilerName} $compiler] ne "" &&
            ([file executable [configure_get_compiler_real ${compilerName} $compiler]] ||
             [compiler_is_port $compiler])
        } then {
            return $compiler
        }
    }
    ui_warn "All compilers are either blacklisted or unavailable for ${compilerName}; defaulting to first fallback option"
    return [lindex [option compiler.fallback] 0]
}

# replacemenet for portconfigure.tcl version
proc portconfigure::configure_get_compiler_real {type compiler} {
    global prefix
    # Tcl 8.4's switch doesn't support -matchvar.
    if {[regexp {^apple-gcc(-4\.[02])$} $compiler -> suffix]} {
        switch $type {
            cc      -
            objc    { return ${prefix}/bin/gcc-apple${suffix} }
            cxx     -
            objcxx  {
                if {$suffix eq "-4.2"} {
                    return ${prefix}/bin/g++-apple${suffix}
                }
            }
            cpp     { return ${prefix}/bin/cpp-apple${suffix} }
        }
    } elseif {[regexp {^clang$} $compiler]} {
        switch $type {
            cc      -
            objc    { return [find_developer_tool clang] }
            cxx     -
            objcxx  {
                set clangpp [find_developer_tool clang++]
                if {[file executable $clangpp]} {
                    return $clangpp
                }
                return [find_developer_tool llvm-g++-4.2]
            }
        }
    } elseif {[regexp {^gcc(-3\.3|-4\.[02])?$} $compiler -> suffix]} {
        switch $type {
            cc      -
            objc    { return [find_developer_tool "gcc${suffix}"] }
            cxx     -
            objcxx  { return [find_developer_tool "g++${suffix}"] }
            cpp     { return [find_developer_tool "cpp${suffix}"] }
        }
    } elseif {[regexp {^llvm-gcc-4\.2$} $compiler]} {
        switch $type {
            cc      -
            objc    { return [find_developer_tool llvm-gcc-4.2] }
            cxx     -
            objcxx  { return [find_developer_tool llvm-g++-4.2] }
            cpp     { return [find_developer_tool llvm-cpp-4.2] }
        }
    } elseif {[regexp {^macports-clang(-\d+\.\d+)?$} $compiler -> suffix]} {
        if {$suffix ne ""} {
            set suffix "-mp${suffix}"
        }
        switch $type {
            cc      -
            objc    { return ${prefix}/bin/clang${suffix} }
            cxx     -
            objcxx  { return ${prefix}/bin/clang++${suffix} }
            cpp     { return ${prefix}/bin/clang-cpp${suffix} }
        }
    } elseif {[regexp {^macports-dragonegg(-\d+\.\d+)(?:-gcc(-\d+\.\d+))?$} $compiler \
                -> infix suffix]} {
        if {$suffix ne ""} {
            set suffix "-mp${suffix}"
        }
        switch $type {
            cc      -
            objc    { return ${prefix}/bin/dragonegg${infix}-gcc${suffix} }
            cxx     -
            objcxx  { return ${prefix}/bin/dragonegg${infix}-g++${suffix} }
            cpp     { return ${prefix}/bin/dragonegg${infix}-cpp${suffix} }
            fc      -
            f77     -
            f90     { return ${prefix}/bin/dragonegg${infix}-gfortran${suffix} }
        }
    } elseif {[regexp {^macports-gcc(-\d+(?:\.\d+)?)?$} $compiler -> suffix]} {
        if {$suffix ne ""} {
            set suffix "-mp${suffix}"
        }
        switch $type {
            cc      -
            objc    { return ${prefix}/bin/gcc${suffix} }
            cxx     -
            objcxx  { return ${prefix}/bin/g++${suffix} }
            cpp     { return ${prefix}/bin/cpp${suffix} }
            fc      -
            f77     -
            f90     { return ${prefix}/bin/gfortran${suffix} }
        }
    } elseif {[regexp {^macports-llvm-gcc-4\.2$} $compiler]} {
        switch $type {
            cc      -
            objc    { return ${prefix}/bin/llvm-gcc-4.2 }
            cxx     -
            objcxx  { return ${prefix}/bin/llvm-g++-4.2 }
            cpp     { return ${prefix}/bin/llvm-cpp-4.2 }
        }
    } elseif {[regexp {^macports-g95$} $compiler]} {
        switch $type {
            fc      -
            f77     -
            f90     { return ${prefix}/bin/g95 }
        }
    } elseif {[regexp {^macports-([^-]+)-clang$} $compiler -> mpi]} {
        switch $type {
            cc      -
            objc    { return ${prefix}/bin/mpicc-${mpi}-clang }
            cxx     -
            objcxx  { return ${prefix}/bin/mpicxx-${mpi}-clang }
        }
    } elseif {[regexp {^macports-([^-]+)-clang-(\d+\.\d+)$} $compiler -> mpi version]} {
        set suffix [join [split ${version} .] ""]
        switch $type {
            cc      -
            objc    { return ${prefix}/bin/mpicc-${mpi}-clang${suffix} }
            cxx     -
            objcxx  { return ${prefix}/bin/mpicxx-${mpi}-clang${suffix} }
            cpp     { return ${prefix}/bin/clang-cpp-mp-${version} }
        }
    } elseif {[regexp {^macports-([^-]+)-gcc-(\d+(?:\.\d+)?)$} $compiler -> mpi version]} {
        set suffix [join [split ${version} .] ""]
        switch $type {
            cc      -
            objc    { return ${prefix}/bin/mpicc-${mpi}-gcc${suffix} }
            cxx     -
            objcxx  { return ${prefix}/bin/mpicxx-${mpi}-gcc${suffix} }
            cpp     { return ${prefix}/bin/cpp-mp-${version} }
            fc      -
            f77     -
            f90     { return ${prefix}/bin/mpifort-${mpi}-gcc${suffix} }
        }
    }
    # Fallbacks
    switch $type {
        cc      -
        objc    { return [find_developer_tool cc] }
        cxx     -
        objcxx  { return [find_developer_tool c++] }
        cpp     { return [find_developer_tool cpp] }
    }
    return ""
}

# extension of portconfigure.tcl version
proc portconfigure::configure_get_compiler {type {compiler {}}} {
    global configure.compiler
    if {$compiler eq ""} {
        set compiler ${configure.compiler}
    }
    set ret [portconfigure::configure_get_compiler_real ${type} ${compiler}]

    if {${ret} eq ""} {
        set is_fortran no
        foreach tool {f77 f90 fc} {
            if {${type} eq ${tool}} {
                set is_fortran yes
            }
        }
        if {${is_fortran} && [option compiler.require_fortran]} {
            set compiler [portconfigure::configure_get_first_fortran_compiler]
            set ret [portconfigure::configure_get_compiler_real ${type} ${compiler}]
        }
    }

    return ${ret}
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
        set fortran_compiler [portconfigure::configure_get_first_fortran_compiler]
        portconfigure::add_compiler_port_dependencies ${fortran_compiler}
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
    } elseif {[regexp {^macports-([^-]+)-(clang|gcc)(?:-(\d+(?:\.\d+)?))?$} $compiler -> mpi clang_or_gcc version]} {
        # MPI compilers link against MPI libraries
        ui_debug "Adding depends_lib port:$compiler_port"
        if {${mpi} eq "openmpi"} {
            set pkgname ompi.pc
        } else {
            set pkgname ${mpi}.pc
        }
        depends_lib-delete "path:lib/$compiler_port/pgkconfig/${pkgname}:${compiler_port}"
        depends_lib-append "path:lib/$compiler_port/pkgconfig/${pkgname}:${compiler_port}"
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
    #    assume MacPorts libstdc++ must be ABI compatible with system libstdc++
    # for OS X Mavericks and above, users must select libstdc++, so
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

# replacement for portconfigure.tcl version
proc portconfigure::arch_flag_supported {compiler} {
    # GCC prior to 4.7 does not accept -arch flag
    if {[regexp {^macports(?:-[^-]+)?-gcc-4\.[0-6]} $compiler]} {
        return 0
    } else {
        return 1
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
