# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2017 The MacPorts Project
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

# This PortGroup supports the meson build system
#
# Usage:
#
# PortGroup meson 1.0
#

#---------
# WARNING:
#---------
#
# Meson's install_name currently seems to be broken, so workarounds might be needed to make ports actually work.
# See: https://github.com/mesonbuild/meson/issues/2121


# meson builds need to be done out-of-source
default build_dir           {${workpath}/build}

depends_build-append        port:meson \
                            port:ninja
depends_skip_archcheck-append \
                            meson \
                            ninja

# TODO: --buildtype=plain tells Meson not to add its own flags to the command line. This gives the packager total control on used flags.
default configure.cmd       {${prefix}/bin/meson}
default configure.post_args {[meson::get_post_args]}
configure.universal_args-delete \
                            --disable-dependency-tracking

default build.dir           {${build_dir}}
default build.cmd           {${prefix}/bin/ninja}
default build.target        ""

# remove DESTDIR= from arguments, but rather take it from environmental variable
destroot.env-append         DESTDIR=${destroot}
default destroot.post_args  ""

namespace eval meson {
    proc get_post_args {} {
        global configure.dir build_dir muniversal.current_arch
        if {[info exists muniversal.current_arch]} {
            return "${configure.dir} ${build_dir}-${muniversal.current_arch}"
        } else {
            return "${configure.dir} ${build_dir}"
        }
    }
}
