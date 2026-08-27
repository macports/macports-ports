# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# What MacPorts knows about the Zig release series it packages: where each one
# runs, what it builds against, and where it is installed. Plus the build of a
# versioned toolchain port.
#
# Two kinds of port sit on top of this:
#
#   lang/zig-0.NN   the toolchains, each built by zig_toolchain.setup and
#                   installed side by side under ${prefix}/libexec/zig-0.NN,
#                   reachable as ${prefix}/bin/zig-0.NN
#
#   lang/zig        a wrapper with no build of its own, linking to whichever
#                   series zig_toolchain.current_series names
#
# Including this PortGroup has no side effects. It defines tables and
# procedures and nothing else, so anything may include it purely to ask --
# a downstream port pinning a series, a wrapper port with no build of its own,
# or a future consumer PortGroup. The cmake group that toolchain ports need is
# pulled in by zig_toolchain.setup rather than here, so a caller that only
# queries does not inherit a configure phase.
#
#
# Queries
# -------
#
#   current_series   the series the `zig` port provides
#   min_darwin V     oldest darwin major the release supports
#   llvm V           LLVM major the release builds against
#   install_prefix V where that series' toolchain is installed
#   llvm_prefix V    where the LLVM it builds against is installed
#   bin V            the versioned command, ${prefix}/bin/zig-0.NN
#
# Each accepts either a series ("0.16") or a full version ("0.16.0"), and
# errors on a series that has no entry rather than inventing an answer.
#
# These deal in strings, not numbers. Never put a series through expr,
# including an expr ternary: Tcl renormalises 0.20 to 0.2 and 0.10 to 0.1,
# which then matches no table entry. Compare with vercmp or string equality
# and interpolate directly.
#
#
# Why versioned toolchains
# ------------------------
#
# Zig is pre-1.0 and breaks the language and the standard library at every
# minor release, so a project written against one series generally does not
# build with the next. The alternative to pinning is patching each consumer
# forward on every Zig bump, which the tree has been doing: sysutils/ncdu has
# carried such a patch twice, most recently a 1207-line stdlib migration to
# reach 0.16.
#
# The pin is therefore an exact series, not a minimum. That is the opposite of
# the golang PortGroup's go.toolchain_min, and the difference is not
# stylistic: Go keeps a compatibility promise and Zig does not.
#
#
# Building a toolchain port
# -------------------------
#
#   PortGroup           zig_toolchain 1.0
#
#   zig_toolchain.setup 0.16.0
#
#   checksums           ...
#   patchfiles-append   ...
#
# setup derives the port name, its platform floor, the LLVM it builds against,
# and the whole build, and brings in the cmake PortGroup. zig-0.16 installs
# under ${prefix}/libexec/zig-0.16 and is reachable as ${prefix}/bin/zig-0.16,
# so toolchains never collide with each other or with the `zig` port.
#
# Patches stay in the Portfile. They track upstream source that changes shape
# between releases -- both series in the tree carry a libc++ linking patch, and
# the two versions of it touch different code -- so there is nothing to share.
#
#
# Adding a new series
# -------------------
#
#   1. zig_toolchain.min_darwin: the oldest darwin major the release supports,
#      from the OS Version Requirements section of its release notes.
#   2. zig_toolchain.llvm: the LLVM major it builds against.
#   3. zig_toolchain.packaged: add the series.
#   4. lang/zig-0.NN/Portfile: zig_toolchain.setup with the full version, plus
#      checksums and any patches.
#
# setup refuses a series absent from zig_toolchain.packaged, so a toolchain
# cannot be added or removed in only one of the two places. A patch update,
# 0.16.0 to 0.16.1, touches only that port's own Portfile.
#
# Two things are deliberately absent.
#
# The ceiling machinery of go_toolchain, which works out the newest release a
# given macOS can run and caps downstream ports accordingly, has nothing to
# compute here: every series packaged so far requires darwin 22. The
# zig_toolchain.min_darwin table below is the data it would need, so it can be
# added if and when the series diverge.
#
# lang/zig-bootstrap is not a point on this axis. It is a dependency-free build
# of the current release, selected by archivers/shichizip to work around an
# emutls bug rather than for its version, and nothing here selects it.


