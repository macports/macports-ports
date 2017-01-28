# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2006 Yves de Champlain <yves@opendarwin.org>,
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
# Group code for GNUstep ports.
#

#
# Overview of gnustep 1.0 PortGroup :
#

#
# default categories            gnustep
# default homepage              http://www.gnustep.org/
# default master_sites          gnustep:core
# default depends_lib           port:gnustep-core
#
# array set gnustep.post_flags  Apple CC two-level namespaces requires all
#                               symbols to be resolved at link time,
#                               so most of the patches are just that.
#                               Setting the gnustep.post_flags array makes this
#                               simple beyond common understanding !
#                               ex:
#                               platform darwin {
#                                   array set gnustep.post_flags {
#                                       BundleSubDir  "-lfoo -lbar"
#                                   }
#                               }
#
#
# proc set_gnustep_make         Sets GNUSTEP_MAKEFILES
#                               according to the FilesystemLayout
#
# proc set_gnustep_env          Sets DYLD_LIBRARY_PATH and PATH
#                               for the gnustep FilesystemLayout
#
#
# default gnustep.cc            CC=gcc-mp-4.2
#
# default use_configure         no
# default configure.env         Sets the environment for the gnustep FilesystemLayout
# configure.pre_args-append     ${gnustep.cc} [set_gnustep_make]"
#
# default build.env             {[set_gnustep_env]}
# default build.type            gnu
# build.pre_args-append         "messages=yes [set_gnustep_make]"
#
# default destroot.env          {[set_gnustep_env]}
# destroot.pre_args-append      "messages=yes [set_gnustep_make] [set_gnustep_domain]"
#
# variant with_docs             Most GNUstep programs providing documentation
#                               follow the same pattern
#

#
# GNUstep utilities
#

#
# Adds SHARED_LD_POSTFLAGS for Darwin's linker
#
# Sets GNUSTEP_INSTALLATION_DOMAIN for ports using the
# deprecated GNUSTEP_SYSTEM_ROOT variable
#

array set gnustep.post_flags {}

post-patch {
    foreach {src_subdir post_libs} [array get gnustep.post_flags] {
        set fl [ open ${worksrcpath}/$src_subdir/GNUmakefile.preamble a ]
        puts $fl "\nSHARED_LD_POSTFLAGS += $post_libs"
        close $fl
    }
    foreach gmf [glob -nocomplain -directory ${worksrcpath} GNUmakefile*] {
        reinplace \
            "s|GNUSTEP_INSTALLATION_DIR = \$\(GNUSTEP_SYSTEM_ROOT\)|GNUSTEP_INSTALLATION_DOMAIN=SYSTEM|g" \
                $gmf
    }
}

#
# Returns true (1) if current file layout is gnustep
# Returns false (0) otherwise
#

proc gnustep_layout {} {
    global prefix

    if {[file exists ${prefix}/GNUstep/System/Library/Makefiles]} {
        return 1
    }
    return 0
}

#
# Sets GNUSTEP_SYSTEM_LIBRARY according to the FilesystemLayout
#

proc set_system_library {} {
    global prefix

    if {[gnustep_layout]} {
        return "${prefix}/GNUstep/System/Library"
    }
    return "${prefix}/lib/GNUstep"
}

#
# Sets GNUSTEP_LOCAL_LIBRARY according to the FilesystemLayout
#

proc set_local_library {} {
    global prefix

    if {[gnustep_layout]} {
        return "${prefix}/GNUstep/Local/Library"
    }
    return "${prefix}/lib/GNUstep"
}

#
# Sets GNUSTEP_MAKEFILES according to the FilesystemLayout
#

proc set_gnustep_make {} {
    global prefix

    if {[gnustep_layout]} {
        return "GNUSTEP_MAKEFILES=${prefix}/GNUstep/System/Library/Makefiles"
    }
    return "GNUSTEP_MAKEFILES=${prefix}/share/GNUstep/Makefiles"
}

#
# Sets DYLD_LIBRARY_PATH and PATH for the gnustep FilesystemLayout
#

proc set_gnustep_env {} {
    global env prefix

    if {[gnustep_layout]} {
        return [list "DYLD_LIBRARY_PATH=${prefix}/GNUstep/Local/Library/Libraries:${prefix}/GNUstep/System/Library/Libraries" \
            "PATH=${prefix}/GNUstep/Local/Tools:${prefix}/GNUstep/System/Tools:$env(PATH)"]
    }
    return [list]
}

#
# Options this group provides :
#

options gnustep.cc
default gnustep.cc          {CC=${configure.cc}}

platform darwin 8 {
    configure.compiler      apple-gcc-4.2
    depends_build           port:apple-gcc42
}
platform darwin 9 {
    configure.compiler      gcc-4.2
}

options system_library
options local_library
default system_library      [set_system_library]
default local_library       [set_local_library]

#
# Default values for this group :
#

default categories          gnustep
default homepage            http://www.gnustep.org/

default master_sites        gnustep:core
default depends_lib         port:gnustep-core

default use_configure       no
default configure.env       {[set_gnustep_env]}
configure.pre_args-append   "${gnustep.cc} [set_gnustep_make]"

default build.env           {[set_gnustep_env]}
default build.type          gnu
build.pre_args-append       "messages=yes [set_gnustep_make]"

default destroot.env        {[set_gnustep_env]}
default destroot.violate_mtree  yes
destroot.pre_args-append    "messages=yes [set_gnustep_make]"

#
# To build and install documentation provided by the port
#

variant with_docs {
    depends_build-append    bin:latex2html:latex2html \
                            bin:texi2pdf:texinfo \
                            bin:texi2html:texi2html \
                            bin:pdftex:teTeX \
                            port:gnustep-base

    post-destroot {

        if {[file exists ${worksrcpath}/Documentation/GNUmakefile]} {

            ui_msg "$UI_PREFIX Making documentation for ${name}"

            _cd ${worksrcpath}/Documentation
            system "${destroot.env} ${destroot.cmd} \
                    ${destroot.pre_args} ${destroot.destdir}"

            set info_dir \
                ${destroot}${prefix}/GNUstep/System/Library/Documentation/info
            if {[file exists ${info_dir}/manual.info]} {
                set manual_name [regsub {gnustep-} ${name} ""]
                file rename ${info_dir}/manual.info \
                    ${info_dir}/${manual_name}-manual.info
            }
        }
    }
}


