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
PortGroup cmake 1.0

depends_build           port:automoc
use_parallel_build      yes
worksrcdir              build
post-extract            { file mkdir ${worksrcpath} }

configure.compiler      gcc-4.2
configure.args-append   -DBUILD_SHARED_LIBS=ON \
                        -DCMAKE_BUILD_TYPE=Release \
                        -DBUNDLE_INSTALL_DIR=${applications_dir}/KDE4 \
                        -DKDE_DEFAULT_HOME=Library/Preferences/KDE \
                        -DKDE_DISTRIBUTION_TEXT="MacPorts\/Mac OS X" \
                        -DQT_QMAKE_EXECUTABLE=${prefix}/libexec/qt4-mac/bin/qmake

variant with_docs description "Enables installation of documentation" {
    depends_lib             port:doxygen
    configure.args-append   -DBUILD_doc=ON
}

variant debug description "Enable debug binaries" {
    configure.args-delete   -DCMAKE_BUILD_TYPE=Release
    configure.args-append   -DCMAKE_BUILD_TYPE=debugFull
}

