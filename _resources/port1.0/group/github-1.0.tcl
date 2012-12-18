# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2012 The MacPorts Project
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
# This PortGroup sets up default behaviors for projects hosted at github.
#
# Usage:
#
#   PortGroup               github 1.0
#   github.setup            author project version [tag_prefix]

options github.author github.project github.version github.tag_prefix
options github.homepage github.raw github.master_sites github.tarball_from

default github.homepage {https://github.com/${github.author}/${github.project}}
default github.raw {https://raw.github.com/${github.author}/${github.project}}
default github.master_sites {${github.homepage}/tarball/[join ${github.tag_prefix} ""]${github.version}}

default master_sites {${github.master_sites}}

# The ability to host downloads on github is going away
# https://github.com/blog/1302-goodbye-uploads
default github.tarball_from {tags}
option_proc github.tarball_from handle_tarball_from
proc handle_tarball_from {option action args} {
    global github.author github.project github.master_sites

    # keeping the default at tags like many portfiles already do
    # the port writer can set github.tarball_from to "downloads" and have the URI path accordingly changed
    if {[string equal ${action} "set"] && $args == "downloads"} {
        github.tarball_from ${args}
        github.master_sites https://github.com/downloads/${github.author}/${github.project}
    }
}

proc github.setup {gh_author gh_project gh_version {gh_tag_prefix ""}} {
    global extract.suffix github.author github.project github.version github.tag_prefix github.homepage github.master_sites

    github.author           ${gh_author}
    github.project          ${gh_project}
    github.version          ${gh_version}
    github.tag_prefix       ${gh_tag_prefix}

    name                    ${github.project}
    version                 ${github.version}
    homepage                ${github.homepage}
    git.url                 ${github.homepage}.git
    git.branch              [join ${github.tag_prefix}]${github.version}
    distname                ${github.project}-${github.version}
    fetch.ignore_sslcert    yes

    post-extract {
        if {![file exists ${worksrcpath}] && "standard" == ${fetch.type} && \
            ${master_sites} == ${github.master_sites} && [llength ${distfiles}] > 0} {
            move [glob ${workpath}/*] ${worksrcpath}
        }
    }

    livecheck.type          regex
    livecheck.version       ${github.version}
    livecheck.url           ${github.homepage}/tags
    livecheck.regex         archive/[join ${github.tag_prefix} ""](\[^"\]+)${extract.suffix}"
}
