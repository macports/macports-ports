# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# The mapping from Go release to the macOS versions it can be used on, and
# the build of a versioned Go toolchain port.
#
# Three kinds of port sit on top of this:
#
#   lang/go-1.NN   the toolchains, each built by go_toolchain.setup and
#                  installed side by side as ${prefix}/lib/go-1.NN with
#                  ${prefix}/bin/go-1.NN
#   lang/go        a wrapper with no build of its own, symlinking whichever
#                  series this system is offered
#   golang 1.0     the PortGroup downstream Go projects use; it includes
#                  this one so a port can declare go.toolchain_min
#
# Including this PortGroup has no side effects. Anything may include it
# purely to ask.
#
#
# Queries
# -------
#
#   min_darwin S     oldest darwin major S loads on; decides where a
#                    toolchain port may be installed
#   min_default S    oldest darwin major S may be the default Go; decides
#                    what `go` provides. Defaults to min_darwin
#   ceiling          newest series offered here: 1.NN, {} when uncapped, or
#                    none where no Go release runs at all
#   satisfies MIN    whether this system can provide Go >= MIN, by series
#   range V          older, known or newer, against the series recorded here
#   wrapped          the series `go` should provide here
#   floor            oldest darwin major on which `go` is offered at all
#   oldest_packaged  oldest series shipped as a go-1.NN port
#
# These answer with version strings, not numbers. Never put one through
# expr, which renormalises "1.20" to "1.2". Compare with vercmp.
#
# Two floors rather than one, because where a release runs and where it is
# handed to everyone are different questions. Separating them lets a toolchain
# be built and used on a system before users there are moved onto it.
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
# Declaring a minimum from a downstream port
# ------------------------------------------
#
# A port built with the golang PortGroup can name the oldest Go it works
# with:
#
#   go.toolchain_min      1.24.11
#
# What gates it is ceiling. Where this system is not offered that series the
# golang PortGroup sets known_fail, so the port is skipped rather than built
# against a Go that cannot satisfy it; where no Go runs at all, it is skipped
# regardless. Only the series is compared, since MacPorts ships the newest
# patch of each series it packages.
#
# The value belongs in a Portfile only when the build runs in module mode
# (go.offline_build no), where Go reads go.mod and enforces its `go`
# directive. In GOPATH mode go.mod is not consulted and the directive is only
# an upper bound on what the source needs, so declaring it risks skipping a
# port that would have built. The golang PortGroup owns the option and
# documents that distinction.
#
#
# Adding a new Go series
# ----------------------
#
#   1. min_darwin: the oldest darwin major its binaries load on, read off the
#      release rather than off upstream's supported floor -- see "How far back
#      a Go release runs" below for the symbols and why the two differ.
#
#      Required even when no port follows. ceiling walks this table, so a
#      missing series leaves systems reporting they can run something they
#      cannot, and the golang PortGroup refuses a go.toolchain_min above
#      anything recorded here.
#
#   2. min_default: only if the series should not yet be offered as `go`
#      everywhere it loads. Omit and it is offered wherever it runs.
#
#   3. packaged: only if a go-1.NN port is created. setup refuses a
#      version-named port whose series is absent here.
#
#   4. lang/go-1.NN/Portfile: go_toolchain.setup with the full version, plus
#      checksums.
#
# Steps 3 and 4 belong in one change: a series listed without a port leaves
# `go` depending on a toolchain that does not exist, and a port whose series is
# unlisted is refused outright. Nothing else needs touching -- every ceiling
# recomputes from the tables.
#
# Retiring a series reverses steps 3 and 4. Its min_darwin entry can stay,
# recording what the release requires rather than what is shipped.
#
# A patch update, 1.26.5 to 1.26.6, touches only that port's own Portfile.
#
#
# How far back a Go release runs
# ------------------------------
#
# Upstream publishes a supported floor per release
# (https://go.dev/wiki/MinimumRequirements): 10.13 from 1.17, 10.15 from 1.21,
# 11 from 1.23, 12 from 1.25, 13 from 1.27. Those state what upstream
# supports. min_darwin records something narrower and testable: where the
# binaries still start. The two agree for 1.18 through 1.20 and again from
# 1.25, and part company for 1.21 through 1.24.
#
# What ends a Go binary is an unresolved symbol. crypto/x509 reaches
# Security.framework through //go:cgo_import_dynamic even when CGO is
# disabled, and those imports are non-lazy, so dyld binds them all at load.
# The directives live in src/crypto/x509/internal/macos/security.go; read them
# there when a new series appears.
#
# 1.20 through 1.24 declare an identical set that 10.13 satisfies. Its newest
# member, SecTrustEvaluateWithError, is marked macos(10.14) in the SDK but
# resolves on 10.13 -- 1.20 imports it too, and upstream supports 1.20 there.
# 1.25 replaces the deprecated SecTrustGetCertificateAtIndex and
# SecTrustGetCertificateCount with SecTrustCopyCertificateChain, macOS 12 and
# later only, and older systems abort before main. That substitution is the
# entire cliff, and it is what #73086 hits.
#
# LC_BUILD_VERSION is not the limit: 1.24.8 declares minos 11.0 and ran on
# 10.13 through 11 for the nine months MacPorts shipped it, because macOS dyld
# loads a binary whose minos exceeds the running system. Only the missing
# symbol is fatal, which is why these tables follow the imports.
#
# See https://trac.macports.org/ticket/73086.

