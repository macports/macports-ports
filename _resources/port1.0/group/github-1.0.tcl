# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates projects hosted at GitHub.
#
# Documentation:
# https://guide.macports.org/#reference.portgroup.github
#
# Documentation (sources):
# https://github.com/macports/macports-guide/blob/master/guide/xml/portgroup-github.xml

options github.author github.project github.version github.tag_prefix github.tag_suffix

options github.homepage
default github.homepage {https://github.com/${github.author}/${github.project}}

options github.raw
default github.raw {https://raw.githubusercontent.com/${github.author}/${github.project}}

# Later code assumes that github.master_sites is a simple string, not a list.
options github.master_sites
default github.master_sites {https://codeload.github.com/${github.author}/${github.project}/legacy.tar.gz/${git.branch}?dummy=}

options github.tarball_from
default github.tarball_from tarball
option_proc github.tarball_from handle_tarball_from
proc handle_tarball_from {option action args} {
    global extract.suffix git.branch github.author github.homepage github.master_sites github.project

    if {${action} eq "set"} {
        github.tarball_from ${args}
        switch ${args} {
            downloads {
                github.master_sites https://github.com/downloads/${github.author}/${github.project}
                default extract.rename no
            }
            releases {
                github.master_sites ${github.homepage}/releases/download/${git.branch}
                default extract.rename no
            }
            archive {
                github.master_sites ${github.homepage}/archive/${git.branch}
                default extract.rename {[expr {[llength ${extract.only}] == 1}]}
            }
            tarball {
                github.master_sites https://codeload.github.com/${github.author}/${github.project}/legacy.tar.gz/${git.branch}?dummy=
                default extract.rename {[expr {[llength ${extract.only}] == 1}]}
            }
            tags {
                return -code error "the value \"tags\" is deprecated for github.tarball_from. Please use \"tarball\" instead."
            }
            default {
                return -code error "invalid value \"${args}\" for github.tarball_from"
            }
        }
    }
}

options github.livecheck.branch
default github.livecheck.branch master

options github.livecheck.regex
default github.livecheck.regex {(\[^"]+)}

proc github.setup {gh_author gh_project gh_version {gh_tag_prefix ""} {gh_tag_suffix ""}} {
    global extract.suffix github.author github.project github.version github.tag_prefix github.tag_suffix \
           github.homepage github.master_sites github.livecheck.branch PortInfo

    github.author           ${gh_author}
    github.project          ${gh_project}
    github.version          ${gh_version}
    github.tag_prefix       ${gh_tag_prefix}
    github.tag_suffix       ${gh_tag_suffix}

    if {![info exists PortInfo(name)]} {
        name                ${github.project}
    }

    version                 ${github.version}
    default homepage        ${github.homepage}
    git.url                 ${github.homepage}.git
    git.branch              [join ${github.tag_prefix}]${github.version}[join ${github.tag_suffix}]
    default master_sites    {${github.master_sites}}
    distname                ${github.project}-${github.version}

    default extract.rename  {[expr {[llength ${extract.only}] == 1}]}

    # If the version is composed entirely of hex characters, and is at least 7
    # characters long, and is not exactly 8 decimal digits (which might be a
    # version in YYYYMMDD format), and no tag prefix or suffix is provided, then
    # assume we are using a commit hash and livecheck commits; otherwise
    # livecheck tags.
    if {[join ${github.tag_prefix}] eq "" && \
        [join ${github.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${github.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${github.version}]} {
        livecheck.type          regexm
        default livecheck.url   {${github.homepage}/commits/${github.livecheck.branch}.atom}
        default livecheck.regex {<id>tag:github.com,2008:Grit::Commit/(\[0-9a-f\]{[string length ${github.version}]})\[0-9a-f\]*</id>}
    } else {
        livecheck.type          regex
        default livecheck.url   {${github.homepage}/tags}
        default livecheck.regex {[list archive/refs/tags/[quotemeta [join ${github.tag_prefix}]][join ${github.livecheck.regex}][quotemeta [join ${github.tag_suffix}]]\\.tar\\.gz]}
    }
    livecheck.version       ${github.version}
}