# The oldest darwin major version each Zig series supports.
set zig_toolchain.min_darwin(0.15)  22  ;# 13 Ventura
set zig_toolchain.min_darwin(0.16)  22  ;# 13 Ventura

# The LLVM major each Zig series builds against. Zig tracks LLVM closely and a
# series does not build against any other.
set zig_toolchain.llvm(0.15)        20
set zig_toolchain.llvm(0.16)        21

# The series MacPorts packages as lang/zig-0.NN ports.
#
# A list of series rather than of versions, so that a patch update touches only
# the toolchain's own Portfile.
set zig_toolchain.packaged          {0.15 0.16}

# The series the `zig` port provides.
#
# Named rather than derived from the newest packaged series, so that adding a
# lang/zig-0.NN port does not move every `zig` user onto it in the same commit.
# Bumping this is the separate, deliberate step that does.
set zig_toolchain.current_series    0.16


# The release series of a version: 0.16 from 0.16.0, and 0.16 from 0.16.
proc zig_toolchain._series {zig_version} {
    if {![regexp {^([0-9]+\.[0-9]+)} ${zig_version} -> series]} {
        return -code error "zig_toolchain: cannot read a release series from ${zig_version}"
    }
    return ${series}
}

# The series of a version, checked against what MacPorts actually packages.
#
# The path queries answer only for packaged series: a path naming a toolchain
# that is not packaged is a path to something that will never exist, and
# handing one back turns a caller's typo into a missing-command failure much
# later. min_darwin and llvm are not restricted this way -- their tables record
# what a release requires, which stays true whether or not it is shipped.
proc zig_toolchain._packaged_series {zig_version} {
    global zig_toolchain.packaged

    set series [zig_toolchain._series ${zig_version}]
    if {[lsearch -exact ${zig_toolchain.packaged} ${series}] < 0} {
        return -code error "zig_toolchain: Zig ${series} is not packaged;\
            zig_toolchain.packaged has [join ${zig_toolchain.packaged} {, }]"
    }
    return ${series}
}

# The series the `zig` port provides, checked against what is packaged so a
# typo here cannot produce a `zig` depending on a toolchain that does not exist.
proc zig_toolchain.current_series {} {
    global zig_toolchain.current_series

    return [zig_toolchain._packaged_series ${zig_toolchain.current_series}]
}

# The oldest darwin major version a release supports.
proc zig_toolchain.min_darwin {zig_version} {
    global zig_toolchain.min_darwin

    set series [zig_toolchain._series ${zig_version}]
    if {![info exists zig_toolchain.min_darwin(${series})]} {
        return -code error "zig_toolchain: unknown Zig release ${zig_version}"
    }
    return [set zig_toolchain.min_darwin(${series})]
}

# The LLVM major a release builds against.
proc zig_toolchain.llvm {zig_version} {
    global zig_toolchain.llvm

    set series [zig_toolchain._series ${zig_version}]
    if {![info exists zig_toolchain.llvm(${series})]} {
        return -code error "zig_toolchain: no LLVM recorded for Zig ${zig_version}"
    }
    return [set zig_toolchain.llvm(${series})]
}

# Where a series' toolchain is installed. The whole toolchain lives under here,
# with its own bin/zig and its own lib/zig, which is what lets several be
# installed at once.
proc zig_toolchain.install_prefix {zig_version} {
    global prefix

    return ${prefix}/libexec/zig-[zig_toolchain._packaged_series ${zig_version}]
}

# Where the LLVM a series builds against is installed.
proc zig_toolchain.llvm_prefix {zig_version} {
    global prefix

    return ${prefix}/libexec/llvm-[zig_toolchain.llvm ${zig_version}]
}

