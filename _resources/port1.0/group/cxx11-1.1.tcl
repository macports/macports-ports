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
#
# This PortGroup introduces no new options. Simply including this
# PortGroup indicates that a port requires C++11
#
# Ideally the functionality of this PortGroup should be integrated into
# MacPorts base as a new option.

PortGroup compiler_blacklist_versions 1.0

# Compilers supporting C++11 are GCC >= 4.6 and clang >= 3.3.
# We do not know what "cc" is, so blacklist it as well.
compiler.blacklist-append   {*gcc-3*} {*gcc-4.[0-5]} {clang < 500} cc

if {${cxx_stdlib} eq "libstdc++" } {

    compiler.blacklist-append   {macports-clang-3.[0-8]} clang

    compiler.whitelist-append  \
        macports-clang-4.0     \
        macports-gcc-6         \
        macports-gcc-5         \
        macports-gcc-4.9       \
        macports-gcc-4.8       \
        macports-gcc-4.7       \
        macports-gcc-4.6

    # see https://trac.macports.org/ticket/53194
    configure.cxx_stdlib macports-libstdc++
    
    platform darwin powerpc {
        # ports will build on powerpc with gcc6, gcc4ABI-compatible
        
        pre-configure {
            ui_msg "PowerPC C++11 ports are compiling with gcc6. EXPERIMENTAL."
        }
        compiler.whitelist-delete macports-clang-4.0
        universal_variant no
    }

    if { ${os.major} < 13 } {
        # prior to OS X Mavericks, libstdc++ was the default C++ runtime, so
        #    assume MacPorts libstdc++ must be ABI compatable with system libstdc++
        # for OS X Maverick and above, users must select libstdc++, so
        #    assume they want default ABI compatibility
        # see https://gcc.gnu.org/onlinedocs/gcc-5.2.0/libstdc++/manual/manual/using_dual_abi.html
        configure.cxxflags-append -D_GLIBCXX_USE_CXX11_ABI=0
    }
} else {
    # GCC compilers can not use libc++
    compiler.blacklist-append   *gcc*
}
