# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates projects hosted in Gitea
#
# Usage:
#
# PortGroup     gitea 1.0
# gitea.setup   author project 1.0.0 v
#
# This portgroup works very similarly to the github-1.0 portgroup.
#
# For any port that is hosted on gitea.com, or a hosted Gitea instance, this
# portgroup can be used to automatically setup details like project name,
# master_sites, livecheck options and more.
#
# Using gitea.setup, the format is:
#
# gitea.setup   <author> <project_name> <version> <version_prefix> <version_suffix>
#
# If a project is on a hosted Gitea instance, that can be set using the
# 'gitea.domain' option:
#
# gitea.domain  mydomain.com/gitea

options gitea.author gitea.project gitea.version gitea.tag_prefix gitea.tag_suffix

options gitea.domain
default gitea.domain        gitea.com

options gitea.homepage
default gitea.homepage      {https://${gitea.domain}/${gitea.author}/${gitea.project}}

options gitea.master_sites
default gitea.master_sites  {${gitea.homepage}/archive}

options gitea.livecheck.branch
default gitea.livecheck.branch master

options gitea.livecheck.regex
default gitea.livecheck.regex {(\[0-9]\[^<]+)}

proc gitea.setup {gitea_author gitea_project gitea_version {gitea_tag_prefix ""} {gitea_tag_suffix ""}} {
    global gitea.author gitea.project gitea.version gitea.tag_prefix gitea.tag_suffix
    global gitea.homepage gitea.master_sites gitea.livecheck.branch gitea.livecheck.regex
    global PortInfo

    gitea.author            ${gitea_author}
    gitea.project           ${gitea_project}
    gitea.version           ${gitea_version}
    gitea.tag_prefix        ${gitea_tag_prefix}
    gitea.tag_suffix        ${gitea_tag_suffix}

    if {![info exists PortInfo(name)]} {
        name                ${gitea.project}
        dist_subdir         ${gitea.project}
    } elseif {
        dist_subdir         ${PortInfo(name)}
    }

    version                 ${gitea.version}
    default homepage        ${gitea.homepage}
    git.url                 ${gitea.homepage}.git

    set _gitea_branch       [join ${gitea.tag_prefix}]${gitea.version}[join ${gitea.tag_suffix}]

    git.branch              ${_gitea_branch}
    default master_sites    ${gitea.master_sites}
    distname                ${_gitea_branch}

    if {[join ${gitea.tag_prefix}] eq "" && \
        [join ${gitea.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${gitea.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${gitea.version}]} {
        livecheck.type          regexm
        default livecheck.url   {${gitea.homepage}/commits/${gitea.livecheck.branch}}
        livecheck.regex         commit/(\[0-9a-f\]{[string length ${gitea.version}]})\[0-9a-f\]*
    } else {
        livecheck.type          regex
        default livecheck.url   {${gitea.homepage}/tags}
        default livecheck.regex {[list archive/[join ${gitea.tag_prefix}][join ${gitea.livecheck.regex}][join ${gitea.tag_suffix}]\\.tar\\.gz]}
    }
    livecheck.version       ${gitea.version}
}
