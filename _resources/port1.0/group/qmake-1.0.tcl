# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2013 The MacPorts Project
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
# This portgroup defines standard settings when using qmake.
#
# Usage:
# PortGroup                     qmake 1.0

PortGroup                       qt4 1.0

pre-configure {
    configure.cmd                   ${qt_qmake_cmd}
    configure.pre_args-delete       --prefix=${prefix}
    configure.pre_args-append       PREFIX=${prefix} \
                                    "QMAKE_CC=${configure.cc}" \
                                    "QMAKE_CXX=${configure.cxx}" \
                                    "QMAKE_OBJC=${configure.objc}" \
                                    "QMAKE_CFLAGS=\"${configure.cflags} [get_canonical_archflags cc]\"" \
                                    "QMAKE_CXXFLAGS=\"${configure.cxxflags} [get_canonical_archflags cxx]\"" \
                                    "QMAKE_LFLAGS=\"${configure.ldflags}\"" \
                                    "QMAKE_LINK_C=${configure.cc}" \
                                    "QMAKE_LINK_C_SHLIB=${configure.cc}" \
                                    "QMAKE_LINK=${configure.cxx}" \
                                    "QMAKE_LINK_SHLIB=${configure.cxx}"
    configure.universal_args-delete --disable-dependency-tracking

    if {[variant_exists universal] && [variant_isset universal]} {
        configure.pre_args-append   "CONFIG+=\"${qt_arch_types}\""
    }
}

variant debug description "Enable debug binaries" {
    configure.pre_args-append   "CONFIG+=debug"
}

# check for +debug variant of this port, and make sure Qt was
# installed with +debug as well; if not, error out.
platform darwin {
    pre-extract {
        if {[variant_exists debug] && \
            [variant_isset debug] && \
           ![info exists building_qt4]} {
            if {![file exists ${qt_frameworks_dir}/QtCore.framework/QtCore_debug]} {
                return -code error "\n\nERROR:\n\
In order to install this port as +debug,
Qt4 must also be installed with +debug.\n"
            }
        }
    }
}
