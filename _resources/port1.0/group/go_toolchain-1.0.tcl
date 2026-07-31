# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup provides two things:
#
#   * The mapping from Go release to the oldest macOS it runs on, and the
#     queries over it: go_toolchain.ceiling, go_toolchain.satisfies and
#     go_toolchain.wrapped. Including the PortGroup has no side effects, so a
#     port or another PortGroup may include it purely to ask.
#
#   * The build of a versioned Go toolchain port, via go_toolchain.setup.
#
#
# Building a toolchain port
# -------------------------
#
#   PortGroup             go_toolchain 1.0
#
#   go_toolchain.setup    1.23.12
#
#   checksums             ...
#
# setup derives the port name, the platforms it is allowed on, the bootstrap
# and the whole build. go-1.23 installs its GOROOT at ${prefix}/lib/go-1.23 and
# its commands as ${prefix}/bin/go-1.23 and ${prefix}/bin/gofmt-1.23, so
# toolchains never collide with each other or with the `go` port.
#
# Checksums are needed for the source tarball and for both darwin binaries,
# which are used to bootstrap.
#
# An optional second argument names a port that should not be named after its
# version:
#
#   go_toolchain.setup    1.27rc2 devel     ->  go-devel, bin/go-devel
#
#
# Adding a new Go series
# ----------------------
#
#   1. go_toolchain.min_darwin: add the series with the oldest darwin major
#      version upstream supports it on.
#
#      Required even when no port is added. go_toolchain.ceiling reads this
#      table to decide what each system can run, so a series missing from it
#      leaves systems that cannot run the new release still reporting that they
#      can, and ports are then built against a Go that will not start.
#
#   2. go_toolchain.packaged: add the series if a go-1.NN port is created for
#      it. setup refuses a version-named port whose series is absent here.
#
#   3. lang/go-1.NN/Portfile: call go_toolchain.setup with the full version,
#      and give the checksums.
#
# Nothing else needs touching. The `go` port follows the newest series each
# system can run, and every ceiling recomputes from the table.
#
# Retiring a series is the reverse: drop it from go_toolchain.packaged and
# delete the port. Its go_toolchain.min_darwin entry can stay, since that table
# records what upstream requires rather than what is shipped.
#
# A patch update, say 1.26.5 to 1.26.6, is a change to that port's own Portfile
# and nothing here.
#
#
# Upstream's macOS requirements
# -----------------------------
#
# From https://go.dev/wiki/MinimumRequirements and the per-release notes:
#
#   Go 1.17   macOS 10.13 High Sierra   (darwin 17)
#   Go 1.21   macOS 10.15 Catalina      (darwin 19)
#   Go 1.23   macOS 11    Big Sur       (darwin 20)
#   Go 1.25   macOS 12    Monterey      (darwin 21)
#   Go 1.27   macOS 13    Ventura       (darwin 22)
#
# These are runtime limits rather than build limits. From Go 1.25 the darwin
# runtime resolves Security.framework symbols such as
# _SecTrustCopyCertificateChain through //go:cgo_import_dynamic even when CGO
# is disabled, so a too-new Go aborts under dyld however it was produced.
# See https://trac.macports.org/ticket/73086.

# The oldest darwin major version each Go series runs on.
#
# The values are upstream's requirements, with the exception of 1.17 noted
# below. An entry is needed for any series that has a port, and for any series
# that is the newest runnable on some version of macOS.
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

# 1.17 is the one value above that is not upstream's. Upstream requires 10.13;
# MacPorts builds 1.17.13 from source below that with legacysupport, which is
# what makes any Go available on those systems. 10.7 is the limit of that:
# 10.6 cannot build it, because its dsymutil aborts on the debug information
# Go's linker emits. See lang/go-1.17.

# The series MacPorts packages as go-1.NN ports.
#
# This cannot be derived from the table above, which records the releases that
# exist rather than the ones shipped: 1.18, 1.19 and 1.21 have no port, and
# 1.27 exists only as the prerelease.
#
# A list of series rather than of versions, so that a patch update touches only
# the toolchain's own Portfile.
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
# runs on this system at all.
#
# A capped system gets the newest release it can run, an uncapped one the
# newest packaged. Both are the newest usable Go, which is what `go` means.
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

# The newest series in go_toolchain.min_darwin.
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

