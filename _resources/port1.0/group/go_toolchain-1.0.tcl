# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup does two things:
#
#   1. It records which Go releases are usable on which versions of macOS, and
#      answers questions about that (go_toolchain.ceiling,
#      go_toolchain.satisfies). Including the PortGroup on its own has no side
#      effects, so other PortGroups and ports may include it just to ask.
#
#   2. It builds a versioned Go toolchain port, when a Portfile calls
#      go_toolchain.setup. See "Building a versioned toolchain" below.
#
# Upstream's requirements, from https://go.dev/wiki/MinimumRequirements and the
# per-release notes:
#
#   Go 1.17  requires macOS 10.13 High Sierra  (darwin 17)
#   Go 1.21  requires macOS 10.15 Catalina     (darwin 19)
#   Go 1.23  requires macOS 11  Big Sur        (darwin 20)
#   Go 1.25  requires macOS 12  Monterey       (darwin 21)
#   Go 1.27  requires macOS 13  Ventura        (darwin 22)
#
# These are hard runtime limits, not merely build limits. From Go 1.25 the
# darwin runtime resolves Security.framework symbols such as
# _SecTrustCopyCertificateChain via //go:cgo_import_dynamic even when CGO is
# disabled, so a too-new Go aborts under dyld on an older system no matter how
# it was produced. The 1.25 binaries are the first to carry that undefined
# symbol, and the first built with a minimum of macOS 12.
# See https://trac.macports.org/ticket/73086.
#
# Building a versioned toolchain
# ------------------------------
#
# PortGroup             go_toolchain 1.0
#
# go_toolchain.setup    1.23.12
#
# checksums             ...
#
# go_toolchain.setup derives the port name (go-1.23), the platform the port is
# allowed on, and the whole build. A second argument names the port when it
# should not be named after its version; see go_toolchain.setup below. It
# installs GOROOT into
# ${prefix}/lib/go-1.23 and the commands as ${prefix}/bin/go-1.23 and
# ${prefix}/bin/gofmt-1.23, so versioned toolchains never collide with each
# other or with the main `go` port.

# The minimum darwin major version each Go minor release is usable on. This is
# the single source of truth; everything else here is derived from it.
#
# The values are upstream's requirements, except where MacPorts extends a
# release below them with legacysupport; see the 1.17 note below. This is not a
# list of the toolchains MacPorts packages: an entry is needed here when
# either
#
#   * a versioned port exists for it, since go_toolchain.setup looks up the
#     release to decide which platforms the port is allowed on, or
#   * it is the newest release usable on some macOS version, since that is what
#     go_toolchain.ceiling reports for that system.
#
# Those are independent: 1.23 and 1.25 have ports but decide no ceiling, since
# 11 Big Sur can run 1.24 and 12 Monterey can run 1.26. The remaining entries
# (1.18, 1.19, 1.21) do neither; they are kept only so this table stays a
# complete record of the releases in range, and so that adding a port for one
# later needs no new data.
set go_toolchain.min_darwin(1.17)   11  ;# 10.7  Lion          (see below)
set go_toolchain.min_darwin(1.18)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.19)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.20)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.21)   19  ;# 10.15 Catalina
set go_toolchain.min_darwin(1.22)   19  ;# 10.15 Catalina
set go_toolchain.min_darwin(1.23)   20  ;# 11    Big Sur
set go_toolchain.min_darwin(1.24)   20  ;# 11    Big Sur
set go_toolchain.min_darwin(1.25)   21  ;# 12    Monterey
set go_toolchain.min_darwin(1.26)   21  ;# 12    Monterey
set go_toolchain.min_darwin(1.27)   22  ;# 13    Ventura

# The 1.17 entry is the one value here that is not upstream's. Upstream
# requires 10.13 for Go 1.17, but MacPorts builds it from source below that
# with legacysupport, which is what makes a Go toolchain available at all on
# those systems.
#
# 11 is where that actually reaches, not a guess: the buildbots build 1.17.13
# on 10.7 through 10.12, and fail on 10.6, whose dsymutil aborts on the debug
# information Go's linker emits. See lang/go-1.17.

# The Go series MacPorts packages as go-1.NN ports. This cannot be derived from
# the table above, which lists the releases that exist rather than the ones
# shipped. A list of series and not of versions, so that a patch update to a
# toolchain touches only that port's own Portfile.
set go_toolchain.packaged {1.17 1.20 1.22 1.23 1.24 1.25 1.26}

