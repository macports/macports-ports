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
# go.vendors    example.com/dep1/foo \
#                   lock   abcdef123456... \
#                   rmd160 fedcba654321... \
#                   sha256 bdface246135... \
#                   size   1234 \
#               vanity_domain.com/dep2_bar \
#                   repo   example.com/dep2/bar \
#                   lock   fedcba654321... \
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
# The go.vendors option expects a list of package IDs, each followed by these
# labeled values:
#
# - repo: Packages are sometimes hosted on domains that merely redirect to
#   well-known hosts such as GitHub. In that case, specify the resolved package
#   name with the `repo` keyword. Example: coolbiz.io/coolpackage might resolve
#   to github.com/coolbiz/package. This must come before the `lock` keyword.
#
# - lock: the version of the package in git reference format. This must come
#   before any checksums.
#
# - rmd160, sha256, size, etc.: checksums of the package. All checksums
#   supported by the checksums keyword are supported.
#
# The list of vendors can be found in the go.sum, Gopkg.lock, glide.lock,
# etc. file in the upstream source code. The go2port tool (install via MacPorts)
# can be used to generate a skeleton portfile with precomputed go.vendors.

PortGroup legacysupport    1.1
PortGroup compiler_wrapper 1.0

options go.package go.domain go.author go.project go.version go.tag_prefix go.tag_suffix

