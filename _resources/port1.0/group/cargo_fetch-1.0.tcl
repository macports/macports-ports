# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup supports the cargo build system
#
# This PortGroup is designed to be used when cargo is called from other
#    build mechanisms (e.g. configure and make).
# Use the cargo PortGroup if cargo is the exclusive build mechanism.
#
# Usage:
#
# PortGroup     cargo_fetch 1.0
#
# cargo.crates \
#     foo  1.0.1  abcdef123456... \
#     bar  2.5.0  fedcba654321...
#
# The cargo.crates option expects a list with 3-tuples consisting of name,
# version, and sha256 checksum. Only sha256 is supported at this time as
# the checksum will be reused by cargo internally.
#
# The list of crates and their checksums can be found in the Cargo.lock file in
# the upstream source code. The cargo2port generator can be used to automate
# updates of this list for new releases.
#
# To get a list of these, run in worksrcdir:
#     cargo update
#     egrep -e '^(name|version|checksum) = ' Cargo.lock | perl -pe 's/^(?:name|version|checksum) = "(.+)"/$1/'
#
# https://github.com/macports/macports-contrib/tree/master/cargo2port/cargo2port.tcl
#
# If Cargo.lock references pre-release versions, or in general references
# crates not published on crates.io, but available from GitHub, also use the
# following:
#
# # download additional crates from github, not published on crates.io
# cargo.crates_github \
#    baz    author/baz  branch  abcdef12345678...commit...abcdef12345678  fedcba654321...
#

PortGroup compiler_blacklist_versions 1.0
PortGroup legacysupport 1.1

options cargo.bin cargo.home cargo.crates cargo.crates_github

default cargo.bin           {${prefix}/bin/cargo}
default cargo.home          {${workpath}/.home/.cargo}
default cargo.crates        {}
default cargo.crates_github {}

# As building with rust uses the same underlying compiler as used to build it
# replicate the same compiler selection options here
compiler.cxx_standard       2017
compiler.blacklist-append   {macports-clang-[4-9].0}

# please remove when 8a088c3 has been in a released MacPorts version for at least two weeks
# see https://github.com/macports/macports-base/commit/8a088c30d80c7c3eca10848f28835e1c180229b1
if {"shellescape" ni [info commands shellescape]} {
    proc shellescape {arg} {
        return [regsub -all -- {[^A-Za-z0-9.:@%/+=_-]} $arg {\\&}]
    }
}

option_proc cargo.crates handle_cargo_crates
proc handle_cargo_crates {option action {value ""}} {
    if {${action} eq "set"} {
        foreach {cname cversion chksum} ${value} {
            set cratefile       ${cname}-${cversion}.crate
            # The same crate name can appear with multiple versions. Use
            # a combination of crate name and checksum as unique identifier.
            # As the :disttag cannot contain dots, the version number cannot be
            # used.
            #
            # To download the crate file curl-0.4.11.crate, the URL is
            #    https://crates.io/api/v1/crates/curl/0.4.11/download.
            # Use ?dummy= to ignore ${distfile}
            # see https://trac.macports.org/wiki/PortfileRecipes#fetchwithgetparams
            set cratetag        crate-${cname}-${chksum}
            distfiles-append    ${cratefile}:${cratetag}
            master_sites-append https://crates.io/api/v1/crates/${cname}/${cversion}/download?dummy=:${cratetag}
            checksums-append    ${cratefile} sha256 ${chksum}
        }
    }
}

option_proc cargo.crates_github handle_cargo_crates_github
proc handle_cargo_crates_github {option action {value ""}} {
    if {${action} eq "set"} {
        foreach {cname cgithub cbranch crevision chksum} ${value} {
            set cratefile       ${cname}-${crevision}.tar.gz
            # The same crate name can appear with multiple versions. Use
            # a combination of crate name and checksum as unique identifier.
            # As the :disttag cannot contain dots, the version number cannot be
            # used.
            set cratetag        crate-${cname}-${chksum}
            distfiles-append    ${cratefile}:${cratetag}
            master_sites-append https://github.com/${cgithub}/archive/${crevision}.tar.gz?dummy=:${cratetag}
            checksums-append    ${cratefile} sha256 ${chksum}
        }
    }
}

proc cargo._extract_crate {cratefile} {
    global cargo.home distpath

    set tar [findBinary tar ${portutil::autoconf::tar_path}]
    system -W "${cargo.home}/macports" "$tar -xf [shellescape ${distpath}/${cratefile}]"
}

