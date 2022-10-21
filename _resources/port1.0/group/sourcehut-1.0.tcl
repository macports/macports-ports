# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates projects hosted with sourcehut, either at sr.ht
# or on individual instances (via sourcehut.instance)

options sourcehut.author sourcehut.project sourcehut.version sourcehut.tag_prefix sourcehut.tag_suffix

options sourcehut.instance
default sourcehut.instance {https://git.sr.ht}

options sourcehut.homepage
default sourcehut.homepage {${sourcehut.instance}/~${sourcehut.author}/${sourcehut.project}}

# Later code assumes that sourcehut.master_sites is a simple string, not a list.
options sourcehut.master_sites
default sourcehut.master_sites {${sourcehut.homepage}/archive/}

options sourcehut.livecheck.branch
default sourcehut.livecheck.branch master

options sourcehut.livecheck.regex
default sourcehut.livecheck.regex {(\[0-9]\[^<]+)}

proc sourcehut.setup {srht_author srht_project srht_version {srht_tag_prefix ""} {srht_tag_suffix ""}} {
    global extract.suffix sourcehut.author sourcehut.project sourcehut.version sourcehut.tag_prefix sourcehut.tag_suffix
    global sourcehut.homepage sourcehut.master_sites sourcehut.livecheck.branch PortInfo

    sourcehut.author           ${srht_author}
    sourcehut.project          ${srht_project}
    sourcehut.version          ${srht_version}
    sourcehut.tag_prefix       ${srht_tag_prefix}
    sourcehut.tag_suffix       ${srht_tag_suffix}

    if {![info exists PortInfo(name)]} {
        name                ${sourcehut.project}
    }

    version                 ${sourcehut.version}
    default homepage        ${sourcehut.homepage}
    git.url                 ${sourcehut.homepage}
    git.branch              [join ${sourcehut.tag_prefix}]${sourcehut.version}[join ${sourcehut.tag_suffix}]
    default master_sites    {${sourcehut.master_sites}}
    distname                [join ${sourcehut.tag_prefix}]${sourcehut.version}[join ${sourcehut.tag_suffix}]

    # If the version is composed entirely of hex characters, and is at least 7
    # characters long, and is not exactly 8 decimal digits (which might be a
    # version in YYYYMMDD format), and no tag prefix or suffix is provided, then
    # assume we are using a commit hash and livecheck commits; otherwise
    # livecheck tags.
    if {[join ${sourcehut.tag_prefix}] eq "" && \
        [join ${sourcehut.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${sourcehut.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${sourcehut.version}]} {
        livecheck.type          regexm
        default livecheck.url   {${sourcehut.homepage}/log/${sourcehut.livecheck.branch}/rss.xml}
        default livecheck.regex {commit/(\[0-9a-f\]{[string length ${sourcehut.version}]})\[0-9a-f\]*</guid>}
    } else {
        livecheck.type          regex
        default livecheck.url   {${sourcehut.homepage}/refs/rss.xml}
        default livecheck.regex {refs/[join ${sourcehut.tag_prefix}][join ${sourcehut.livecheck.regex}][join ${sourcehut.tag_suffix}]</guid>}
    }
    livecheck.version       ${sourcehut.version}
}
