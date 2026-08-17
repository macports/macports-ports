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
#
# A port that cannot be built with an arbitrarily old Go should say so:
#
# go.toolchain_min  1.24
#
# Upstream raises Go's minimum macOS version regularly, so an older system is
# capped at an older Go, and a port needing something newer cannot be built
# there by any means. Declaring the minimum lets such a port be marked
# known_fail on those systems rather than being fetched, built and failed every
# time it is tried. A port that does not declare one is never gated.
#
# The value may be written however go.mod writes it, "1.24" or "1.24.0"; only
# the series is compared, since MacPorts ships the newest patch release of each
# series it packages.
#
# Where to get the value depends on how the port builds:
#
#   * With go.offline_build no, the build runs in module mode and Go reads
#     go.mod, so its `go` directive is enforced and is exactly the minimum.
#     Copy it.
#
#   * Otherwise the build runs in GOPATH mode, where go.mod is not consulted at
#     all. The directive is then only an upper bound on what the source really
#     needs, and may be well above it. Declare a minimum for such a port only
#     when it is known to be needed, or the port will be skipped on systems
#     where it would have built.
#
# Builds run with GOTOOLCHAIN=local, so a module asking for a Go newer than the
# one installed fails and says so rather than downloading that release and
# running it. A Portfile does not need to set this; see go_env below for why it
# is set at all. It does mean the packaged patch release is a floor, which
# go.toolchain_min will not warn about because it compares only the series.

PortGroup legacysupport    1.1
PortGroup compiler_wrapper 1.0
PortGroup go_toolchain     1.0

options go.package go.domain go.author go.project go.version go.tag_prefix go.tag_suffix go.offline_build

proc go.setup {go_package go_version {go_tag_prefix ""} {go_tag_suffix ""}} {
    global go.domain go.author go.project go.version

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
            github.tarball_from archive
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
    set subdir [join [lrange ${parts} 3 end] "/"]

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
    return [list ${domain} ${author} ${project} ${subdir}]
}

proc go._strip_gopkg_version {str} {
    return [regsub -- \\..*$ ${str} ""]
}

options go.bin go.vendors go.toolchain_min

# The oldest Go this port can be built with. Unset means the port states no
# minimum and is never gated. See the header for where to get the value.
#
# Evaluated as soon as a Portfile sets it, so that known_fail is in place for
# anything that reads it.
default go.toolchain_min {}
option_proc go.toolchain_min go._handle_toolchain_min

# Where no Go release runs at all, nothing built with this PortGroup can be
# either, whatever it does or does not declare. That needs no annotation to
# decide, so it is settled here rather than per port.
if {[go_toolchain.ceiling] eq "none"} {
    known_fail yes
}

# Holds the minimum when this system cannot meet it, for the message below.
set go.toolchain_unmet  {}

proc go._handle_toolchain_min {option action args} {
    global go.toolchain_unmet

    if {${action} ne "set"} {
        return
    }

    set minimum [lindex ${args} 0]

    # A value above every series go_toolchain records is either a typo, which
    # would otherwise skip the port everywhere without a word, or a real
    # release whose macOS floor has not been recorded; neither can be gated
    # correctly. One below them all can never gate anything.
    switch [go_toolchain.range ${minimum}] {
        newer {
            return -code error "go.toolchain_min ${minimum} is newer than any\
                Go release go_toolchain records. If it is real, add it to\
                go_toolchain.min_darwin with the oldest darwin it runs on."
        }
        older {
            ui_warn "go.toolchain_min ${minimum} is older than every Go release\
                     go_toolchain records, so it is below every ceiling and can\
                     never gate this port; it may be dropped."
        }
    }

    if {[go_toolchain.satisfies ${minimum}]} {
        set go.toolchain_unmet {}
        return
    }

    set go.toolchain_unmet ${minimum}
    known_fail yes
}

pre-fetch {
    global go.toolchain_unmet

    set ceiling [go_toolchain.ceiling]

    if {${ceiling} eq "none"} {
        ui_error "No Go release runs on this version of macOS, so ${subport}\
                  cannot be built here."
        return -code error "no Go toolchain is available on this platform"
    }
    if {${go.toolchain_unmet} ne ""} {
        ui_error "${subport} needs Go ${go.toolchain_unmet} or newer, but this\
                  version of macOS runs nothing newer than Go ${ceiling}."
        return -code error "Go ${go.toolchain_unmet} is not available on this platform"
    }
}

default go.bin          {${prefix}/bin/go}
default go.vendors      {}
default go.offline_build \
                        true

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