# The newest and oldest series in go_toolchain.packaged.
proc go_toolchain._newest_packaged {} {
    global go_toolchain.packaged

    set newest {}
    foreach series ${go_toolchain.packaged} {
        if {${newest} eq "" || [vercmp ${series} > ${newest}]} {
            set newest ${series}
        }
    }
    return ${newest}
}

proc go_toolchain._oldest_packaged {} {
    global go_toolchain.packaged

    set oldest {}
    foreach series ${go_toolchain.packaged} {
        if {${oldest} eq "" || [vercmp ${series} < ${oldest}]} {
            set oldest ${series}
        }
    }
    return ${oldest}
}

# The series the `go` port should provide here, or {} when no packaged release
# runs on this system at all. A capped system gets the newest release it can
# run, an uncapped one the newest packaged.
proc go_toolchain.wrapped {} {
    global go_toolchain.packaged

    set ceiling [go_toolchain.ceiling]
    if {${ceiling} eq "none"} {
        return {}
    }
    if {${ceiling} eq ""} {
        return [go_toolchain._newest_packaged]
    }
    if {[lsearch -exact ${go_toolchain.packaged} ${ceiling}] < 0} {
        return {}
    }
    return ${ceiling}
}

# The newest Go minor release this table knows about. A system that can run it
# is not capped at all.
proc go_toolchain._newest {} {
    global go_toolchain.min_darwin

    set newest {}
    foreach minor [array names go_toolchain.min_darwin] {
        if {${newest} eq "" || [vercmp ${minor} > ${newest}]} {
            set newest ${minor}
        }
    }
    return ${newest}
}

# Return the minimum darwin major version for a Go release, given either a
# minor version ("1.23") or a full version ("1.23.12").
proc go_toolchain.min_darwin {go_version} {
    global go_toolchain.min_darwin

    set minor [go_toolchain._minor ${go_version}]
    if {![info exists go_toolchain.min_darwin(${minor})]} {
        return -code error "go_toolchain: unknown Go release ${go_version}"
    }
    return [set go_toolchain.min_darwin(${minor})]
}

# Reduce a version to its "1.NN" release series. Prereleases carry a suffix on
# the minor component (1.27rc2), so this cannot simply split on ".".
proc go_toolchain._minor {go_version} {
    if {![regexp {^([0-9]+\.[0-9]+)} ${go_version} -> series]} {
        return -code error "go_toolchain: cannot read a release series from ${go_version}"
    }
    return ${series}
}

# Return the newest Go minor version supported on this platform:
#
#   {}      no cap; this platform can run the newest release in the table
#   none    no release in the table runs here at all
#   1.NN    the newest release that runs here
#
# The first two are not the same thing and must not be conflated: a system
# below every floor can run no Go at all, which is the opposite of uncapped.
# Non-darwin platforms are never capped.
#
# Careful: the result is a version string, not a number. Do not pass it through
# expr (including an expr ternary), because Tcl will renormalise "1.20" to
# "1.2", which then fails to match anything. Compare it with vercmp and
# interpolate it directly into strings.
proc go_toolchain.ceiling {} {
    global os.platform os.major go_toolchain.min_darwin \
           go_toolchain.ceiling_override

    # Set to simulate a capped system when testing on one that is not.
    if {[info exists go_toolchain.ceiling_override]
            && ${go_toolchain.ceiling_override} ne ""} {
        return ${go_toolchain.ceiling_override}
    }

    if {${os.platform} ne "darwin"} {
        return {}
    }

    set best {}
    foreach {minor min_darwin} [array get go_toolchain.min_darwin] {
        if {${os.major} >= ${min_darwin}} {
            if {${best} eq "" || [vercmp ${minor} > ${best}]} {
                set best ${minor}
            }
        }
    }

    if {${best} eq ""} {
        return none
    }
    if {[vercmp ${best} >= [go_toolchain._newest]]} {
        return {}
    }
    return ${best}
}