proc cargo._write_cargo_checksum {cdirname chksum} {
    global cargo.home

    # although cargo will never see the .crate, it expects to find the sha256 checksum here
    set chkfile [open "${cargo.home}/macports/${cdirname}/.cargo-checksum.json" "w"]
    puts $chkfile "{"
    puts $chkfile "    \"package\": ${chksum},"
    puts $chkfile "    \"files\": {}"
    puts $chkfile "}"
    close $chkfile
}

proc cargo._import_crate {cname cversion chksum cratefile} {
    global cargo.home

    ui_info "Adding ${cratefile} to cargo home"
    cargo._extract_crate ${cratefile}
    cargo._write_cargo_checksum "${cname}-${cversion}" "\"${chksum}\""
}

proc cargo._import_crate_github {cname cgithub crevision chksum cratefile} {
    global cargo.home

    set crepo [lindex [split ${cgithub} "/"] 1]
    set cdirname "${crepo}-${crevision}"

    ui_info "Adding ${cratefile} from github to cargo home"
    cargo._extract_crate ${cratefile}
    cargo._write_cargo_checksum ${cdirname} "null"
}

# The distfiles of the main port will also be stored in this directory,
# but this is the only way to allow reusing the same crates across multiple ports.
default dist_subdir     {[cargo._dist_subdir]}

proc cargo._dist_subdir {} {
    global name cargo.crates cargo.crates_github
    if {[llength ${cargo.crates}] > 0 || [llength ${cargo.crates_github}]>0} {
        return cargo-crates
    } else {
        return ${name}
    }
}

default extract.only    {[cargo._disttagclean $distfiles]}

# based on portextract::disttagclean from portextract.tcl
proc cargo._disttagclean {list} {
    global cargo.crates cargo.crates_github
    if {$list eq ""} {
        return $list
    }
    foreach fname $list {
        set name [getdistname ${fname}]

        set is_crate no
        foreach {cname cversion chksum} ${cargo.crates} {
            set cratefile ${cname}-${cversion}.crate
            if {${name} eq ${cratefile}} {
                set is_crate yes
            }
        }
        foreach {cname cgithub cbranch crevision chksum} ${cargo.crates_github} {
            set cratefile ${cname}-${crevision}.tar.gz
            if {${name} eq ${cratefile}} {
                set is_crate yes
            }
        }
        if {!${is_crate}} {
            lappend val ${name}
        }
    }
    return $val
}

if {${subport} ne "cargo-bootstrap" && ${subport} ne "cargo-stage1" && ${subport} ne "cargo"} {
    depends_build-append port:cargo
    # do not force all Portfiles to switch from depends_build to depends_build-append
    proc cargo.add_dependencies {} {
        depends_build-delete port:cargo
        depends_build-append port:cargo
    }
    port::register_callback cargo.add_dependencies
}

post-extract {
    if {[llength ${cargo.crates}] > 0 || [llength ${cargo.crates_github}]>0} {
        file mkdir "${cargo.home}/macports"

        # avoid downloading files from online repository during build phase
        # use a replacement for crates.io
        # https://doc.rust-lang.org/cargo/reference/source-replacement.html
        set conf [open "${cargo.home}/config" "w"]
        puts $conf "\[source\]"
        puts $conf "\[source.macports\]"
        puts $conf "directory = \"${cargo.home}/macports\""
        puts $conf "\[source.crates-io\]"
        puts $conf "replace-with = \"macports\""
        puts $conf "local-registry = \"/var/empty\""
        foreach {cname cgithub cbranch crevision chksum} ${cargo.crates_github} {
            puts $conf "\[source.\"https://github.com/${cgithub}\"\]"
            puts $conf "git = \"https://github.com/${cgithub}\""
            puts $conf "branch = \"${cbranch}\""
            puts $conf "replace-with = \"macports\""
        }
        close $conf

        # import all crates
        foreach {cname cversion chksum} ${cargo.crates} {
            set cratefile ${cname}-${cversion}.crate
            cargo._import_crate ${cname} ${cversion} ${chksum} ${cratefile}
        }
        foreach {cname cgithub cbranch crevision chksum} ${cargo.crates_github} {
            set cratefile ${cname}-${crevision}.tar.gz
            cargo._import_crate_github ${cname} ${cgithub} ${crevision} ${chksum} ${cratefile}
        }
    }
}

