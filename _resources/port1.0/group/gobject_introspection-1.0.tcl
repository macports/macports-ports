# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2015-2016, 2018 The MacPorts Project
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
# This PortGroup adds dependencies and arguments for building with gobject
# introspection. There is just one option to set:
#
# gobject_introspection: whether to use gobject introspection. The default
# is no. Possible values are yes and no.
#
# It is imperative to either set this option *after* you set the port's
# dependencies, not before, or alternately, ensure you always append to
# dependencies rather than overwriting them. Otherwise you'll overwrite
# the dependencies the portgroup sets.

options gobject_introspection
default gobject_introspection   no
option_proc gobject_introspection gobject_introspection._set

proc gobject_introspection._set {option action args} {
    if {"set" ne ${action}} {
        return
    }

    if {${args}} {
        depends_lib-append      port:gobject-introspection

        platform darwin 8 {
            depends_build-append port:gmake
        }
    } else {
        depends_lib-delete      port:gobject-introspection

        platform darwin 8 {
            depends_build-delete port:gmake
        }
    }
}

pre-configure {
    if {${gobject_introspection}} {
        configure.args-append   --enable-introspection
    } else {
        configure.args-append   --disable-introspection
    }
}

pre-build {
    if {${gobject_introspection}} {
        # gobject-introspection uses g-ir-scanner, which uses $CC from args.
        if {[info exists universal_archs_to_use]} {
            global merger_build_args
            foreach arch ${universal_archs_to_use} {
                lappend merger_build_args(${arch})      CC="${configure.cc} -arch ${arch}"
            }
        } else {
            # This deliberately does not use [get_canonical_archflags cc]
            # because that would cause g-ir-scanner to report an error:
            #
            # clang: error: cannot use 'cpp-output' output with multiple -arch
            # options
            #
            # This means that the $CC passed to make at build and destroot time
            # does not contain the right -arch flags for universal builds that
            # don't use the muniversal portgroup, but this is assumed not to
            # affect the output of g-ir-scanner. It is even possible that the
            # -arch flags aren't necessary at all for g-ir-scanner, but this has
            # not been investigated.
            #
            # The non-g-ir-scanner parts of the build are assumed to build with
            # the correct -arch flags as determined at configure time.
            build.args-append       CC="${configure.cc} ${configure.cc_archflags}"
        }

        # The rules enabled by gobject-introspection require GNU make 3.81+
        platform darwin 8 {
            build.cmd-replace   [portbuild::build_getmaketype] ${prefix}/bin/gmake
        }
    }
}

pre-destroot {
    if {${gobject_introspection}} {
        # gobject-introspection uses g-ir-scanner, which uses $CC from args.
        if {[info exists universal_archs_to_use]} {
            global merger_destroot_args
            foreach arch ${universal_archs_to_use} {
                lappend merger_destroot_args(${arch})   CC="${configure.cc} -arch ${arch}"
            }
        } else {
            # This deliberately does not use [get_canonical_archflags cc]. See
            # explanation in pre-build block.
            destroot.args-append    CC="${configure.cc} ${configure.cc_archflags}"
        }
    }
}
