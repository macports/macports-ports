# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates projects hosted in Cgit
#
# Usage:
#
# PortGroup     cgit 1.0
# cgit.setup   author project 1.0.0 v
#
# This portgroup works very similarly to the github-1.0 portgroup.
#
# For any port that is hosted on cgit instance, this portgroup can be used to
# automatically setup details like project name, master_sites, livecheck options
# and more.
#
# Using cgit.setup, the format is:
#
# cgit.setup   <url> <project_name> <version> <version_prefix> <version_suffix>
#

options cgit.url cgit.project cgit.version cgit.tag_prefix cgit.tag_suffix

options cgit.homepage
default cgit.homepage      {https://${cgit.url}/${cgit.project}.git}

options cgit.master_sites
default cgit.master_sites  {${cgit.homepage}/snapshot}

options cgit.livecheck.branch
default cgit.livecheck.branch master

options cgit.livecheck.regex
default cgit.livecheck.regex {(\[0-9]\[^"<']+)}

proc cgit.setup {cgit_url cgit_project cgit_version {cgit_tag_prefix ""} {cgit_tag_suffix ""}} {
    global cgit.url cgit.project cgit.version cgit.tag_prefix cgit.tag_suffix
    global cgit.homepage cgit.master_sites cgit.livecheck.branch cgit.livecheck.regex
    global PortInfo

    cgit.url               ${cgit_url}
    cgit.project           ${cgit_project}
    cgit.version           ${cgit_version}
    cgit.tag_prefix        ${cgit_tag_prefix}
    cgit.tag_suffix        ${cgit_tag_suffix}

    if {![info exists PortInfo(name)]} {
        name                ${cgit.project}
        dist_subdir         ${cgit.project}
    }

    version                 ${cgit.version}
    default homepage        ${cgit.homepage}
    git.url                 ${cgit.homepage}.git

    set _cgit_branch       [join ${cgit.tag_prefix}]${cgit.version}[join ${cgit.tag_suffix}]

    git.branch              ${_cgit_branch}
    default master_sites    ${cgit.master_sites}
    distname                ${_cgit_branch}

    if {[join ${cgit.tag_prefix}] eq "" && \
        [join ${cgit.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${cgit.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${cgit.version}]} {
        livecheck.type          regexm
        default livecheck.url   {${cgit.homepage}/atom/?h=${cgit.livecheck.branch}}
        livecheck.regex         commit/\\\?id=(\[0-9a-f\]{[string length ${cgit.version}]})\[0-9a-f\]*
    } else {
        livecheck.type          regex
        default livecheck.url   {${cgit.homepage}/refs/tags}
        default livecheck.regex {[list tag/\\\?h=[join ${cgit.tag_prefix}][join ${cgit.livecheck.regex}][join ${cgit.tag_suffix}]]}
    }
    livecheck.version       ${cgit.version}
}