proc go.setup {go_package go_version {go_tag_prefix ""} {go_tag_suffix ""}} {
    global go.package go.domain go.author go.project go.version go.tag_prefix go.tag_suffix

    go.package          ${go_package}
    go.version          ${go_version}

    # go.package is split up here into go.{domain,author,project}, but a port
    # may override just go.package when, for instance, the upstream author has
    # decided to customize the package ID but still host on e.g. GitHub. The
    # shfmt port is an example of this.
    #
    # It is assumed in this portgroup that go.{domain,author,project} will
    # remain consistent with the distfile; this is needed when moving the source
    # into the GOPATH in the post-extract block later on.
    lassign [go._translate_package_id ${go_package}] go.domain go.author go.project

    switch ${go.domain} {
        github.com {
            uplevel "PortGroup github 1.0"
            github.setup ${go.author} ${go.project} ${go_version} ${go_tag_prefix} ${go_tag_suffix}
        }
        gitlab.com {
            uplevel "PortGroup gitlab 1.0"
            gitlab.setup ${go.author} ${go.project} ${go_version} ${go_tag_prefix} ${go_tag_suffix}
        }
        bitbucket.org {
            uplevel "PortGroup bitbucket 1.0"
            bitbucket.setup ${go.author} ${go.project} ${go_version} ${go_tag_prefix}
        }
        git.sr.ht {
            uplevel "PortGroup sourcehut 1.0"
            sourcehut.setup ${go.author} ${go.project} ${go_version} ${go_tag_prefix} ${go_tag_suffix}
        }
        gitea.com {
            uplevel "PortGroup gitea 1.0"
            gitea.setup ${go.author} ${go.project} ${go_version} ${go_tag_prefix} ${go_tag_suffix}
        }
        default {
            if {![info exists PortInfo(name)]} {
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
        git.sr.ht {
            # Strip leading ~ from author name
            set author [string trim ${author} ~]
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
supported_archs         arm64 i386 x86_64
set goos                ${os.platform}

switch ${configure.build_arch} {
    arm64   { set goarch arm64 }
    i386    { set goarch 386 }
    x86_64  { set goarch amd64 }
    default { set goarch {} }
}

default universal_variant no

default use_configure   no
default dist_subdir     go

default depends_build   port:go

set gopath              ${workpath}/gopath
default worksrcdir      {gopath/src/${go.package}}

set go_env {GOPATH=${gopath} GOARCH=${goarch} GOOS=${goos} GOPROXY=off GO111MODULE=off \
                CC=${configure.cc} CXX=${configure.cxx} FC=${configure.fc} \
                OBJC=${configure.objc} OBJCXX=${configure.objcxx} }

default build.cmd     {${go.bin} build}
default build.args      ""
default build.target    ""
default build.env     ${go_env}

default test.cmd      {${go.bin} test}
default test.args       ""
default test.target     ""
default test.env      ${go_env}

default configure.env ${go_env}

proc go.append_env {} {
    global configure.cc configure.cxx configure.ldflags configure.cflags configure.cxxflags configure.cppflags
    global os.major build.env workpath
    # Create a wrapper scripts around compiler commands to enforce use of MacPorts flags
    # and to aid use of MacPorts legacysupport library as required.
    if { ${os.major} <= [option legacysupport.newest_darwin_requires_legacy] } {
        # Note, go annoyingly uses CC for both building and linking, and thus in order to get it to correctly
        # link to the legacy support library, the ldflags need to be added to the cc and ccx wrappers.
        # To then prevent 'clang linker input unused' errors we must append -Wno-error at the end.
        # Also remove '-static' from compilation options as this is not supported on older systems.
        compwrap.compiler_args_forward \$\{\@\//-static/\}
        compwrap.compiler_pre_flags-append    ${configure.ldflags}
        compwrap.compiler_post_flags-append   -Wno-error
    }
    post-extract {
        build.env-append \
            "CC=[compwrap::wrap_compiler cc]" \
            "CXX=[compwrap::wrap_compiler cxx]" \
            "OBJC=[compwrap::wrap_compiler objc]" \
            "OBJCXX=[compwrap::wrap_compiler objcxx]" \
            "FC=[compwrap::wrap_compiler fc]" \
            "F90=[compwrap::wrap_compiler f90]" \
            "F77=[compwrap::wrap_compiler f77]" 
        if { ${os.major} <= [option legacysupport.newest_darwin_requires_legacy] } {
            build.env-append \
                "GO_EXTLINK_ENABLED=1" \
                "BOOT_GO_LDFLAGS=-extldflags='${configure.ldflags}'" \
                "CGO_CFLAGS=${configure.cflags} [get_canonical_archflags cc]" \
                "CGO_CXXFLAGS=${configure.cxxflags} [get_canonical_archflags cxx]" \
                "CGO_LDFLAGS=${configure.cflags} ${configure.ldflags} [get_canonical_archflags ld]" \
                "GO_LDFLAGS=-extldflags='${configure.ldflags} [get_canonical_archflags ld]'"
        }
        configure.env-append ${build.env}
        test.env-append      ${build.env}
    }
}
port::register_callback go.append_env

# go.vendors name1 ver1 name2 ver2...
# When a go.sum, Gopkg.lock, glide.lock, etc. is present use go2port to generate values
set go.vendors_internal {}
option_proc go.vendors handle_go_vendors
proc handle_go_vendors {option action {vendors_str ""}} {
    if {${action} eq "set"} {
        if {[catch {
            handle_set_go_vendors ${vendors_str}
        } error]} {
            ui_debug ${::errorInfo}
            ui_error "Couldn't parse go.vendors line (${vendors_str}) [${error}]"
        }
    }
}

proc handle_set_go_vendors {vendors_str} {
    global go.vendors_internal checksum_types
    if {![info exists checksum_types]} {
        set checksum_types $portchecksum::checksum_types
    }
    set num_tokens [llength ${vendors_str}]
    if {$num_tokens > 0} {
        # portgroups like github may set this - can't be used with multiple distfiles
        extract.rename  no
    }
    for {set ix 0} {${ix} < ${num_tokens}} {incr ix} {
        # Get the Go package ID
        set vpackage [lindex ${vendors_str} ${ix}]

        # Package resolves to itself by default; only overridden in case of
        # redirects, etc.
        set vresolved ${vpackage}

        # Handle the remaining values for this package
        incr ix
        while {1} {
            set token [lindex ${vendors_str} ${ix}]
            if {${token} eq "repo"} {
                # Handle the package's resolved name. See discussion of this in
                # header comments.
                incr ix
                set vresolved [lindex ${vendors_str} ${ix}]
                incr ix
            } elseif {${token} eq "lock"} {
                # Handle the package version ("lock" as in "lockfile")
                incr ix
                set vversion [lindex ${vendors_str} ${ix}]
                incr ix

                # Split up the package ID
                lassign [go._translate_package_id ${vresolved}] vdomain vauthor vproject

                if {[string match v* ${vversion}]} {
                    set sha1_short {}
                } else {
                    # The vauthor may be wrong (the project has been renamed/changed
                    # ownership) so we need to use the SHA-1 suffix later to identify
                    # the package when moving into the GOPATH. GitHub uses 7 digits;
                    # Bitbucket uses 12. We take 7 and use globbing.
                    set sha1_short [string range ${vversion} 0 6]
                }
                lappend go.vendors_internal [list ${sha1_short} ${vpackage} ${vresolved} ${vversion}]

                switch ${vdomain} {
                    github.com {
                        set distfile ${vauthor}-${vproject}-${vversion}.tar.gz
                        set master_site https://codeload.github.com/${vauthor}/${vproject}/legacy.tar.gz/${vversion}?dummy=
                    }
                    bitbucket.org {
                        set distfile ${vversion}.tar.gz
                        set master_site https://bitbucket.org/${vauthor}/${vproject}/get
                    }
                    gitlab.com -
                    salsa.debian.org {
                        set distfile ${vproject}-${vversion}.tar.gz
                        set master_site https://${vdomain}/${vauthor}/${vproject}/-/archive/${vversion}
                    }
                    git.sr.ht {
                        set distfile ${vversion}.tar.gz
                        set master_site https://${vdomain}/~${vauthor}/${vproject}/archive
                    }
                    default {
                        ui_error "go.vendors can't handle dependencies from ${vdomain}"
                        error "unsupported dependency domain"
                    }
                }
                set tag [regsub -all {[^[:alpha:][:digit:]]} ${vpackage}-${vversion} -]
                master_sites-append ${master_site}:${tag}
                distfiles-append    ${distfile}:${tag}
            } elseif {${token} in ${checksum_types}} {
                # Handle checksum values
                incr ix
                set csumval [lindex ${vendors_str} ${ix}]
                incr ix
                checksums-append    ${distfile} ${token} ${csumval}
            } else {
                # This wasn't a checksum token, but rather the next vendor package
                incr ix -1
                break
            }
            # Stop if we have consumed all the tokens
            if {${ix} == ${num_tokens}} {
                break
            }
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
# - GitLab: ${project}-${ref}
#
# Support for additional hosts not conforming to this pattern will take some
# work.
post-extract {
    if {${fetch.type} eq "standard"} {
        # Don't try to create the worksrcpath using go.{domain,author,project}
        # as the result will not be accurate when go.package has been
        # customized.
        file mkdir [file dirname ${worksrcpath}]
        if {[file exists [glob -nocomplain ${workpath}/${go.author}-${go.project}-*]]} {
            # GitHub and Bitbucket follow this path
            move [glob ${workpath}/${go.author}-${go.project}-*] ${worksrcpath}
        } elseif  {[file exists ${workpath}/${go.project}]} {
            move ${workpath}/${go.project} ${worksrcpath}
        } else {
            # GitLab follows this path
            move [glob ${workpath}/${go.project}-*] ${worksrcpath}
        }
        # If the above fails then something went wrong and we should error out.
    }

    foreach vlist ${go.vendors_internal} {
        lassign ${vlist} sha1_short vpackage vresolved
        ui_debug "Processing vendored dependency (sha1_short: ${sha1_short}, vpackage: ${vpackage}, vresolved: ${vresolved})"

        file mkdir ${gopath}/src/[file dirname ${vpackage}]
        if {${sha1_short} ne ""} {
            move [glob ${workpath}/*-${sha1_short}*] ${gopath}/src/${vpackage}
        } else {
            lassign [go._translate_package_id ${vresolved}] _ vauthor vproject
            # In some cases, this can match multiple folders, e.g.,
            # gopkg.in/src-d/go-git.v4 and gopkg.in/src-d/go-git-fixtures.v3.
            # We want the one that does not have any dashes in the wildcard of
            # our glob expression, so use regex to identify that.
            set candidates [glob ${workpath}/${vauthor}-${vproject}-*]
            foreach candidate $candidates {
                if {[regexp -nocase "^[quotemeta $workpath]/[quotemeta $vauthor]-[quotemeta $vproject]-\[^-\]*$" $candidate]} {
                    ui_debug "Choosing $candidate for ${workpath}/${vauthor}-${vproject}-*"
                    move $candidate ${gopath}/src/${vpackage}
                    break
                } else {
                    ui_debug "Rejecting $candidate for ${workpath}/${vauthor}-${vproject}-* because it contains dashes in the wildcard match"
                }
            }
        }
    }
}

destroot {
    ui_error "No destroot phase in the Portfile!"
    ui_msg "Here is an example destroot phase:"
    ui_msg
    ui_msg "destroot {"
    ui_msg {    xinstall -m 0755 ${worksrcpath}/${name} ${destroot}${prefix}/bin/}
    ui_msg "}"
    ui_msg
    ui_msg "Please check if there are additional files (configuration, documentation, etc.) that need to be installed."
    error "destroot phase not implemented"
}
