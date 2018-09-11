# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup sets up default behaviors for projects hosted at bitbucket.
#
# Usage:
#
#   PortGroup               bitbucket 1.0
#   bitbucket.setup         author project version [tag_prefix]

options bitbucket.author bitbucket.project bitbucket.version bitbucket.tag_prefix
options bitbucket.homepage bitbucket.master_sites bitbucket.tarball_from
options bitbucket.livecheck_branch

default bitbucket.homepage {https://bitbucket.org/${bitbucket.author}/${bitbucket.project}}

# Later code assumes that bitbucket.master_sites is a simple string, not a list.
default bitbucket.master_sites {${bitbucket.homepage}/get}
default bitbucket.tarball_from tags

default master_sites {${bitbucket.master_sites}}

option_proc bitbucket.tarball_from handle_tarball_from

proc handle_tarball_from {option action args} {
    global bitbucket.author bitbucket.project bitbucket.master_sites bitbucket.version

    # the port writer can set bitbucket.tarball_from to "downloads" and have the URI path accordingly changed
    if {[string equal ${action} "set"] && ${args} eq "downloads"} {
        bitbucket.tarball_from ${args}
        bitbucket.master_sites https://bitbucket.org/${bitbucket.author}/${bitbucket.project}/downloads
        default livecheck.url {${bitbucket.master_sites}}
        default distname {${bitbucket.project}-${bitbucket.version}}
    }
}

proc bitbucket.livecheck_regex {} {
    global bitbucket.tag_prefix bitbucket.tarball_from distname extract.suffix version
    switch ${bitbucket.tarball_from} {
        tags {
            set dir get
        }
        default {
            set dir ${bitbucket.tarball_from}
        }
    }
    return ${dir}/[regsub -- [quotemeta ${version}] ${distname} {([0-9.]+)}][quotemeta [quotemeta ${extract.suffix}]]
}

proc bitbucket.setup {bb_author bb_project bb_version {bb_tag_prefix ""}} {
    global bitbucket.author bitbucket.homepage bitbucket.master_sites bitbucket.project bitbucket.tag_prefix bitbucket.version extract.suffix PortInfo

    bitbucket.author        ${bb_author}
    bitbucket.project       ${bb_project}
    bitbucket.version       ${bb_version}
    bitbucket.tag_prefix    ${bb_tag_prefix}

    if {!([info exists PortInfo(name)] && (${PortInfo(name)} ne ${bitbucket.project}))} {
        name                ${bitbucket.project}
    }
    version                 ${bitbucket.version}
    homepage                ${bitbucket.homepage}
    hg.url                  ${bitbucket.homepage}
    hg.tag                  [join ${bitbucket.tag_prefix}]${bitbucket.version}
    default distname        {${hg.tag}}
    fetch.ignore_sslcert    yes

    post-extract {
        # It is assumed that bitbucket.master_sites is a simple string, not a list.
        # Here be dragons.
        if {![file exists ${worksrcpath}] && \
            ${fetch.type} eq "standard" && \
            ${bitbucket.master_sites} in ${master_sites} && \
            [llength ${distfiles}] > 0 && \
            [llength [glob -nocomplain ${workpath}/*]] > 0} {
            move [glob ${workpath}/*] ${worksrcpath}
        }
    }

    if {[join ${bitbucket.tag_prefix}] eq "" && \
        [regexp "^\[0-9a-f\]{9,}\$" ${bitbucket.version}]} {
        default livecheck.type      regexm
        default livecheck.url       {${bitbucket.homepage}/atom}
        default livecheck.regex     {<id>changeset:(\[0-9a-f\]{[string length ${bitbucket.version}]})\[0-9a-f\]*</id>}
    } else {
        default livecheck.type      regex
        default livecheck.url       {${bitbucket.homepage}/downloads?tab=tags}
        default livecheck.regex     {[bitbucket.livecheck_regex]}
    }

    default livecheck.version   {${bitbucket.version}}
}

# proc that sets the livecheck to only check a branch instead of the newest
# commits (meant to be used when the version is a hash); to be called *after*
# bitbucket.setup
proc bitbucket.livecheck {bb_branch} {
    global bitbucket.homepage bitbucket.author bitbucket.project bitbucket.version

    livecheck.url       ${bitbucket.homepage}/commits/branch/${bb_branch}
    livecheck.type      regexm
    livecheck.regex     <a  class="hash execute" href="/${bitbucket.author}/${bitbucket.project}/commits/(\[0-9a-f\]{[string length ${bitbucket.version}]}).*"
}
