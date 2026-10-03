# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup installs bun modules from the npm registry with
# `bun install -g`.
#
# Usage:
#
#   PortGroup           bun 1.0
#
#   bun.rootname        @scope/package
#
# bun.rootname is the npm package name (including scope). Distfiles for
# scoped packages are unscoped (`package-1.0.0.tgz`), so distname is derived
# with [file tail ${bun.rootname}] and does not need to be set by the port.
#
# bun.version is an optional minimum bun version. Checked at fetch and
# destroot; bun may not be installed at fetch time (depends_lib is only
# installed for configure phase).
#
# bun.trusted_dependencies is a list of extra package names whose lifecycle
# scripts (postinstall, prepare, ...) bun may run. Unlike npm, bun runs no
# lifecycle scripts unless the package is trusted. This PortGroup always
# writes a trustedDependencies field, which replaces bun's default allowlist
# rather than extending it. Every dependency needing a lifecycle script must
# be listed here, including ones a stock `bun install -g` would have trusted
# (sharp, for instance). destroot runs bun with --verbose, so blocked scripts
# are named in the log.
#
# The packaged module itself (${bun.rootname}) is always trusted, because
# the install is from a local tarball and bun requires an explicit trust for
# non-registry sources.
#
# Known limitation: bun links bins while installing and does not re-link after
# lifecycle scripts, so bins created only in postinstall never reach ${prefix}/bin.
# destroot fails on empty bin directory rather than installing a port with no binaries.
#
# bun.add_dependencies (default yes) adds path:bin/bun:bun to depends_lib.
# The shebang is `#!/usr/bin/env bun`, so bun is a library dependency.
#
# destroot needs network: bun resolves and fetches the dependency tree from
# registry.npmjs.org. Only the top-level tarball is checksummed.
#
# bun.minimum_release_age sets a supply-chain delay (seconds). destroot passes
# `bun install --minimum-release-age` to skip registry-resolved versions newer
# than this window (requires bun 1.3+). Set to 0 to disable.
#
# Each port destroots to ${prefix}/lib/bun/${name} with bins linked into
# ${prefix}/bin, so multiple bun-PG ports can activate together. bun writes
# relative symlinks, so destroot paths do not leak.

options bun.rootname bun.version bun.trusted_dependencies bun.add_dependencies \
        bun.minimum_release_age
default bun.rootname                {${name}}
default bun.version                 {}
default bun.trusted_dependencies    {}
default bun.add_dependencies        yes
default bun.minimum_release_age     259200 ;# 3 days

default master_sites    {https://registry.npmjs.org/${bun.rootname}/-/}
default distname        {[file tail ${bun.rootname}]-${version}}
default extract.suffix  {.tgz}

default livecheck.type  regex
default livecheck.url   {https://registry.npmjs.org/${bun.rootname}/latest}
default livecheck.regex {\\"version\\":\\"(\[^\\"\]+)\\"}

proc bun_add_dependencies {} {
    if {![option bun.add_dependencies]} {
        return
    }
    depends_lib-delete      path:bin/bun:bun
    depends_lib-append      path:bin/bun:bun
}
port::register_callback bun_add_dependencies

# Pass the tarball distfile to 'bun install' directly, since running
# 'bun install' from the extracted directory creates a symlink to the
# directory (which gets removed). Since there's no need to extract the
# tarball, disable the extraction step.
extract.only

use_configure no

build   {}

proc bun_minimum_release_age_seconds {} {
    set min_age [option bun.minimum_release_age]
    if {${min_age} eq ""} {
        return 0
    }
    if {![string is entier -strict ${min_age}] || ${min_age} < 0} {
        return -code error "bun.minimum_release_age must be a non-negative integer (seconds), got: ${min_age}"
    }
    return ${min_age}
}

proc bun_check_version {phase} {
    set required [option bun.version]
    # --minimum-release-age was added in bun 1.3.
    if {[bun_minimum_release_age_seconds] > 0} {
        if {${required} eq "" || [vercmp ${required} 1.3.0] < 0} {
            set required 1.3.0
        }
    }
    if {${required} eq ""} {
        return
    }
    set bun_exe [option prefix]/bin/bun
    if {![file executable ${bun_exe}]} {
        # depends_lib is installed for the configure phase, so bun not being
        # there yet is expected at fetch time and an error later on.
        if {${phase} eq "fetch"} {
            return
        }
        return -code error "[option name] requires bun >= ${required}, but ${bun_exe} is missing"
    }
    if {[catch {exec ${bun_exe} --version} result]} {
        return -code error "cannot determine the version of ${bun_exe}: ${result}"
    }
    set bun_ver [string trim ${result}]
    if {[vercmp ${bun_ver} ${required}] < 0} {
        return -code error "[option name] requires bun >= ${required} (found ${bun_ver})"
    }
}

pre-fetch {
    bun_check_version fetch
}

pre-destroot {
    bun_check_version destroot
}

destroot {
    set bun_global_dir ${destroot}${prefix}/lib/bun/${name}
    set bun_bin_dir ${destroot}${prefix}/bin
    xinstall -d ${bun_global_dir} ${bun_bin_dir}

    # Always trust the packaged module. bun skips lifecycle scripts for
    # tarball/file installs unless the name is in trustedDependencies.
    set trusted [list ${bun.rootname}]
    foreach dep ${bun.trusted_dependencies} {
        if {${dep} ni ${trusted}} {
            lappend trusted ${dep}
        }
    }
    set quoted {}
    foreach dep ${trusted} {
        lappend quoted "\"[string map {\\ \\\\ \" \\\"} ${dep}]\""
    }
    set fd [open ${bun_global_dir}/package.json w]
    puts ${fd} "{ \"private\": true, \"trustedDependencies\": \[[join ${quoted} {, }]\] }"
    close ${fd}

    set distfile [lindex ${distfiles} 0]
    set age_flag ""
    set min_age [bun_minimum_release_age_seconds]
    if {${min_age} > 0} {
        set age_flag " --minimum-release-age=${min_age}"
    }
    system -W ${workpath} "env BUN_INSTALL_GLOBAL_DIR=[shellescape ${bun_global_dir}] BUN_INSTALL_BIN=[shellescape ${bun_bin_dir}] BUN_INSTALL_CACHE_DIR=[shellescape ${workpath}/.bun-cache] bun install -g --verbose${age_flag} [shellescape ${distpath}/${distfile}]"

    if {[glob -nocomplain ${bun_bin_dir}/*] eq {}} {
        ui_error "${name} destroot produced no binaries in ${prefix}/bin (the package has no bin field, or its bins are created by a lifecycle script, which runs too late to be linked)"
        return -code error "bun install produced no binaries"
    }
}