# GOTOOLCHAIN=local keeps the build on the Go that MacPorts installed. Go
# defaults to auto, which downloads and runs whatever release go.mod names
# whenever that is newer than the toolchain in hand: an unchecksummed binary
# fetched at build time, outside the distfile and mirror machinery, and one
# this system may not be able to start at all. That last case is
# https://trac.macports.org/ticket/73086 arriving by another route, and it
# reports as a bare SIGABRT naming neither the version nor the reason.
#
# Only module mode reads go.mod, so only there can a switch happen, but it
# costs nothing to set for both and cannot then be lost if the offline_build
# branch below is rearranged.
#
# The cost is that MacPorts' packaged patch release becomes a hard floor: a
# go.mod asking for 1.26.7 will not build against a packaged 1.26.5, where
# before it would have quietly fetched 1.26.7. Keep the toolchain ports
# current. Note also that go.toolchain_min compares by series and so will not
# catch that case for you.
# -modcacherw keeps the module cache writable. Go otherwise creates those
# directories mode 0555, and unlinking an entry needs write permission on the
# directory holding it, so base cannot wipe the work directory when a Portfile
# changes -- that runs unprivileged, and only root can ignore the write bit.
set go_env {GOPATH=${gopath} GOARCH=${goarch} GOOS=${goos} GOPROXY=off GO111MODULE=off \
                GOTOOLCHAIN=local GOFLAGS=-modcacherw \
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
    global configure.ldflags os.major build.env go.offline_build
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

    if { ! ${go.offline_build} } {
        ui_debug "Disabling offline building for Go"

        configure.env-delete \
                            GO111MODULE=off GOPROXY=off
        build.env-delete    GO111MODULE=off GOPROXY=off
        test.env-delete     GO111MODULE=off GOPROXY=off
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
    global go.vendors_internal portchecksum::checksum_types

    set num_tokens [llength ${vendors_str}]
    if {$num_tokens > 0} {
        # portgroups like github may set this - can't be used with multiple distfiles
        extract.rename  no
        # Hack so we can map the extracted dir to the package
        global extract.cmd extract.suffix extract.pre_args extract.post_args
        extract.cmd     "sh -c 'd=\$(basename \"\$1\" ${extract.suffix}) && \
            mkdir \"\$d.tmp\" && ${extract.cmd} ${extract.pre_args} \"\$1\" \
            ${extract.post_args} -C \"\$d.tmp\" && mv \"\$d.tmp\"/* \"\$d\" \
            && rmdir \"\$d.tmp\"' ."
        extract.pre_args
        extract.post_args
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

                # If the package is a subdirectory in a repo
                if {[string range ${vpackage} 0 [string length ${vresolved}]] eq "${vresolved}/"} {
                    set vresolved ${vpackage}
                } elseif {[string match google.golang.org/* ${vpackage}]} {
                    set vresolved ${vresolved}/[join [lrange [split ${vpackage} "/"] 2 end] "/"]
                } elseif {${vresolved} ne ${vpackage}} {
                    # The subdirectory might be encoded in the version
                    set subdir [join [lrange [split ${vversion} "/"] 0 end-1] "/"]
                    if {$subdir ne ""} {
                        set vresolved ${vresolved}/$subdir
                    }
                }

                # Split up the package ID
                lassign [go._translate_package_id ${vresolved}] vdomain vauthor vproject vsubdir

                set distversion [regsub -all {/} ${vversion} -]

                switch ${vdomain} {
                    github.com {
                        set vdistname ${vauthor}-${vproject}-${distversion}
                        set distfile ${vdistname}.tar.gz
                        set master_site https://codeload.github.com/${vauthor}/${vproject}/legacy.tar.gz/${vversion}?dummy=
                    }
                    bitbucket.org {
                        set vdistname ${distversion}
                        set distfile ${vdistname}.tar.gz
                        set master_site https://bitbucket.org/${vauthor}/${vproject}/get
                    }
                    gitlab.com -
                    salsa.debian.org {
                        set vdistname ${vproject}-${distversion}
                        set distfile ${vdistname}.tar.gz
                        set master_site https://${vdomain}/${vauthor}/${vproject}/-/archive/${vversion}
                    }
                    git.sr.ht {
                        set vdistname ${distversion}
                        set distfile ${vdistname}.tar.gz
                        set master_site https://${vdomain}/~${vauthor}/${vproject}/archive
                    }
                    default {
                        ui_error "go.vendors can't handle dependencies from ${vdomain}"
                        error "unsupported dependency domain"
                    }
                }
                lappend go.vendors_internal [list ${vdistname} ${vpackage} ${vresolved} ${vversion} ${vsubdir}]

                set tag [regsub -all {[^[:alpha:][:digit:]]} ${vpackage}-${vversion} -]
                master_sites-append ${master_site}:${tag}
                distfiles-append    ${distfile}:${tag}
                checksums-append    ${distfile}
            } elseif {${token} in ${checksum_types}} {
                # Handle checksum values
                incr ix
                set csumval [lindex ${vendors_str} ${ix}]
                incr ix
                checksums-append    ${token} ${csumval}
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
        # Use the same mechanism as the vendors to better handle submodules
        if {[llength ${go.vendors_internal}]} {
            lappend go.vendors_internal [list ${distname} ${go.package} "" ${version} ""]
        } else {
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
    }

    # Sort so parent modules are handled before nested ones
    foreach vlist [lsort -index 1 ${go.vendors_internal}] {
        lassign ${vlist} vdistname vpackage vresolved vversion vsubdir
        ui_debug "Processing vendored dependency (vdistname: ${vdistname}, vpackage: ${vpackage}, vresolved: ${vresolved}, vversion: ${vversion}, vsubdir: ${vsubdir})"
        set dir ${gopath}/src/${vpackage}
        file mkdir [file dirname $dir]
        # If this a nested module, it might already exist, so delete first
        delete $dir
        # Drop a potential version specifier which might not be a directory
        if {![file exists ${workpath}/${vdistname}/${vsubdir}]} {
            set vsubdir [join [lrange [split ${vsubdir} "/"] 0 end-1] "/"]
        }
        move ${workpath}/${vdistname}/${vsubdir} $dir
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