# Return 1 when the given minimum Go version can be satisfied on this platform.
#
# The comparison is by release series, because that is what a ceiling names. A
# go.mod may ask for a patch release, and roughly half of them do ("go 1.24.0"),
# but MacPorts ships the newest patch of every series it packages, so 1.24.3 is
# satisfied wherever the 1.24 series is. Comparing the two directly would be
# wrong in exactly the boundary case that matters: vercmp ranks 1.24.3, and
# even 1.24.0, above 1.24, so a port asking for the very series a system is
# capped at would be judged unsatisfiable.
#
# An empty minimum is satisfiable wherever any Go runs at all, and nothing is
# satisfiable where none does.
proc go_toolchain.satisfies {minimum} {
    set ceiling [go_toolchain.ceiling]

    if {${ceiling} eq "none"} {
        return 0
    }
    if {${minimum} eq "" || ${ceiling} eq ""} {
        return 1
    }

    return [vercmp [go_toolchain._minor ${minimum}] <= ${ceiling}]
}

options go_toolchain.version go_toolchain.minor go_toolchain.label \
        go_toolchain.goroot_final go_toolchain.suffix \
        go_toolchain.bootstrap_path

# Configure this Portfile as a versioned Go toolchain port.
#
# The label names the port and its commands, and defaults to the release
# series, giving go-1.23 with bin/go-1.23. Pass one explicitly for a toolchain
# that is not named after its version, such as the prerelease port:
#
#   go_toolchain.setup  1.27rc2 devel   -> go-devel, bin/go-devel
#
# Everything else is derived from the version either way, so a labelled port
# still gets the platform floor, bootstrap and build of the release it tracks.
proc go_toolchain.setup {go_version {label ""}} {
    global prefix workpath worksrcpath configure.build_arch os.platform \
           extract.suffix extract.cmd extract.pre_args extract.post_args \
           distpath subport \
           go_toolchain.packaged \
           go_toolchain.version go_toolchain.minor go_toolchain.label \
           go_toolchain.goroot_final go_toolchain.suffix \
           go_toolchain.bootstrap_path

    set minor [go_toolchain._minor ${go_version}]
    if {${label} eq ""} {
        set label ${minor}
    }

    # A port named after its version must appear in go_toolchain.packaged, so
    # that a toolchain cannot be added or removed in only one of the two
    # places. A labelled port, such as the prerelease, is exempt.
    if {${label} eq ${minor}
            && [lsearch -exact ${go_toolchain.packaged} ${minor}] < 0} {
        return -code error "go_toolchain: ${minor} is not in\
            go_toolchain.packaged; add it there as well"
    }

    set go_toolchain.version        ${go_version}
    set go_toolchain.minor          ${minor}
    set go_toolchain.label          ${label}
    set go_toolchain.suffix         -${label}
    set go_toolchain.goroot_final   ${prefix}/lib/go-${label}
    set go_toolchain.bootstrap_path ${workpath}/go_prebuilt

    name                go-${label}
    version             ${go_version}
    categories          lang
    license             BSD
    homepage            https://go.dev

    maintainers         {gmail.com:herby.gillot @herbygillot} \
                        openmaintainer

    description         compiled, garbage-collected, concurrent programming \
                        language developed by Google Inc.

    long_description    \
        The Go programming language is an open source project to make \
        programmers more productive. This port provides Go ${go_version} \
        specifically, installed alongside any other Go toolchain, as \
        go-${label} and gofmt-${label}. It is intended for building software \
        that requires this particular release.

    # The oldest macOS this release is supported on.
    platforms           "darwin >= [go_toolchain.min_darwin ${go_version}]"

    # Go dropped darwin/386 well before any release packaged here.
    supported_archs     arm64 x86_64

    master_sites        [option homepage]/dl/
    distfiles           go${go_version}.src${extract.suffix}
    extract.only        go${go_version}.src${extract.suffix}
    worksrcdir          go

    use_configure       no
    use_parallel_build  no

    # build.cmd is a shell script that runs make itself, so stop the port
    # system adding a -j flag.
    build.jobs          -1
    build.dir           ${worksrcpath}/src
    build.cmd           ./make.bash
    build.target

    switch ${configure.build_arch} {
        arm64   { set goarch arm64 }
        x86_64  { set goarch amd64 }
        default { set goarch {} }
    }

    # Bootstrap from the official prebuilt toolchain of the same release. That
    # binary's own minimum macOS version is never newer than the release's
    # stated floor, so it runs anywhere this port is allowed to build.
    switch ${configure.build_arch} {
        arm64   { set bootstrap_dist go${go_version}.darwin-arm64${extract.suffix} }
        default { set bootstrap_dist go${go_version}.darwin-amd64${extract.suffix} }
    }
    distfiles-append    ${bootstrap_dist}

    build.env           GOROOT=${worksrcpath} \
                        GOARCH=${goarch} \
                        GOOS=darwin \
                        GOROOT_FINAL=${go_toolchain.goroot_final} \
                        GOROOT_BOOTSTRAP=${go_toolchain.bootstrap_path}/go \
                        CC=[option configure.cc]

    post-extract {
        xinstall -d ${go_toolchain.bootstrap_path}
        system -W ${go_toolchain.bootstrap_path} \
            "${extract.cmd} ${extract.pre_args} ${distpath}/[go_toolchain._bootstrap_dist] ${extract.post_args}"
    }

    post-build {
        system "find ${worksrcpath} -type d -name .hg* -print0 | xargs -0 rm -rf"
        delete ${worksrcpath}/pkg/bootstrap
    }

    destroot {
        # Contains a deliberately malformed Mach-O file that upsets destroot.
        delete ${worksrcpath}/src/cmd/vendor/github.com/google/pprof/internal/binutils/testdata/malformed_macho

        set grfdir ${destroot}${go_toolchain.goroot_final}
        set docdir ${destroot}${prefix}/share/doc/${subport}

        xinstall -d ${grfdir}
        xinstall -d ${docdir}

        # go.env only exists from Go 1.21 onwards, and the layout has varied
        # in other ways between releases, so only copy what this one ships.
        foreach f {api bin lib misc pkg src test VERSION go.env} {
            if {[file exists ${worksrcpath}/${f}]} {
                copy ${worksrcpath}/${f} ${grfdir}
            }
        }

        foreach f {go gofmt} {
            ln -s ../lib/go-${go_toolchain.label}/bin/${f} \
                ${destroot}${prefix}/bin/${f}${go_toolchain.suffix}
        }

        foreach f {CONTRIBUTING.md LICENSE PATENTS SECURITY.md VERSION} {
            if {[file exists ${worksrcpath}/${f}]} {
                xinstall -m 0644 -W ${worksrcpath} ${f} ${docdir}
            }
        }

        # The release's own doc/ tree, which carries the language spec among
        # other things. Its contents vary by release, so copy whatever is
        # there.
        if {[file exists ${worksrcpath}/doc]} {
            copy {*}[glob -directory ${worksrcpath}/doc *] ${docdir}
        }
    }

    notes "
        This port installs Go ${go_version} as go-${label} and gofmt-${label},
        so it does not interfere with the main `go` port. Use it directly, or
        point a build at ${prefix}/lib/go-${label} as GOROOT.
    "

    livecheck.type      regex
    livecheck.url       [option homepage]/dl/
    if {[regexp {^[0-9.]+$} ${go_version}]} {
        # Match only this branch, so a versioned toolchain is not reported as
        # outdated against whatever the current Go release happens to be.
        livecheck.regex [go_toolchain._livecheck_regex ${minor}]
    } else {
        # A prerelease port tracks the newest prerelease, in whatever series
        # it happens to be. It must not match a stable release: those sort
        # above a prerelease of the same series, so a plain version pattern
        # would pull the port onto a stable release the moment one shipped.
        livecheck.regex {go([0-9.]+(?:beta|rc)[0-9]+)\.src\.tar\.gz}
    }
}

# The bootstrap distfile for this build, recomputed at phase time so the
# post-extract block does not need a captured local.
proc go_toolchain._bootstrap_dist {} {
    global configure.build_arch extract.suffix go_toolchain.version

    switch ${configure.build_arch} {
        arm64   { set arch darwin-arm64 }
        default { set arch darwin-amd64 }
    }
    return go[option go_toolchain.version].${arch}${extract.suffix}
}

# Match only patch releases of this port's own branch, so that a versioned port
# is not reported as outdated against a newer branch.
proc go_toolchain._livecheck_regex {minor} {
    set esc [string map {. {\.}} ${minor}]
    return [subst -nocommands -nobackslashes {go(${esc}\.[0-9.]+)\.src\.tar\.gz}]
}
