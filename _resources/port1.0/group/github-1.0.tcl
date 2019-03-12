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
default github.master_sites {${github.homepage}/tarball/${git.branch}}

default master_sites {${github.master_sites}}

options github.tarball_from
default github.tarball_from tags
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

options github.livecheck.branch
default github.livecheck.branch master

options github.livecheck.regex
if {[vercmp [macports_version] 2.5.3] <= 0} {
    default github.livecheck.regex {{([^"]+)}}
} else {
    default github.livecheck.regex {(\[^"]+)}
}

proc github.setup {gh_author gh_project gh_version {gh_tag_prefix ""} {gh_tag_suffix ""}} {
    global extract.suffix github.author github.project github.version github.tag_prefix github.tag_suffix
    global github.homepage github.master_sites github.livecheck.branch PortInfo

    github.author           ${gh_author}
    github.project          ${gh_project}
    github.version          ${gh_version}
    github.tag_prefix       ${gh_tag_prefix}
    github.tag_suffix       ${gh_tag_suffix}

    if {!([info exists PortInfo(name)] && (${PortInfo(name)} ne ${github.project}))} {
        name                ${github.project}
    }

    version                 ${github.version}
    homepage                ${github.homepage}
    git.url                 ${github.homepage}.git
    git.branch              [join ${github.tag_prefix}]${github.version}[join ${github.tag_suffix}]
    distname                ${github.project}-${github.version}

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
                ${github.master_sites} in ${master_sites} && \
                [llength ${distfiles}] > 0 && \
                [llength [glob -nocomplain ${workpath}/*]] > 0} {
            if {[file exists [glob -nocomplain ${workpath}/${github.author}-${github.project}-*]] && \
                [file isdirectory [glob -nocomplain ${workpath}/${github.author}-${github.project}-*]]} {
                move [glob ${workpath}/${github.author}-${github.project}-*] ${workpath}/${distname}
            } else {
                # tarball is not "${github.author}-${github.project}-*"
                ui_error "\n\ngithub PortGroup: Error: \${worksrcpath} does not exist after extracting distfiles. This might indicate that the author or project is different than set in the Portfile due to a rename at GitHub. Please examine the extracted directory in ${workpath} and try to correct the Portfile by either changing the author or project or adding the worksrcdir option with the correct directory name.\n"
                return -code error "Unexpected github tarball extract."
            }
        }
    }

    # If the version is composed entirely of hex characters, and is at least 7
    # characters long, and is not exactly 8 decimal digits (which might be a
    # version in YYYYMMDD format), and no tag prefix or suffix is provided, then
    # assume we are using a commit hash and livecheck commits; otherwise
    # livecheck tags.
    if {[join ${github.tag_prefix}] eq "" && \
        [join ${github.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${github.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${github.version}]} {
        livecheck.type      regexm
        default livecheck.url   {${github.homepage}/commits/${github.livecheck.branch}.atom}
        livecheck.regex     <id>tag:github.com,2008:Grit::Commit/(\[0-9a-f\]{[string length ${github.version}]})\[0-9a-f\]*</id>
    } else {
        livecheck.type      regex
        livecheck.url       ${github.homepage}/tags
        default livecheck.regex {[list archive/[join ${github.tag_prefix}][join ${github.livecheck.regex}][join ${github.tag_suffix}]\\.tar\\.gz]}
    }
    livecheck.version       ${github.version}
}
