# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup installs bun modules from the npm registry.
#
#   PortGroup           bun 1.0
#   bun.rootname        @scope/package
#
# bun.lockfile (${filespath}/bun.lock) is required. From the distfile:
#   cp ${distpath}/${distname}.tgz /tmp && cd /tmp
#   # { "dependencies": { "${bun.rootname}": "file:./${distname}.tgz" } }
#   bun install --lockfile-only && cp bun.lock ${filespath}/
#
# bun.trusted_dependencies  extra packages whose scripts may run (replaces bun's allowlist)
# bun.version               optional minimum bun
#
# destroot needs network; bun.lock pins the rest.
# ${prefix}/lib/bun/${name}, bins in ${prefix}/bin.

options bun.rootname bun.version bun.trusted_dependencies bun.add_dependencies \
        bun.lockfile
default bun.rootname                {${name}}
default bun.version                 {}
default bun.trusted_dependencies    {}
default bun.add_dependencies        yes
default bun.lockfile                {${filespath}/bun.lock}

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

# bun install from the extract dir would symlink it, then extract removes it.
extract.only

use_configure no
build         {}

destroot {
    set g    ${destroot}${prefix}/lib/bun/${name}
    set bin  ${destroot}${prefix}/bin
    set root ${bun.rootname}
    set tar  ${distname}${extract.suffix}
    set lock ${bun.lockfile}

    if {![file isfile ${lock}]} {
        return -code error "missing bun.lockfile ${lock}"
    }
    if {${bun.version} ne ""} {
        set bun_ver [string trim [exec ${prefix}/bin/bun --version]]
        if {[vercmp ${bun_ver} ${bun.version}] < 0} {
            return -code error "${name} requires bun >= ${bun.version} (found ${bun_ver})"
        }
    }

    xinstall -d ${g} ${bin}
    xinstall -m 0644 ${distpath}/[getdistname [lindex ${distfiles} 0]] ${g}/${tar}
    xinstall -m 0644 ${lock} ${g}/bun.lock

    set trusted [lsort -unique [list ${root} {*}${bun.trusted_dependencies}]]
    set quoted {}
    foreach d ${trusted} {
        lappend quoted "\"$d\""
    }
    set fd [open ${g}/package.json w]
    puts ${fd} "{ \"private\": true, \"trustedDependencies\": \[[join ${quoted} {, }]\], \"dependencies\": { \"${root}\": \"file:./${tar}\" } }"
    close ${fd}

    system -W ${g} "env BUN_INSTALL_CACHE_DIR=${workpath}/.bun-cache bun install --frozen-lockfile --verbose"
    file delete ${g}/${tar}

    set pkg [file normalize ${g}/node_modules/${root}]
    foreach f [glob -nocomplain -tails -directory ${g}/node_modules/.bin *] {
        if {[file type ${g}/node_modules/.bin/${f}] ne "link"} {
            continue
        }
        set dest [file normalize [file join ${g}/node_modules/.bin [file readlink ${g}/node_modules/.bin/${f}]]]
        if {[string first ${pkg}/ ${dest}/] != 0} {
            continue
        }
        set rel [string range ${dest} [expr {[string length [file normalize ${g}]] + 1}] end]
        ln -s ../lib/bun/${name}/${rel} ${bin}/${f}
    }
    if {[glob -nocomplain ${bin}/*] eq {}} {
        return -code error "bun install produced no binaries"
    }
}