# The oldest darwin major version a release runs on. Accepts either a series
# ("1.23") or a full version ("1.23.12").
proc go_toolchain.min_darwin {go_version} {
    global go_toolchain.min_darwin

    set minor [go_toolchain._minor ${go_version}]
    if {![info exists go_toolchain.min_darwin(${minor})]} {
        return -code error "go_toolchain: unknown Go release ${go_version}"
    }
    return [set go_toolchain.min_darwin(${minor})]
}

# The release series of a version. Prereleases carry a suffix on the minor
# component (1.27rc2), so this cannot simply split on ".".
proc go_toolchain._minor {go_version} {
    if {![regexp {^([0-9]+\.[0-9]+)} ${go_version} -> series]} {
        return -code error "go_toolchain: cannot read a release series from ${go_version}"
    }
    return ${series}
}

# The newest Go series usable on this platform:
#
#   1.NN    the newest series that runs here
#   {}      no cap; the newest series in the table runs here
#   none    no series in the table runs here
#
# {} and none are distinct and must not be conflated: a system below every
# floor runs no Go at all, which is the opposite of uncapped. Non-darwin
# platforms are never capped.
#
# Setting go_toolchain.ceiling_override replaces the computed answer, which
# allows a capped system to be simulated for testing.
#
# The result is a version string, not a number. Never pass it through expr,
# including an expr ternary: Tcl renormalises "1.20" to "1.2", which then
# matches nothing. Compare it with vercmp and interpolate it directly.
proc go_toolchain.ceiling {} {
    global os.platform os.major go_toolchain.min_darwin \
           go_toolchain.ceiling_override

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

# Whether a minimum Go version can be satisfied on this platform.
#
# The comparison is by series, since that is what a ceiling names. A go.mod may
# ask for a patch release, and MacPorts ships the newest patch of every series
# it packages, so 1.24.3 is satisfied wherever the 1.24 series is. Comparing
# the two directly would fail at the boundary that matters, because vercmp
# ranks 1.24.3, and even 1.24.0, above 1.24.
#
# An empty minimum is satisfiable wherever any Go runs, and nothing is
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
# label names the port and its commands and defaults to the release series,
# giving go-1.23 with bin/go-1.23. Everything else is derived from the version
# either way, so a labelled port still gets the platform floor, bootstrap and
# build of the release it tracks.
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

    # Go dropped darwin/386 in 1.15, before any release packaged here.
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

    # Bootstrap from the official prebuilt toolchain of the same release. Its
    # own minimum macOS version is never newer than that release's floor, so it
    # runs anywhere this port is allowed to build.
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
        # A deliberately malformed Mach-O test fixture that upsets destroot.
        delete ${worksrcpath}/src/cmd/vendor/github.com/google/pprof/internal/binutils/testdata/malformed_macho

        set grfdir ${destroot}${go_toolchain.goroot_final}
        set docdir ${destroot}${prefix}/share/doc/${subport}

        xinstall -d ${grfdir}
        xinstall -d ${docdir}

        # go.env exists only from Go 1.21, and the layout varies between
        # releases in other ways, so copy only what this one ships.
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
        Installed as go-${label} and gofmt-${label}, with GOROOT at
        ${prefix}/lib/go-${label}.
    "

    livecheck.type      regex
    livecheck.url       [option homepage]/dl/
    if {[regexp {^[0-9.]+$} ${go_version}]} {
        # Match only this series, so a toolchain is not reported as outdated
        # against a newer one.
        livecheck.regex [go_toolchain._livecheck_regex ${minor}]
    } else {
        # A prerelease port tracks the newest prerelease in any series, and
        # must not match a stable release: those sort above a prerelease of
        # the same series.
        livecheck.regex {go([0-9.]+(?:beta|rc)[0-9]+)\.src\.tar\.gz}
    }
}

# The bootstrap distfile for this build, recomputed at phase time so that the
# post-extract block needs no captured local.
proc go_toolchain._bootstrap_dist {} {
    global configure.build_arch extract.suffix go_toolchain.version

    switch ${configure.build_arch} {
        arm64   { set arch darwin-arm64 }
        default { set arch darwin-amd64 }
    }
    return go[option go_toolchain.version].${arch}${extract.suffix}
}

# A livecheck pattern matching only the patch releases of one series.
proc go_toolchain._livecheck_regex {minor} {
    set esc [string map {. {\.}} ${minor}]
    return [subst -nocommands -nobackslashes {go(${esc}\.[0-9.]+)\.src\.tar\.gz}]
}
