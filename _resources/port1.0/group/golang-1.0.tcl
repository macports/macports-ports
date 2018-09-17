# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates golang projects.
#
# Usage:
#
# PortGroup     golang 1.0
#
# go.setup      example.com/author/project 1.0.0 v
#
# go.vendors    example.com/dep1/foo abcdef123456... \
#               example.com/dep2/bar fedcba654321...
#
# checksums-append \
#               ${foo.distfile} \
#                   rmd160 abcdef123456... \
#                   sha256 fedcba654321... \
#                   size   1234 \
#               ${bar.distfile} \
#                   rmd160 abcdef123456... \
#                   sha256 fedcba654321... \
#                   size   4321
#
# The github-1.0 or bitbucket-1.0 portgroups are automatically applied and set
# up for projects hosted on GitHub or Bitbucket; in these cases it is not
# necessary to specify the portgroups or call github.setup or bitbucket.setup,
# i.e. the following are sufficient:
#
# PortGroup     golang 1.0
# go.setup      github.com/author/project 1.0.0 v
#
# or
#
# PortGroup     golang 1.0
# go.setup      bitbucket.com/author/project 1.0.0 v
#
# The go.vendors option expects a list with 2-tuples consisting of package ID
# and git SHA1.
#
# The list of vendors can be found in the Gopkg.lock, glide.lock, etc. file in
# the upstream source code. The go2port tool (install via MacPorts) can be used
# to generate a skeleton portfile with precomputed go.vendors and
# checksums-append values.

options go.package go.domain go.author go.project go.version go.tag_prefix go.tag_suffix

proc go.setup {go_package go_version {go_tag_prefix ""} {go_tag_suffix ""}} {
    global go.package go.domain go.author go.project go.version go.tag_prefix go.tag_suffix

    go.package          ${go_package}
    go.version          ${go_version}

    set parts [go._translate_package_id ${go_package}]

    go.domain           [lindex ${parts} 0]
    go.author           [lindex ${parts} 1]
    go.project          [lindex ${parts} 2]
    switch ${go.domain} {
        github.com {
            uplevel "PortGroup github 1.0"
            github.setup ${go.author} ${go.project} ${go_version} ${go_tag_prefix} ${go_tag_suffix}
        }
        bitbucket.org {
            uplevel "PortGroup bitbucket 1.0"
            bitbucket.setup ${go.author} ${go.project} ${go_version} ${go_tag_prefix}
        }
        default {
            if {!([info exists PortInfo(name)] && (${PortInfo(name)} ne ${go.project}))} {
                name    ${go.project}
            }
            version     ${go.version}
        }
    }
}

proc go._translate_package_id {package_id} {
    set parts [split ${package_id} /]

    set domain [lindex ${parts} 0]
    set author [lindex ${parts} 1]
    set project [lindex ${parts} 2]

    switch ${domain} {
        golang.org {
            # Use GitHub mirror
            set domain github.com
            set author golang
        }
        gopkg.in {
            # gopkg.in redirects to GitHub
            set domain github.com
            if {${project} eq ""} {
                # Short format: gopkg.in/foo.v1 -> github.com/go-foo/foo
                set project [go._strip_gopkg_version ${author}]
                set author go-${project}
            } else {
                # Long format: gopkg.in/foo/bar.v1 -> github.com/foo/bar
                set project [go._strip_gopkg_version ${project}]
            }
        }
    }
    return [list ${domain} ${author} ${project}]
}

proc go._strip_gopkg_version {str} {
    return [regsub -- \\..*$ ${str} ""]
}

options go.bin go.vendors

default go.bin          {${prefix}/bin/go}
default go.vendors      {}

platforms               darwin freebsd linux
supported_archs         i386 x86_64
set goos                ${os.platform}

switch ${build_arch} {
    i386    { set goarch 386 }
    x86_64  { set goarch amd64 }
    default { set goarch {} }
}

default use_configure   no
default dist_subdir     go

default depends_build   port:go

set gopath              ${workpath}/gopath
default worksrcdir      {${gopath}/src/${go.package}}

default build.cmd       {"${go.bin} build"}
build.args
build.target
default build.env       {"GOPATH=${gopath} GOARCH=${goarch} GOOS=${goos} CC=${configure.cc}"}

# go.vendors name1 ver1 name2 ver2...
# When a Gopkg.lock, glide.lock, etc. is present use go2port to generate values
set go.vendors_internal {}
option_proc go.vendors handle_go_vendors
proc handle_go_vendors {option action {value ""}} {
    global go.vendors_internal
    if {${action} eq "set"} {
        foreach {vpackage vers} ${value} {
            set vlist [go._translate_package_id ${vpackage}]

            set vdomain [lindex ${vlist} 0]
            set vauthor [lindex ${vlist} 1]
            set vproject [lindex ${vlist} 2]

            # The vauthor may be wrong (the project has been renamed/changed
            # ownership) so we need to use the SHA-1 suffix later to identify
            # the package when moving into the GOPATH. GitHub uses 7 digits;
            # Bitbucket uses 12. We take 7 and use globbing.
            set sha1_short [string range ${vers} 0 6]
            lappend go.vendors_internal [list ${sha1_short} ${vpackage} ${vers}]

            global ${vproject}.version
            set ${vproject}.version ${vers}

            switch -exact ${vdomain} {
                github.com {
                    set distfile ${vauthor}-${vproject}-${vers}.tar.gz
                    set master_site https://github.com/${vauthor}/${vproject}/tarball/${vers}
                }
                bitbucket.org {
                    set distfile ${vers}.tar.gz
                    set master_site https://bitbucket.org/${vauthor}/${vproject}/get
                }
                default {
                    ui_error "go.vendors can't handle dependencies from ${vdomain}"
                    error "unsupported dependency domain"
                }
            }

            global ${vproject}.distfile
            set ${vproject}.distfile ${distfile}

            set tag ${vauthor}-${vproject}
            master_sites-append ${master_site}:${tag}
            distfiles-append    ${distfile}:${tag}
        }
    }
}

# Setup build sources in GOPATH style:
#   workpath/
#       gopath/src/example.com/
#           author1/project1/
#           author2/project2/
#             :
#
# Danger! These manipulations depend heavily on the filenames resulting from
# expanding the distfiles. GitHub and Bitbucket are known to work:
#
# - GitHub: ${author}-${project}-${7-digit hash}
# - Bitbucket: ${author}-${project}-${12-digit hash}
#
# Support for additional hosts not conforming to this pattern will take some
# work.
post-extract {
    if {${fetch.type} eq "standard"} {
        file mkdir ${gopath}/src/${go.domain}/${go.author}
        move [glob ${workpath}/${go.author}-${go.project}-*] ${worksrcpath}
    }

    foreach vlist ${go.vendors_internal} {
        set sha1_short [lindex ${vlist} 0]
        set vpackage [lindex ${vlist} 1]
        file mkdir ${gopath}/src/[file dirname ${vpackage}]
        move [glob ${workpath}/*-${sha1_short}*] ${gopath}/src/${vpackage}
    }
}

destroot {
    ui_error "No destroot phase in the Portfile!"
    ui_msg "Here is an example destroot phase:"
    ui_msg
    ui_msg "destroot {"
    ui_msg {    xinstall -m 755 ${worksrcpath}/${name} ${destroot}${prefix}/bin/}
    ui_msg "}"
    ui_msg
    ui_msg "Please check if there are additional files (configuration, documentation, etc.) that need to be installed."
    error "destroot phase not implemented"
}