# The oldest darwin major version each Go series runs on.
#
# An entry is needed for any series that has a port, and for any series that
# is the newest runnable on some version of macOS. 1.17 and 1.27 are the two
# values not established by the imports above; both are noted below.
set go_toolchain.min_darwin(1.17)   11  ;# 10.7  Lion          (see below)
set go_toolchain.min_darwin(1.18)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.19)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.20)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.21)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.22)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.23)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.24)   17  ;# 10.13 High Sierra
set go_toolchain.min_darwin(1.25)   21  ;# 12    Monterey
set go_toolchain.min_darwin(1.26)   21  ;# 12    Monterey
set go_toolchain.min_darwin(1.27)   22  ;# 13    Ventura      (see below)

# The oldest darwin major version from which a series may be chosen as the
# default Go. Absent means min_darwin, the usual case: a release that runs
# somewhere is the release to offer there.
#
# Entries are temporary by intent. Each holds a series back from systems it
# loads on but has not been exercised on. Delete one once its series has been
# built and used below its old floor and `go` picks it up on the next rebuild;
# nothing else changes.
#
# The four below are the series min_darwin moved to darwin 17 on the strength
# of their imports. That argument says they load on 10.13, not that the
# toolchain behaves, and the buildbots have never built them that low.
# Widening min_darwin alone puts go-1.22, go-1.23 and go-1.24 on the 10.13,
# 10.14 and 10.15 builders for the first time, which is what settles it, while
# `go` keeps handing those systems what it hands them today.
set go_toolchain.min_default(1.21)  19  ;# 10.15 Catalina
set go_toolchain.min_default(1.22)  19  ;# 10.15 Catalina
set go_toolchain.min_default(1.23)  20  ;# 11    Big Sur
set go_toolchain.min_default(1.24)  20  ;# 11    Big Sur

# 1.17 is not a load-time limit but MacPorts' own. Upstream supports 10.13 and
# ships no binary that runs below it; MacPorts builds 1.17.13 from source with
# legacysupport, which is what makes any Go available on older systems. 10.7
# is the limit of that: 10.6 cannot build it, because its dsymutil aborts on
# the debug information Go's linker emits. See lang/go-1.17.
#
# 1.27 is upstream's support floor, carried over unchecked. Its imports have
# not been read, and on the evidence above its real floor may well be darwin
# 21, the same as 1.25 and 1.26.
#
# The value is not idle in the meantime: setup derives go-devel's platforms
# from it, so go-devel is offered only on 13 Ventura and later. It is never
# returned as a ceiling, being the newest series here, so nothing else is
# affected. Read the imports before packaging a go-1.27.