# MacPorts use the name i386 for 32-bit Intel architecture
# Cargo and Rust use the name i686
proc cargo.translate_arch_name {arch} {
    if {${arch} eq "i386"} {
        return "i686"
    } elseif {${arch} eq "arm64"} {
        return "aarch64"
    } else {
        return ${arch}
    }
}

proc cargo.rust_platform {{arch ""}} {
    global os.platform configure.build_arch muniversal.current_arch
    if {${arch} eq ""} {
        if {[info exists muniversal.current_arch]} {
            set arch ${muniversal.current_arch}
        } else {
            set arch ${configure.build_arch}
        }
    }
    return [cargo.translate_arch_name ${arch}]-apple-${os.platform}
}

proc cargo.append_envs { var {phases {configure build destroot}} } {
    foreach phase ${phases} {
        ${phase}.env-delete ${var}
        ${phase}.env-append ${var}
    }
}

# see https://trac.macports.org/wiki/UsingTheRightCompiler
proc cargo.set_compiler_envs {} {
    global configure.cc configure.cxx
    cargo.append_envs CC=${configure.cc}   {build destroot}
    cargo.append_envs CXX=${configure.cxx} {build destroot}
    cargo.append_envs "RUSTFLAGS=-C linker=${configure.cc}"
}
port::register_callback cargo.set_compiler_envs

# Is build caching enabled ?
# WIP for now ...
#if {[tbool configure.ccache]} {
#    # Enable sccache for rust caching
#    depends_build-append port:sccache
#    cargo.append_envs    RUSTC_WRAPPER=${prefix}/bin/sccache
#    cargo.append_envs    SCCACHE_CACHE_SIZE=2G
#    cargo.append_envs    SCCACHE_DIR=${workpath}/.sccache
#}

# do not force all Portfiles to switch from ${stage}.env to ${stage}.env-append
proc cargo.environments {} {
    global os.major prefix configure.pkg_config_path
    global configure.cc configure.cxx subport configure.build_arch configure.universal_archs
    global merger_configure_env merger_build_env merger_destroot_env worksrcpath

    set cargo_ld ${configure.cc}
    if { ${os.major} <= [option legacysupport.newest_darwin_requires_legacy] } {
        # Use wrapped rust compilers
        depends_build-append port:rust-compiler-wrap
        configure.cc      ${prefix}/libexec/rust-compiler-wrap/bin/clang
        configure.cxx     ${prefix}/libexec/rust-compiler-wrap/bin/clang++
        configure.objc    ${prefix}/libexec/rust-compiler-wrap/bin/clang
        configure.objcxx  ${prefix}/libexec/rust-compiler-wrap/bin/clang++
        set cargo_ld      ${prefix}/libexec/rust-compiler-wrap/bin/ld-rust
    }

    cargo.append_envs     CC=${configure.cc}   {build destroot}
    cargo.append_envs     CXX=${configure.cxx} {build destroot}

    cargo.append_envs     "RUSTFLAGS=-C linker=${cargo_ld}"
    cargo.append_envs     "RUST_BACKTRACE=1"
    cargo.append_envs     "CARGO_BUILD_RUSTC=${prefix}/bin/rustc"

    # Propagate pkgconfig path to build and destroot phases as well
    # Needed to work with openssl PG
    if { ${configure.pkg_config_path} ne "" } {
        cargo.append_envs "PKG_CONFIG_PATH=${configure.pkg_config_path}" {build destroot}
    }

    # CARGO_BUILD_TARGET does not work correctly
    # see the patchfile path-dyld.diff in cargo Portfile
    if {${subport} ne "cargo-stage1"} {
        if {![variant_exists universal] || ![variant_isset universal]} {
            cargo.append_envs CARGO_BUILD_TARGET=[cargo.rust_platform ${configure.build_arch}] {configure build destroot}
        } else {
            foreach stage {configure build destroot} {
                foreach arch ${configure.universal_archs} {
                    lappend merger_${stage}_env(${arch}) \
                        CARGO_BUILD_TARGET=[cargo.rust_platform ${arch}]
                }
            }
        }
    }
}
port::register_callback cargo.environments

# see https://trac.macports.org/ticket/51643 for a similar case
PortGroup muniversal 1.0
