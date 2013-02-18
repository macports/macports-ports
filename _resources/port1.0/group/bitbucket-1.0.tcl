# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
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
# This PortGroup sets up default behaviors for projects hosted at bitbucket.
#
# Usage:
#
#   PortGroup               bitbucket 1.0
#   bitbucket.setup         author project version [tag_prefix]

options bitbucket.author bitbucket.project bitbucket.version bitbucket.tag_prefix bitbucket.livecheck_type
options bitbucket.homepage bitbucket.master_sites bitbucket.tarball_from

default bitbucket.homepage {https://bitbucket.org/${bitbucket.author}/${bitbucket.project}}
default bitbucket.master_sites {${bitbucket.homepage}/get}
default bitbucket.tarball_from {tags}
default bitbucket.livecheck_type ""

default master_sites {${bitbucket.master_sites}}

option_proc bitbucket.tarball_from handle_tarball_from

proc handle_tarball_from {option action args} {
    global bitbucket.author bitbucket.project bitbucket.master_sites

    # the port writer can set bitbucket.tarball_from to "downloads" and have the URI path accordingly changed
    if {[string equal ${action} "set"] && $args == "downloads"} {
        bitbucket.tarball_from ${args}
        bitbucket.master_sites https://bitbucket.org/${bitbucket.author}/${bitbucket.project}/downloads
    }
}

proc bitbucket.setup {bb_author bb_project bb_version {bb_tag_prefix ""}} {
    global bitbucket.author bitbucket.project bitbucket.version bitbucket.tag_prefix bitbucket.homepage bitbucket.master_sites extract.suffix bitbucket.livecheck_type

    bitbucket.author        ${bb_author}
    bitbucket.project       ${bb_project}
    bitbucket.version       ${bb_version}
    bitbucket.tag_prefix    ${bb_tag_prefix}

    name                    ${bitbucket.project}
    version                 ${bitbucket.version}
    homepage                ${bitbucket.homepage}
    hg.url                  ${bitbucket.homepage}
    hg.tag                  [join ${bitbucket.tag_prefix}]${bitbucket.version}
    distname                [join ${bitbucket.tag_prefix}]${bitbucket.version}
    fetch.ignore_sslcert    yes

    post-extract {
        if {![file exists ${worksrcpath}] && "standard" == ${fetch.type} && \
            ${master_sites} == ${bitbucket.master_sites} && [llength ${distfiles}] > 0 && \
            [llength [glob -nocomplain ${workpath}/*]] > 0} {
            move [glob ${workpath}/*] ${worksrcpath}
        }
    }

    if {[join ${bitbucket.tag_prefix}] == "" && [regexp "^\[0-9a-f\]{9,}\$" ${bitbucket.version}]} {
        bitbucket.livecheck_type commits
    } else {
        bitbucket.livecheck_type tags
    }

    if {[string equal ${bitbucket.livecheck_type} "commits"]} {
        livecheck.type      regexm
        livecheck.url       ${bitbucket.homepage}/atom
        livecheck.version   ${bitbucket.version}
        livecheck.regex     <id>changeset:(\[0-9a-f\]{[string length ${bitbucket.version}]})\[0-9a-f\]*</id>
    } else {
        livecheck.type      regex
        livecheck.version   ${bitbucket.version}
        livecheck.url       ${bitbucket.homepage}/downloads
        livecheck.regex     get/[join ${bitbucket.tag_prefix}](\[0-9\.\]+)${extract.suffix}
    }
}

