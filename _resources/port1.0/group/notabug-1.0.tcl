# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates projects hosted in notabug.org.
#
# Usage:
#
# PortGroup       notabug 1.0
# notabug.setup  author project 1.0.0 v
#
# This portgroup works very similarly to the gitea-1.0 portgroup.
#
# For any port that is hosted on notabug.org this portgroup can be used to
# automatically setup details like project name, master_sites, livecheck options
# and more.
#
# Using notabug.setup, the format is:
#
# notabug.setup  <author> <project_name> <version> <version_prefix> <version_suffix>

options notabug.author notabug.project notabug.version notabug.tag_prefix notabug.tag_suffix

options notabug.homepage
default notabug.homepage            {https://notabug.org/${notabug.author}/${notabug.project}}

options notabug.master_sites
default notabug.master_sites        {${notabug.homepage}/archive}

options notabug.livecheck.branch
default notabug.livecheck.branch    master

options notabug.livecheck.regex
default notabug.livecheck.regex     {(\[0-9]\[^<]+)}

proc notabug.setup {notabug_author notabug_project notabug_version {notabug_tag_prefix ""} {notabug_tag_suffix ""}} {
    global notabug.author notabug.project notabug.version notabug.tag_prefix notabug.tag_suffix
    global notabug.homepage notabug.master_sites notabug.livecheck.branch notabug.livecheck.regex
    global PortInfo

    notabug.author              ${notabug_author}
    notabug.project             ${notabug_project}
    notabug.version             ${notabug_version}
    notabug.tag_prefix          ${notabug_tag_prefix}
    notabug.tag_suffix          ${notabug_tag_suffix}

    if {![info exists PortInfo(name)]} {
        name                    ${notabug.project}
        dist_subdir             ${notabug.project}
    }

    version                     ${notabug.version}
    default homepage            ${notabug.homepage}
    git.url                     ${notabug.homepage}.git

    set _notabug_branch        [join ${notabug.tag_prefix}]${notabug.version}[join ${notabug.tag_suffix}]

    git.branch                  ${_notabug_branch}
    default master_sites        ${notabug.master_sites}
    distname                    ${_notabug_branch}

    default extract.rename      yes

    if {[join ${notabug.tag_prefix}] eq "" && \
        [join ${notabug.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${notabug.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${notabug.version}]} {
        livecheck.type          regexm
        default livecheck.url   {${notabug.homepage}/commits/${notabug.livecheck.branch}}
        livecheck.regex         /${notabug.author}/${notabug.project}/commit/(\[0-9a-f\]{[string length ${notabug.version}]})\[0-9a-f\]*
    } else {
        livecheck.type          regex
        default livecheck.url   {${notabug.homepage}/releases}
        default livecheck.regex {[list /${notabug.author}/${notabug.project}/archive/[join ${notabug.tag_prefix}][join ${notabug.livecheck.regex}${extract.suffix}][join ${notabug.tag_suffix}]]}
    }
    livecheck.version       ${notabug.version}
}
