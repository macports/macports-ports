# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2012-2014 The MacPorts Project
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
# This PortGroup accommodates projects hosted at github.
#
# Usage:
#
# After the PortSystem 1.0 line, put:
#
#   PortGroup           github 1.0
#
# Then, replace the name and version lines with:
#
#   github.setup        author project version [tag_prefix]
#
# The port's name will be set to the github project name. If that's not correct,
# override it by setting the port name as usual, for example:
#
#   github.setup        someone someproject 1.2.3
#   name                myportname
#
# The tag_prefix is optional, and refers to any characters that may appear
# before the actual version number when you view the list of tags for this
# project on github. For example, if the tags are named like "v1.2.3" then
# tag_prefix should be specified as "v":
#
#   github.setup        someone someproject 1.2.3 v
#
# Some projects use github's "releases" service to offer distfiles:
# 
# https://github.com/blog/1547-release-your-software
#
# If the project offers a "release", that's probably the best distfile to use
# for the port. To do this, use:
#
#   github.tarball_from releases
#
# Github imposes no naming convention for "release" distfiles, so you may need
# to set distname as you would for other ports.
#
# Older projects use the discontinued "downloads" service. New "downloads" can
# no longer be created, but old ones are still available:
#
# https://github.com/blog/1302-goodbye-uploads
#
# If the project doesn't have "releases" but does have "downloads", use them
# this way (and set distname if needed):
#
#   github.tarball_from downloads
#
# If neither "releases" nor "downloads" are available, github can automatically
# generate a distfile from a git tag or commit. This is the github portgroup's
# default behavior; to use this, simply don't set github.tarball_from. The
# distname is irrelevant when fetching from a tag or commit, so don't set it
# either.
#
# If the project's developers do not tag their releases, encourage them to do
# so. Until they do, or if you need to use a development version that's not
# tagged, you can use a git commit hash and set the version field. If the
# project does not assign version numbers (or for development versions) you can
# invent one, typically in the YYYYMMDD format corresponding to the date of the
# commit you picked. For example, if you want to use a commit with the hash
# 0ff25277c3842598d919cd3c73d60768 that was committed on April 1, 2014, then
# you would use:
#
#   github.setup        someone someproject 0ff25277c3842598d919cd3c73d60768
#   version             20140401
#
# Some projects' tag- or commit-based distfiles will not contain all the
# necessary files, if the project uses git submodules. If available, use a
# distfile from "releases" or "downloads" instead, as described above. If the
# project does not provide those, encourage the project's developers to provide
# releases. Until they do, fetch from git instead of from a distfile, and add a
# post-fetch block to fetch the submodules:
#
#   fetch.type          git
#
#   post-fetch {
#       system -W ${worksrcpath} "git submodule update --init"
#   }

options github.author github.project github.version github.tag_prefix
options github.homepage github.raw github.master_sites github.tarball_from

default github.homepage {https://github.com/${github.author}/${github.project}}
default github.raw {https://raw.githubusercontent.com/${github.author}/${github.project}}

# Later code assumes that github.master_sites is a simple string, not a list.
default github.master_sites {${github.homepage}/tarball/[join ${github.tag_prefix} ""]${github.version}}

default master_sites {${github.master_sites}}

default github.tarball_from {tags}
option_proc github.tarball_from handle_tarball_from
proc handle_tarball_from {option action args} {
    global github.author github.project github.master_sites git.branch github.homepage

    if {${action} eq "set"} {
        github.tarball_from ${args}
        switch ${args} {
            downloads {
                github.master_sites https://github.com/downloads/${github.author}/${github.project}
            }
            releases {
                github.master_sites ${github.homepage}/releases/download/${git.branch}
            }
            tags {
                github.master_sites ${github.homepage}/tarball/${git.branch}
            }
            default {
                return -code error "invalid value \"${args}\" for github.tarball_from"
            }
        }
    }
}

proc github.setup {gh_author gh_project gh_version {gh_tag_prefix ""}} {
    global extract.suffix os.platform os.major github.author github.project github.version github.tag_prefix github.homepage github.master_sites PortInfo

    github.author           ${gh_author}
    github.project          ${gh_project}
    github.version          ${gh_version}
    github.tag_prefix       ${gh_tag_prefix}

    if {!([info exists PortInfo(name)] && (${PortInfo(name)} ne ${github.project}))} {
        name                ${github.project}
    }

    version                 ${github.version}
    homepage                ${github.homepage}
    git.url                 ${github.homepage}.git
    git.branch              [join ${github.tag_prefix}]${github.version}
    distname                ${github.project}-${github.version}
    if {${os.platform} eq "darwin" && ${os.major} <= 9} {
        fetch.ignore_sslcert yes
    }

    post-extract {
        # When fetching from a tag, the extracted directory name will contain a
        # truncated commit hash. So that the port author need not specify what
        # that hash is every time the version number changes, rename the
        # directory to the value of distname (not worksrcdir: ports may want to
        # set worksrcdir to a subdirectory of the extracted directory).
        # It is assumed that github.master_sites is a simple string, not a list.
        # Here be dragons.
        if {![file exists ${worksrcpath}] && \
                ${fetch.type} eq "standard" && \
                [lsearch -exact ${master_sites} ${github.master_sites}] != -1 && \
                [llength ${distfiles}] > 0 && \
                [llength [glob -nocomplain ${workpath}/*]] > 0} {
            if {[file exists [glob -nocomplain ${workpath}/${github.author}-${github.project}-*]] && \
                [file isdirectory [glob -nocomplain ${workpath}/${github.author}-${github.project}-*]]} {
                move [glob ${workpath}/${github.author}-${github.project}-*] ${workpath}/${distname}
            } else {
                # tarball is not "${github.author}-${github.project}-*"
                ui_error "\n\ngithub PortGroup: Error: tarball name is not as expected. This might mean that the repository name is different than set in the Portfile. Please review and try to correct.\n"
                return -code error "Unexpected github tarball extract."
            }
        }
    }

    # If the "version" is composed entirely of hex characters, and is at least
    # nine characters long, and no tag_prefix is provided, then assume we are
    # using a commit hash and livecheck commits; otherwise livecheck tags.
    if {[join ${github.tag_prefix}] eq "" && \
        [regexp "^\[0-9a-f\]{9,}\$" ${github.version}]} {
        livecheck.type      regexm
        livecheck.url       ${github.homepage}/commits/master.atom
        livecheck.regex     <id>tag:github.com,2008:Grit::Commit/(\[0-9a-f\]{[string length ${github.version}]})\[0-9a-f\]*</id>
    } else {
        livecheck.type      regex
        livecheck.url       ${github.homepage}/tags
        livecheck.regex     archive/[join ${github.tag_prefix} ""](\[^"\]+)${extract.suffix}
    }
    livecheck.version       ${github.version}
}
