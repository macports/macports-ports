# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates golang projects hosted at GitHub.
#
# Usage:
#
# PortGroup     golang 1.0
#
# github.setup  author project 1.0.0 v
#
# go.vendors    github.com/dep1/foo abcdef123456... \
#               github.com/dep2/bar fedcba654321...
#
# checksums-append \
#               dep1-foo-${foo.version}.tar.gz \
#                   rmd160 abcdef123456... \
#                   sha256 fedcba654321... \
#                   size   1234 \
#               dep2-bar-${bar.version}.tar.gz \
#                   rmd160 abcdef123456... \
#                   sha256 fedcba654321... \
#                   size   4321
#
# The go.vendors option expects a list with 2-tuples consisting of package ID
# and git SHA1.
#
# The list of vendors can be found in the Gopkg.lock, glide.lock, etc. file in
# the upstream source code. The go2port tool (install via MacPorts) can be used
# to generate a skeleton portfile with precomputed go.vendors and
# checksums-append values.

PortGroup               github 1.0

options go.bin go.vendors

default go.bin          {${prefix}/bin/go}
default go.vendors      {}

default platforms       darwin

default use_configure   no
default dist_subdir     go

default depends_build   port:go

set gopath              ${workpath}/gopath
default worksrcdir      {${gopath}/src/github.com/${github.author}/${github.project}}

default build.cmd       {"${go.bin} build"}
build.args
build.target
default build.env       {"GOPATH=${gopath} CC=${configure.cc}"}

# go.vendors name1 ver1 name2 ver2...
# When a Gopkg.lock, glide.lock, etc. is present use go2port to generate values
set go.vendors._internal {}
option_proc go.vendors handle_go_vendors
proc handle_go_vendors {option action {value ""}} {
    global go.vendors._internal
    if {${action} eq "set"} {
        foreach {imp_name vers} ${value} {
            set vlist [split ${imp_name} /]

            set vdomain [lindex ${vlist} 0]
            set vuser [lindex ${vlist} 1]
            set vname [lindex ${vlist} 2]

            switch -exact ${vdomain} {
                github.com { set ghuser ${vuser} }
                golang.org { set ghuser golang }
                gopkg.in {
                    if {$vname eq ""} {
                        set vname [regsub -- \\..*$ ${vuser} ""]
                        set ghuser go-${vname}
                    } else {
                        set vname [regsub -- \\..*$ ${vname} ""]
                        set ghuser ${vuser}
                    }
                }
            }

            # Need to use the 7-character SHA-1 suffix later to identify
            # the package when moving into the GOPATH, because the vuser
            # here may be wrong (renamed on GitHub, etc.).
            set sha1_short [string range ${vers} 0 6]
            lappend go.vendors._internal [list ${sha1_short} ${imp_name} ${vers}]

            global ${vname}.version
            set ${vname}.version ${vers}

            set fname ${ghuser}-${vname}
            master_sites-append https://github.com/${ghuser}/${vname}/tarball/${vers}:${fname}
            distfiles-append    ${fname}-${vers}.tar.gz:${fname}
        }
    }
}

# Setup build sources in GOPATH style:
#   workpath/
#       gopath/src/github.com/
#           author1/project1/
#           author2/project2/
#             :
post-extract {
    file mkdir ${gopath}/src/github.com/${github.author}
    move [glob ${workpath}/${github.author}-${github.project}-*] ${worksrcpath}

    foreach vlist ${go.vendors._internal} {
        set sha1_short [lindex ${vlist} 0]
        set imp_name [lindex ${vlist} 1]
        file mkdir ${gopath}/src/[file dirname ${imp_name}]
        move [glob ${workpath}/*-${sha1_short}] ${gopath}/src/${imp_name}
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
