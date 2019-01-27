# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates projects hosted at GitHub, GitLab
# or self-hosted instances of GitLab.
#
# Documentation:
# https://guide.macports.org/#reference.portgroup.git_access
#
# Documentation (sources):
# https://github.com/macports/macports-guide/blob/master/guide/xml/portgroup-git_access.xml

options git.author git.project git.version git.tag_prefix git.tag_suffix

# Some git hosts/services, like GitLab (and Bitbucket Enterprise?), can be
# installed anywhere (ie self-hosted). The option git.domain can be used to set
# up a domain like: https://git.domain.tld
options git.domain github.domain git.host
default git.domain {${git.domain}}
default github.domain {https://github.com}
default git.host {github}

options git.homepage git.branch
default git.homepage {${github.domain}/${git.author}/${git.project}}
default git.branch {master}

options git.raw git.master_sites
default git.raw {https://raw.githubusercontent.com/${git.author}/${git.project}}

# Later code assumes that git.master_sites is a simple string, not a list.
default git.master_sites {${git.homepage}/tarball/${git.branch}}


# This “option_proc” is the one called from the Portfile
# It takes the parameters, creates and set new paths to the environment to use
# with the additional services (GitLab, Bitbucket, etc) - and then pass them on
# to “__setup” ...using the same input: __setup {*}${git.setup}
options git.setup
default git.setup {github}
option_proc git.setup ga.args
proc ga.args {option action args} {
    global git.setup git.host git.author git.project git.version git.tag_prefix git.tag_suffix
    global git.domain github.domain git.homepage git.branch git.raw git.master_sites

    if {${action} eq "set"} {
        # Use 1st parameter for git.host
        set git.host [lindex "${git.setup}" 0]

        switch ${git.host} {
            gitlab {
                default git.domain          {https://gitlab.com}
                default git.homepage        {${git.domain}/${git.author}/${git.project}}
                default git.raw             {${git.homepage}/raw}
                default git.master_sites    {${git.homepage}/-/archive/${git.branch}}

                # Use *.tar.bz2 …since GitLab have that option
                use_bzip2 yes
            }
            bitbucket {
                default git.domain          {https://bitbucket.org}
                default git.homepage        {${git.domain}/${git.author}/${git.project}}
                default git.raw             {}

                # Later code assumes that bitbucket.master_sites is a simple string, not a list.
                default git.master_sites    {${git.homepage}/get}
            }
            #gogs -
            #gitea {}
            github -
            default { default git.domain {${github.domain}} }
        }

        __setup {*}${git.setup}
    }
}


# GitHub and Bitbucket
options git.tarball_from
default git.tarball_from {tarball}
option_proc git.tarball_from handle_tarball_from
proc handle_tarball_from {option action args} {
    global git.host git.domain github.domain git.homepage
    global git.author git.project git.master_sites git.branch git.version

    if {${action} eq "set"} {
        git.tarball_from ${args}

        switch ${git.host} {
            bitbucket {
                # the port writer can set git.tarball_from to "downloads"
                # and have the URI path accordingly changed
                if {${args} eq "downloads"} {
                    git.master_sites        ${git.homepage}/downloads
                    default livecheck.url   {${git.master_sites}}
                    default distname        {${git.project}-${git.version}}
                }
            }
            #gogs -
            #gitea {}
            github -
            default {
                switch ${args} {
                    downloads   {git.master_sites ${github.domain}/downloads/${git.author}/${git.project}}
                    releases    {git.master_sites ${git.homepage}/releases/download/${git.branch}}
                    archive     {git.master_sites ${git.homepage}/archive/${git.branch}}
                    tarball     {git.master_sites ${git.homepage}/tarball/${git.branch}}
                    tags        {return -code error "the value \"tags\" is deprecated for git.tarball_from.\
                                                     Please use \"tarball\" instead."}
                    default     {return -code error "invalid value \"${args}\" for git.tarball_from"}
                }
            }
        }; # end git.host
    }; # end action
}

options git.livecheck.branch git.livecheck.regex
default git.livecheck.branch {master}
default git.livecheck.regex {(\[^"]+)}

# Main proc
proc __setup {ga_host ga_author ga_project ga_version {ga_tag_prefix ""} {ga_tag_suffix ""}} {
    global extract.suffix git.author git.project git.version git.tag_prefix git.tag_suffix
    global git.host git.domain github.domain git.homepage git.master_sites git.branch git.livecheck.branch
    global git.tarball_from version distname PortInfo hg.url hg.tag

    git.host                ${ga_host}
    git.author              ${ga_author}
    git.project             ${ga_project}
    git.version             ${ga_version}
    git.tag_prefix          ${ga_tag_prefix}
    git.tag_suffix          ${ga_tag_suffix}

    if {!([info exists PortInfo(name)] && (${PortInfo(name)} ne ${git.project}))} {
        name                    ${git.project}
    }

    version                 ${git.version}
    default homepage        ${git.homepage}
    git.url                 ${git.homepage}.git
    git.branch              [join ${git.tag_prefix}]${git.version}[join ${git.tag_suffix}]
    default master_sites    {${git.master_sites}}
    default distname        {${git.project}-${git.version}}

    if {${git.host} eq "bitbucket"} {
        hg.url                  ${git.homepage}
        hg.tag                  [join ${git.tag_prefix}]${git.version}
        #default distname        {${hg.tag}}
        fetch.ignore_sslcert    yes
    }

    post-extract {
        # When fetching from a tag, the extracted directory name will contain a
        # truncated commit hash. So that the port author need not specify what
        # that hash is every time the version number changes, rename the
        # directory to the value of distname (not worksrcdir: ports may want to
        # set worksrcdir to a subdirectory of the extracted directory).
        # It is assumed that git.master_sites is a simple string, not a list.
        # Here be dragons.
        if {![file exists ${worksrcpath}] && \
                ${fetch.type} eq "standard" && \
                ${git.master_sites} in ${master_sites} && \
                [llength ${distfiles}] > 0 && \
                [llength [glob -nocomplain ${workpath}/*]] > 0} {
            if {[file exists [glob -nocomplain ${workpath}/*${git.project}-*]] && \
                [file isdirectory [glob -nocomplain ${workpath}/*${git.project}-*]]} {
                move [glob ${workpath}/*${git.project}-*] ${workpath}/${distname}
            } else {
                # tarball is not "*${git.project}-*"
                ui_error "\n\ngit_access PortGroup: Error: \${worksrcpath} does not exist after extracting distfiles. This might indicate that the author or project is different than set in the Portfile due to a rename at the git host. Please examine the extracted directory in ${workpath} and try to correct the Portfile by either changing the author or project or adding the worksrcdir option with the correct directory name.\n"
                return -code error "Unexpected git tarball extract."
            }
        }
    }

    # If the version is composed entirely of hex characters, and is at least 7
    # characters long, and is not exactly 8 decimal digits (which might be a
    # version in YYYYMMDD format), and no tag prefix or suffix is provided, then
    # assume we are using a commit hash and livecheck commits; otherwise
    # livecheck tags.
    if {[join ${git.tag_prefix}] eq "" && \
        [join ${git.tag_suffix}] eq "" && \
        [regexp "^\[0-9a-f\]{7,}\$" ${git.version}] && \
        ![regexp "^\[0-9\]{8}\$" ${git.version}]} {
        livecheck.type regexm
        default livecheck.url {${git.homepage}/commits/${git.livecheck.branch}.atom}

        switch ${git.host} {
            gitlab {
                set git.regex {<id>${git.homepage}/commit/(\[0-9a-f\]{[string length ${git.version}]})\[0-9a-f\]*</id>}
            }
            bitbucket {
                default livecheck.url {${git.homepage}/atom}
                set git.regex {<id>changeset:(\[0-9a-f\]{[string length ${git.version}]})\[0-9a-f\]*</id>}
            }
            #gogs -
            #gitea {}
            github -
            default {
                set git.regex {<id>tag:[regsub (^http(s)?://)+ ${github.domain} ""],2008:Grit::Commit/(\[0-9a-f\]{[string length ${git.version}]})\[0-9a-f\]*</id>}
            }
        }

        # surrounding {}'s are set in the switch
        default livecheck.regex ${git.regex}
    } else {
        livecheck.type regex
        default git.livecheck_suffix ${extract.suffix}
        set host.regex {[list archive/[join ${git.tag_prefix}][join ${git.livecheck.regex}][join ${git.tag_suffix}]${git.livecheck_suffix}]}

        switch ${git.host} {
            gitlab {
                default livecheck.url {${git.homepage}/-/tags}
            }
            bitbucket {
                default livecheck.url {${git.homepage}/downloads?tab=tags}
                set dir [expr {${git.tarball_from} eq {tags} ? {get} : ${git.tarball_from} }]
                set host.regex ${dir}/[regsub -- [quotemeta ${version}] ${distname} {(\[0-9.\]+)}][quotemeta [quotemeta ${extract.suffix}]]
            }
            #gogs -
            #gitea {}
            github -
            default {
                default livecheck.url {${git.homepage}/tags}
                default git.livecheck_suffix {\\.tar\\.gz}
            }
        }

        # surrounding {}'s are set in the switch
        default livecheck.regex ${host.regex}
    }

    livecheck.version ${git.version}
}


# Bitbucket Xtras
# ------------------
# proc that sets the livecheck to only check a branch instead of the newest
# commits (meant to be used when the version is a hash); to be called *after*
# git.setup
proc git.livecheck {branch} {
    global git.host git.homepage git.author git.project git.version

    if {${git.host} ne "bitbucket"} { return }

    livecheck.url       ${git.homepage}/commits/branch/${branch}
    livecheck.type      regexm
    livecheck.regex     <a  class="hash execute" href="/${git.author}/${git.project}/commits/(\[0-9a-f\]{[string length ${git.version}]}).*"
}