# The versioned command a series is reached by. This is the path a port pinning
# a series should invoke; it resolves into that series' own install prefix.
proc zig_toolchain.bin {zig_version} {
    global prefix

    return ${prefix}/bin/zig-[zig_toolchain._packaged_series ${zig_version}]
}

# A livecheck pattern matching only the patch releases of one series, so a
# toolchain is not reported as outdated against a newer series.
proc zig_toolchain._livecheck_regex {series} {
    set esc [string map {. {\.}} ${series}]
    return [subst -nocommands -nobackslashes {href="(${esc}\.[0-9]+)/"}]
}


# Configure this Portfile as a versioned Zig toolchain port.
proc zig_toolchain.setup {zig_version} {
    global prefix homepage os.platform os.major xcodeversion xcodecltversion

    # A toolchain cannot be added in only one of the two places: this refuses
    # a Portfile whose series is missing from zig_toolchain.packaged, and the
    # lookups below refuse one missing from the other two tables.
    set series [zig_toolchain._packaged_series ${zig_version}]
    set llvm   [zig_toolchain.llvm ${series}]

    # Brought in here rather than at file scope so that including this
    # PortGroup to ask a question does not also impose a configure phase.
    #
    # The uplevel is required rather than decorative: PortGroup sources a group
    # file into its caller's frame, so calling it plainly from inside this proc
    # would source cmake into a proc frame instead of the Portfile's. Same
    # idiom as golang-1.0 and R-1.0, which pull in a host group this way.
    uplevel "PortGroup cmake 1.1"

    name                zig-${series}
    version             ${zig_version}
    categories          lang
    license             MIT
    homepage            https://ziglang.org/

    maintainers         nomaintainer

    description         Zig programming language ${series}

    long_description    \
        Zig is a general-purpose programming language designed for robustness, \
        optimality, and maintainability. This port provides the ${series} \
        release series, installed alongside any other Zig toolchain as \
        zig-${series}, for building software written against ${series}. Zig \
        changes the language and the standard library at every minor release, \
        so software is generally tied to the series it was written for.

    # The oldest macOS this release supports.
    platforms           "darwin >= [zig_toolchain.min_darwin ${series}]"

    supported_archs     arm64 x86_64
    universal_variant   no

    master_sites        ${homepage}download/${zig_version}/
    distname            zig-${zig_version}
    use_xz              yes

    # Share one distfiles directory across the toolchains and the `zig` port,
    # which all fetch from the same place under the same names.
    dist_subdir         zig

    patch.args          -p1

    # zlib, zstd and libxml2 are recorded as direct load commands of the zig
    # binary, alongside libLLVM and libclang-cpp, so they are declared here.
    #
    # ncurses is deliberately not: lang/zig has declared it since the port was
    # written, but nothing reaches it on macOS. MacPorts' llvm-config reports
    # no --system-libs at all, libLLVM.dylib does not link curses, and zig's
    # CMakeLists names it only under ZIG_STATIC_CURSES, which defaults off and
    # is not set here. The built binary has no reference to it.
    depends_lib-append  port:llvm-${llvm} \
                        port:clang-${llvm} \
                        port:libxml2 \
                        port:zlib \
                        port:zstd

    compiler.whitelist  macports-clang-${llvm}

    cmake.install_prefix \
                        [zig_toolchain.install_prefix ${series}]
    cmake.prefix_path   [zig_toolchain.llvm_prefix ${series}]
    cmake.install_rpath-append \
                        [zig_toolchain.llvm_prefix ${series}]/lib

    # Link against LLVM's shared library rather than its static archives.
    #
    # Belt and braces today: neither ZIG_SHARED_LLVM nor ZIG_STATIC_LLVM
    # defaults on, and llvm-config then hands back libLLVM.dylib regardless,
    # which is how lang/zig ends up with a shared link without asking for one.
    # Saying so makes it a decision rather than a consequence of how MacPorts
    # happens to build LLVM.
    configure.args-append \
                        -DZIG_SHARED_LLVM=ON

    # Raise the build runner's memory budget.
    #
    # Every step in build.zig declares an upper bound on its memory use, and
    # the runner errors out on any step declaring more than it believes is
    # available -- by default, the machine's own memory. The compiler step
    # declares roughly 8 GB (7_800_000_000 in 0.15, 8_000_000_000 in 0.16), so
    # the build fails outright on the buildbots and on any machine with less.
    #
    # Raise the budget rather than editing the declarations down, which is what
    # the runner's own error message tells you to do. The declaration is not
    # only a scheduling hint: it also ulimits the step's child process, so
    # shrinking one to fit trades a clear "exceeds the available memory" error
    # for a confusing ulimit failure the day a release genuinely needs what it
    # asks for. Editing also means chasing a literal that moves every release,
    # and even its formatting is inconsistent -- 0.15 writes two of its three
    # declarations without digit separators.
    #
    # A raised budget can in principle let the runner over-schedule concurrent
    # steps. It cannot here: the only step this build requests is the compiler
    # itself. The other declarations belong to test steps outside the default
    # graph, which is also why the 9_300_000_000 one in 0.16 has never had to
    # be dealt with -- no amount of lowering would have fitted it on a 7 GB
    # machine, and the port builds there today regardless.
    #
    # --maxrss is documented as taking <bytes>, so pass a plain byte count and
    # depend on no suffix parsing: 16 GiB, comfortably above any declaration so
    # far.
    #
    # --search-prefix gives the stage3 link somewhere to find zlib, zstd and
    # libxml2. cmake asks llvm-config for `--system-libs --link-static`
    # whenever the link mode is shared, which it is here, and that answers
    # `-lm -lz -lzstd -lxml2` -- bare flags Zig has to resolve itself. Its only
    # -L is LLVM's own libdir, so without this the search falls through to the
    # SDK, which carries libz and libxml2 but no libzstd, and the link fails.
    #
    # MacPorts does set LIBRARY_PATH to ${prefix}/lib and Zig honours it, which
    # is why this can appear to work; do not rely on that, as it does not hold
    # everywhere the port is built.
    #
    # The flags and their values are elements of one cmake list, separated by
    # semicolons. The double quotes are what keep those semicolons intact:
    # MacPorts concatenates configure.args into a shell string without quoting
    # them itself, so an unquoted one would end the command and leave the shell
    # trying to run the number. The backslashes match the idiom used elsewhere
    # in the tree (see lang/ispc, multimedia/x265); Tcl drops them long before
    # the shell sees them, so it is the quotes doing the work.
    configure.args-append \
                        -DZIG_EXTRA_BUILD_ARGS="--maxrss\;17179869184\;--search-prefix\;${prefix}"

    # Xcode 15 introduced a linker that cannot build these Zig releases.
    #
    # TODO: This is a temporary solution; Apple will remove the classic linker
    # in a future release.
    if {${os.platform} eq "darwin" && ${os.major} == 23
            && ([vercmp ${xcodeversion} 15] >= 0
                || [vercmp ${xcodecltversion} 15] >= 0)} {
        configure.ldflags-append \
                        -Wl,-ld_classic
    }

    post-destroot {
        # A versioned command, so the toolchain is usable by hand and can be
        # named by ports that pin it.
        #
        # A symlink is enough: Zig finds its lib directory by walking up from
        # the resolved path of its own executable, so it lands in this port's
        # own libexec tree rather than another toolchain's. No wrapper and no
        # ZIG_LIB_DIR are needed.
        #
        # The series is recovered from ${version} rather than captured, since
        # a destroot block is evaluated long after setup has returned.
        set series [zig_toolchain._series ${version}]

        xinstall -d ${destroot}${prefix}/bin
        ln -s [zig_toolchain.install_prefix ${series}]/bin/zig \
            ${destroot}[zig_toolchain.bin ${series}]
    }

    livecheck.type      regex
    livecheck.url       ${homepage}download/
    livecheck.regex     [zig_toolchain._livecheck_regex ${series}]
}
