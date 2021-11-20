# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates projects hosted with gitlab, either at gitlab.com
# or on individual instances (via gitlab.instance)
#
# Documentation: <NOT THERE YET>
# https://guide.macports.org/#reference.portgroup.gitlab
#
# Documentation (sources): <NOT THERE YET>
# https://gitlab.com/macports/macports-guide/blob/master/guide/xml/portgroup-gitlab.xml

options gitlab.author gitlab.project gitlab.version gitlab.tag_prefix gitlab.tag_suffix

options gitlab.instance
default gitlab.instance {https://gitlab.com}

options gitlab.homepage
default gitlab.homepage {${gitlab.instance}/${gitlab.author}/${gitlab.project}}

# Later code assumes that gitlab.master_sites is a simple string, not a list.
options gitlab.master_sites
default gitlab.master_sites {${gitlab.homepage}/-/archive/${git.branch}}

options gitlab.livecheck.branch
default gitlab.livecheck.branch master

options gitlab.livecheck.regex
default gitlab.livecheck.regex {(\[0-9]\[^<]+)}

proc gitlab.setup {gl_author gl_project gl_version {gl_tag_prefix ""} {gl_tag_suffix ""}} {
    global extract.suffix gitlab.author gitlab.project gitlab.version gitlab.tag_prefix gitlab.tag_suffix
    global gitlab.homepage gitlab.master_sites gitlab.livecheck.branch PortInfo

    gitlab.author           ${gl_author}
    gitlab.project          ${gl_project}
    gitlab.version          ${gl_version}
    gitlab.tag_prefix       ${gl_tag_prefix}
    gitlab.tag_suffix       ${gl_tag_suffix}

    if {![info exists PortInfo(name)]} {
        name                ${gitlab.project}
    }

    version                 ${gitlab.version}
    default homepage        ${gitlab.homepage}
    git.url                 ${gitlab.homepage}.git
    git.branch              [join ${gitlab.tag_prefix}]${gitlab.version}[join ${gitlab.tag_suffix}]
    default master_sites    {${gitlab.master_sites}}
    distname                ${gitlab.project}-${gitlab.version}
    use_bzip2               yes

# I don't _think_ we need this bit from the github portgroup, but keeping
# around until we have more use cases...
#    post-extract {
#        # When fetching from a tag, the extracted directory name will contain a
#        # truncated commit hash. So that the port author need not specify what
#        # that hash is every time the version number changes, rename the
#        # directory to the value of distname (not worksrcdir: ports may want to
#        # set worksrcdir to a subdirectory of the extracted directory).
#        # It is assumed that gitlab.master_sites is a simple string, not a list.
#        # Here be dragons.
#        if {![file exists ${worksrcpath}] && \
#                ${fetch.type} eq "standard" && \
#                ${gitlab.master_sites} in ${master_sites} && \
#                [llength ${distfiles}] > 0 && \
#                [llength [glob -nocomplain ${workpath}/*]] > 0} {
#            if {[file exists [glob -nocomplain ${workpath}/${gitlab.author}-${gitlab.project}-*]] && \
#                [file isdirectory [glob -nocomplain ${workpath}/${gitlab.author}-${gitlab.project}-*]]} {
#                move [glob ${workpath}/${gitlab.author}-${gitlab.project}-*] ${workpath}/${distname}
#            } else {
#                # tarball is not "${gitlab.author}-${gitlab.project}-*"
#                ui_error "\n\ngitlab PortGroup: Error: \${worksrcpath} does not exist after extracting distfiles. This might indicate that the author or project is different than set in the Portfile due to a rename at GitHub. Please examine the extracted directory in ${workpath} and try to correct the Portfile by either changing the author or project or adding the worksrcdir option with the correct directory name.\n"
#                return -code error "Unexpected gitlab tarball extract."
#            }
#        }
#    }

    # If the version is composed entirely of hex characters, and is at least 7
    # characters long, and is not exactly 8 decimal digits (which might be a
    # version in YYYYMMDD format), and no tag prefix or suffix is provided, then
    # assume we are using a commit hash and livecheck commits; otherwise
    # livecheck tags.
    if {[join ${gitlab.tag_prefix}] eq "" && \
        [join ${gitlab.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${gitlab.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${gitlab.version}]} {
        livecheck.type      regexm
        default livecheck.url   {${gitlab.homepage}/-/commits/${gitlab.livecheck.branch}?format=atom}
        livecheck.regex     commit/(\[0-9a-f\]{[string length ${gitlab.version}]})\[0-9a-f\]*</id>
    } else {
        livecheck.type      regex
        livecheck.url       ${gitlab.homepage}/-/tags?format=atom
        default livecheck.regex {[list tags/[join ${gitlab.tag_prefix}][join ${gitlab.livecheck.regex}][join ${gitlab.tag_suffix}]</id>]}
    }
    livecheck.version       ${gitlab.version}
}
