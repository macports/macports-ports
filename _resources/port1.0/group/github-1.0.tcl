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
default github.master_sites {[github.get_master_sites]}

proc github.get_master_sites {} {
    global github.tarball_from github.homepage git.branch
    switch -- ${github.tarball_from} {
        archive {
            # FIXME: Generate a more specific URL. When a branch and tag
            # share the same name, this will fail to resolve correctly.
            #
            # See:
            # https://trac.macports.org/ticket/70652
            # https://docs.github.com/en/repositories/working-with-files/using-files/downloading-source-code-archives#source-code-archive-urls
            return ${github.homepage}/archive/${git.branch}
        }
        downloads {
            # GitHub no longer hosts downloads on their servers.
            return macports_distfiles
        }
        tarball {
            global github.author github.project
            return https://codeload.github.com/${github.author}/${github.project}/legacy.tar.gz/${git.branch}?dummy=
        }
        default {
            # default to 'releases'
            return ${github.homepage}/releases/download/${git.branch}
        }
    }
}

options github.tarball_from
default github.tarball_from releases
option_proc github.tarball_from github.handle_tarball_from
proc github.handle_tarball_from {option action args} {
    if {${action} eq "set"} {
        switch ${args} {
            archive -
            downloads -
            releases -
            tarball {}
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
default github.livecheck.branch HEAD

options github.livecheck.regex
default github.livecheck.regex {(\[^"]+)}

# Controls how tag-based livecheck (see github.setup below) finds the latest
# version. 'tags' (the default) scrapes the repository's /tags page, which
# lists every tag regardless of whether it has an associated GitHub Release;
# projects that tag pre-releases (e.g. release candidates) without publishing
# a Release for them will cause false positives. 'releases/latest' instead
# queries the GitHub REST API for the latest published, non-prerelease,
# non-draft Release, avoiding that problem.
options github.livecheck
default github.livecheck tags
option_proc github.livecheck github.handle_livecheck
proc github.handle_livecheck {option action args} {
    if {${action} eq "set"} {
        switch ${args} {
            tags -
            releases/latest {}
            default {
                return -code error "invalid value \"${args}\" for github.livecheck"
            }
        }
    }
}

proc github.get_livecheck_url {} {
    global github.livecheck github.homepage github.author github.project
    switch -- ${github.livecheck} {
        releases/latest {
            return https://api.github.com/repos/${github.author}/${github.project}/releases/latest
        }
        default {
            return ${github.homepage}/tags
        }
    }
}

proc github.get_livecheck_regex {} {
    global github.livecheck github.tag_prefix github.tag_suffix github.livecheck.regex
    switch -- ${github.livecheck} {
        releases/latest {
            return [list \"tag_name\":\\s*\"[quotemeta [join ${github.tag_prefix}]][join ${github.livecheck.regex}][quotemeta [join ${github.tag_suffix}]]\"]
        }
        default {
            return [list archive/refs/tags/[quotemeta [join ${github.tag_prefix}]][join ${github.livecheck.regex}][quotemeta [join ${github.tag_suffix}]]\\.tar\\.gz]
        }
    }
}

proc github.setup {gh_author gh_project gh_version {gh_tag_prefix ""} {gh_tag_suffix ""}} {
    global github.author github.project github.version github.tag_prefix github.tag_suffix \
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

    default extract.rename  {[expr {${github.tarball_from} in {archive tarball} && [llength ${extract.only}] == 1}]}

    # If the version is composed entirely of hex characters, and is at least 7
    # characters long, and is not exactly 8 decimal digits (which might be a
    # version in YYYYMMDD format), and no tag prefix or suffix is provided, then
    # assume we are using a commit hash and livecheck commits; otherwise
    # livecheck tags.
    if {[join ${github.tag_prefix}] eq "" && \
        [join ${github.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${github.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${github.version}]} {
        default livecheck.type  git
        default livecheck.url   {${git.url}}
        default github.tarball_from archive
    } else {
        livecheck.type          regex
        default livecheck.url   {[github.get_livecheck_url]}
        default livecheck.regex {[github.get_livecheck_regex]}
    }
    default livecheck.branch    {${github.livecheck.branch}}
    livecheck.version           ${github.version}
}
