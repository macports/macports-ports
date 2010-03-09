# $Id$

# Copyright (c) 2009 Orville Bennett <illogical1 at gmail.com>
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


depends_build       port:cmake

#FIXME: ccache works with cmake on linux
configure.ccache    no

configure.cmd       cmake

configure.pre_args  -DCMAKE_INSTALL_PREFIX=${prefix}

configure.args      -DCMAKE_VERBOSE_MAKEFILE=ON \
                    -DCMAKE_COLOR_MAKEFILE=ON \
                    -DCMAKE_BUILD_TYPE=Release \
                    -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
                    -DCMAKE_INSTALL_NAME_DIR=${prefix}/lib \
                    -DCMAKE_SYSTEM_PREFIX_PATH=\"${prefix}\;/usr\" \
                    -DQT_QMAKE_EXECUTABLE=${prefix}/libexec/qt4-mac/bin/qmake \
                    -Wno-dev
pre-configure {
    if {${os.platform} == "darwin" && (![variant_isset universal] || ![variant_exists universal])} {
        configure.args-append \
            -DCMAKE_OSX_ARCHITECTURES=\"${configure.build_arch}\"
    }
    configure.universal_args-append \
        -DCMAKE_OSX_ARCHITECTURES=\"[strsed ${configure.universal_archs} "g| |;|"]\"
}
configure.universal_args-delete --disable-dependency-tracking
if {${os.arch} == "powerpc" && ${os.major} == "8"} {
    configure.universal_args-append -DCMAKE_OSX_SYSROOT="${developer_dir}/SDKs/MacOSX10.4u.sdk"
}

variant debug description "Enable debug binaries" {
    configure.args-delete   -DCMAKE_BUILD_TYPE=Release
    configure.args-append   -DCMAKE_BUILD_TYPE=debugFull
}
