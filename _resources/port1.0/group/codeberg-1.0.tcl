# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates projects hosted in Gitea
#
# Usage:
#
# PortGroup       codeberg 1.0
# codeberg.setup  author project 1.0.0 v
#
# This portgroup works very similarly to the gitea-1.0 portgroup.
#
# For any port that is hosted on codeberg.org this portgroup can be used to
# automatically setup details like project name, master_sites, livecheck options
# and more.
#
# Using codeberg.setup, the format is:
#
# codeberg.setup  <author> <project_name> <version> <version_prefix> <version_suffix>

options codeberg.author codeberg.project codeberg.version codeberg.tag_prefix codeberg.tag_suffix

options codeberg.homepage
default codeberg.homepage           {https://codeberg.org/${codeberg.author}/${codeberg.project}}

options codeberg.master_sites
default codeberg.master_sites       {${codeberg.homepage}/archive}

options codeberg.livecheck.branch
default codeberg.livecheck.branch   master

options codeberg.livecheck.regex
default codeberg.livecheck.regex    {(\[0-9]\[^<]+)}

proc codeberg.setup {codeberg_author codeberg_project codeberg_version {codeberg_tag_prefix ""} {codeberg_tag_suffix ""}} {
    global codeberg.author codeberg.project codeberg.version codeberg.tag_prefix codeberg.tag_suffix
    global codeberg.homepage codeberg.master_sites codeberg.livecheck.branch codeberg.livecheck.regex
    global PortInfo

    codeberg.author             ${codeberg_author}
    codeberg.project            ${codeberg_project}
    codeberg.version            ${codeberg_version}
    codeberg.tag_prefix         ${codeberg_tag_prefix}
    codeberg.tag_suffix         ${codeberg_tag_suffix}

    if {![info exists PortInfo(name)]} {
        name                    ${codeberg.project}
        dist_subdir             ${codeberg.project}
    }

    version                     ${codeberg.version}
    default homepage            ${codeberg.homepage}
    git.url                     ${codeberg.homepage}.git

    set _codeberg_branch        [join ${codeberg.tag_prefix}]${codeberg.version}[join ${codeberg.tag_suffix}]

    git.branch                  ${_codeberg_branch}
    default master_sites        ${codeberg.master_sites}
    distname                    ${_codeberg_branch}

    default extract.rename      yes

    if {[join ${codeberg.tag_prefix}] eq "" && \
        [join ${codeberg.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${codeberg.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${codeberg.version}]} {
        livecheck.type          regexm
        default livecheck.url   {${codeberg.homepage}/commits/branch/${codeberg.livecheck.branch}}
        livecheck.regex         commit/(\[0-9a-f\]{[string length ${codeberg.version}]})\[0-9a-f\]*
    } else {
        livecheck.type          regex
        default livecheck.url   {${codeberg.homepage}/tags.atom}
        default livecheck.regex {[list tag/[join ${codeberg.tag_prefix}][join ${codeberg.livecheck.regex}][join ${codeberg.tag_suffix}]</id>]}
    }
    livecheck.version       ${codeberg.version}
}