# The series MacPorts packages as go-1.NN ports.
#
# This cannot be derived from the table above, which records the releases that
# exist rather than the ones shipped: 1.18, 1.19 and 1.21 have no port, and
# 1.27 exists only as the prerelease.
#
# A list of series rather than of versions, so that a patch update touches only
# the toolchain's own Portfile.
set go_toolchain.packaged {1.17 1.20 1.22 1.23 1.24 1.25 1.26}

# The newest series MacPorts packages.
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

# The oldest series MacPorts packages.
proc go_toolchain.oldest_packaged {} {
    global go_toolchain.packaged

    set oldest {}
    foreach series ${go_toolchain.packaged} {
        if {${oldest} eq "" || [vercmp ${series} < ${oldest}]} {
            set oldest ${series}
        }
    }
    return ${oldest}
}

# The oldest darwin major version on which any packaged Go runs. Below this no
# Go is available at all, and the `go` port is not offered.
proc go_toolchain.floor {} {
    return [go_toolchain.min_darwin [go_toolchain.oldest_packaged]]
}

# The series the `go` port should provide here, or {} when no Go release runs
# on this system at all.
#
# A capped system gets the newest release it can run, an uncapped one the
# newest packaged. Both are the newest usable Go, which is what `go` means.
#
# A system capped at a series that is not packaged is a fault in the two tables
# rather than a property of the system, so it is an error and not another empty
# answer: `go` would otherwise be offered here, since the floor is below us,
# while depending on a toolchain that does not exist.
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
        return -code error "go_toolchain: this system is capped at Go\
            ${ceiling}, which go_toolchain.packaged does not list. Package that\
            series, or drop it from go_toolchain.min_darwin if it should not be\
            a ceiling."
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

# The oldest series in go_toolchain.min_darwin.
proc go_toolchain._oldest {} {
    global go_toolchain.min_darwin

    set oldest {}
    foreach minor [array names go_toolchain.min_darwin] {
        if {${oldest} eq "" || [vercmp ${minor} < ${oldest}]} {
            set oldest ${minor}
        }
    }
    return ${oldest}
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

# The oldest darwin major version from which a release may be the default Go,
# which is its load-time floor unless go_toolchain.min_default holds it back.
proc go_toolchain.min_default {go_version} {
    global go_toolchain.min_default

    set minor [go_toolchain._minor ${go_version}]
    if {[info exists go_toolchain.min_default(${minor})]} {
        return [set go_toolchain.min_default(${minor})]
    }
    return [go_toolchain.min_darwin ${go_version}]
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
    foreach minor [array names go_toolchain.min_darwin] {
        if {${os.major} >= [go_toolchain.min_default ${minor}]} {
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

# Where a version sits relative to the series this table records:
#
#   older   below every series recorded, and so below every ceiling
#   known   within the recorded range
#   newer   above every series recorded
#
# A caller validating a declared minimum should treat "newer" as an error:
# either the value is wrong, or it names a release whose macOS floor has not
# been recorded here, and neither can be gated correctly. "older" means the
# value can never gate anything.
proc go_toolchain.range {version} {
    set series [go_toolchain._minor ${version}]

    if {[vercmp ${series} > [go_toolchain._newest]]} {
        return newer
    }
    if {[vercmp ${series} < [go_toolchain._oldest]]} {
        return older
    }
    return known
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
#
# An uncapped system is not a system that can satisfy anything. Every recorded
# series runs there, but `go` can only hand over one that go_toolchain.packaged
# lists, so the comparison is against the newest of those -- which is exactly
# what wrapped returns there.
#
# 1.27 is the case in point. It is recorded, and lang/go-devel builds it, but
# a labelled port is not a packaged series and `go` never selects it. Without
# this, a port declaring go.toolchain_min 1.27 is reported satisfiable on
# darwin 22 and later and then built against the 1.26 that `go` provides.
proc go_toolchain.satisfies {minimum} {
    set ceiling [go_toolchain.ceiling]

    if {${ceiling} eq "none"} {
        return 0
    }
    if {${minimum} eq ""} {
        return 1
    }
    if {${ceiling} eq ""} {
        set ceiling [go_toolchain._newest_packaged]
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
