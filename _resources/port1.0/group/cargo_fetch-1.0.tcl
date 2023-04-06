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

PortGroup   muniversal          1.1
PortGroup   compiler_wrapper    1.0
# ideally, we would like to add the openssl PG, however
#     its use of `option_proc` makes changing the default value of `openssl.branch` difficult, and
#     it interferes with our intended use of compiler_wrapper PG
# for now, create an option `openssl.branch` in this PG
# Cargo's interaction with OpenSSL is a bit delicate
# see, e.g., https://trac.macports.org/ticket/65011
#
# similarly for legacysupport PG

options cargo.bin \
        cargo.home \
        cargo.dir \
        cargo.crates \
        cargo.offline_cmd \
        cargo.crates_github cargo.update

default cargo.bin           {${prefix}/bin/cargo}
default cargo.home          {${workpath}/.home/.cargo}
default cargo.dir           {${worksrcpath}}
default cargo.crates        {}
default cargo.crates_github {}

# if a dependency has been patched, `--offline` might be a reasonable choice
default     cargo.offline_cmd   {--frozen}

# some packags do not provide Cargo.lock,
# so offer the option of running cargo-update
default     cargo.update        {no}

# use `--remap-path-prefix` to prevent build information from bing included installed binaries
options     rust.remap
default     rust.remap          {${cargo.home} "" ${worksrcpath} ""}

# flags to be passed to the rust compiler
# --remap-path-prefix=... is eventually added unless rust.remap is empty
options     rust.flags
default     rust.flags          {}

# As building with rust uses the same underlying compiler as used to build it
# replicate the same compiler selection options here
default compiler.cxx_standard           2017
default compiler.thread_local_storage   yes

# do not include os.major in target triplet
default triplet.os          {${os.platform}}

# Rust does not easily pass external flags to compilers, so add them to compiler wrappers
default     compwrap.compilers_to_wrap          {cc cxx ld}
default     compwrap.ccache_supported_compilers {}

# possible OpenSSL versions: empty, 3, 1.1, and 1.0
options     openssl.branch
default     openssl.branch      {}

# the distfiles of the main port will also be stored in this directory,
# but this is the only way to allow reusing the same crates across multiple ports.
default     dist_subdir             {[expr {[llength ${cargo.crates}] > 0 || [llength ${cargo.crates_github}] > 0 ? "cargo-crates" : ${name}}]}
default     extract.only            {[rust::disttagclean $distfiles]}

# to wrap linker, compiler_wrapper PG required existence of configure.ld
options     configure.ld
default     configure.ld            {${configure.cc}}

####################################################################################################################################
# internal procedures
####################################################################################################################################

namespace eval rust {}

# based on portextract::disttagclean from portextract.tcl
proc rust::disttagclean {list} {
    if {$list eq ""} {
        return $list
    }
    foreach fname $list {
        set name [getdistname ${fname}]

        set is_crate no
        foreach {cname cversion chksum} [option cargo.crates] {
            set cratefile ${cname}-${cversion}.crate
            if {${name} eq ${cratefile}} {
                set is_crate yes
            }
        }
        foreach {cname cgithub cbranch crevision chksum} [option cargo.crates_github] {
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

proc rust::handle_crates {} {
    foreach {cname cversion chksum} [option cargo.crates] {
        # The same crate name can appear with multiple versions. Use
        # a combination of crate name and checksum as unique identifier.
        # As the :disttag cannot contain dots, the version number cannot be
        # used.
        #
        # To download the crate file curl-0.4.11.crate, the URL is
        #    https://crates.io/api/v1/crates/curl/0.4.11/download.
        # Use ?dummy= to ignore ${distfile}
        # see https://trac.macports.org/wiki/PortfileRecipes#fetchwithgetparams
        set cratefile       ${cname}-${cversion}.crate
        set cratetag        crate-${cname}-${chksum}
        distfiles-append    ${cratefile}:${cratetag}
        master_sites-append https://crates.io/api/v1/crates/${cname}/${cversion}/download?dummy=:${cratetag}
        checksums-append    ${cratefile} sha256 ${chksum}
    }

    foreach {cname cgithub cbranch crevision chksum} [option cargo.crates_github] {
        set cratefile       ${cname}-${crevision}.tar.gz
        set cratetag        crate-${cname}-${chksum}
        distfiles-append    ${cratefile}:${cratetag}
        master_sites-append https://github.com/${cgithub}/archive/${crevision}.tar.gz?dummy=:${cratetag}
        checksums-append    ${cratefile} sha256 ${chksum}
    }
}
port::register_callback rust::handle_crates

proc rust::extract_crate {cratefile} {
    set tar [findBinary tar ${portutil::autoconf::tar_path}]
    system -W "[option cargo.home]/macports" "$tar -xf [shellescape [option distpath]/${cratefile}]"
}

proc rust::write_cargo_checksum {cdirname chksum} {
    # although cargo will never see the .crate, it expects to find the sha256 checksum here
    set chkfile [open "[option cargo.home]/macports/${cdirname}/.cargo-checksum.json" "w"]
    puts $chkfile "{"
    puts $chkfile "    \"package\": ${chksum},"
    puts $chkfile "    \"files\": {}"
    puts $chkfile "}"
    close $chkfile
}
proc rust::old_macos_compatibility {cname cversion} {
    global cargo.home subport

    switch ${cname} {
        "kqueue" {
            if { [vercmp ${cversion} < 1.0.5] && "i386" in [option muniversal.architectures] } {
                # see https://gitlab.com/worr/rust-kqueue/-/merge_requests/10
                reinplace {s|all(target_os = "freebsd", target_arch = "x86")|all(any(target_os = "freebsd", target_os = "macos"), any(target_arch = "x86", target_arch = "powerpc"))|g} \
                    ${cargo.home}/macports/${cname}-${cversion}/src/time.rs
                cargo.offline_cmd-replace --frozen --offline
            }
        }
        "curl-sys" {
            if { [vercmp ${cversion} < 0.4.56] } {
                # on Mac OS X 10.6, clang exists, but `clang --print-search-dirs` returns an empty library directory
                # see https://github.com/alexcrichton/curl-rust/commit/b3a3ce876921f2e82a145d9abd539cd8f9b7ab7b
                # see https://trac.macports.org/ticket/64146#comment:16
                #
                # on other systems, we want the static library of the compiler we are using and not necessarily the system compiler
                # see https://github.com/alexcrichton/curl-rust/commit/a6969c03b1e8f66bc4c801914327176ed38f44c5
                # see https://github.com/alexcrichton/curl-rust/issues/279
                #
                # for upstream pull request, see https://github.com/alexcrichton/curl-rust/pull/451
                #
                reinplace "s|Command::new(\"clang\")|cc::Build::new().get_compiler().to_command()|g" \
                    ${cargo.home}/macports/${cname}-${cversion}/build.rs
            }
        }
    }

    # rust-bootstrap requires `macosx_deployment_target` instead of `os.major`
    if {[option os.platform] ne "darwin" || [vercmp [option macosx_deployment_target] >= 10.8]} {
        return
    }

    switch ${cname} {
        "crypto-hash" {
            # switch crypto-hash to use openssl instead of commoncrypto
            # See: https://github.com/malept/crypto-hash/issues/23
            reinplace "s|target_os = \"macos\"|target_os = \"macos_disabled\"|g" \
                ${cargo.home}/macports/${cname}-${cversion}/src/lib.rs
            reinplace "s|macos|macos_disabled|g" \
                ${cargo.home}/macports/${cname}-${cversion}/Cargo.toml
        }
        "curl-sys" {
            # curl-sys requires CCDigestGetOutputSizeFromRef which is only available since macOS 10.8
            # disable USE_SECTRANSP to avoid calling of CCDigestGetOutputSizeFromRef and use OpenSSL instead
            # See: https://github.com/alexcrichton/curl-rust/issues/429
            reinplace "s|else if target.contains(\"-apple-\")|else if target.contains(\"-apple_disabled-\")|g" \
                ${cargo.home}/macports/${cname}-${cversion}/build.rs
            reinplace "s|macos|macos_disabled|g" \
                ${cargo.home}/macports/${cname}-${cversion}/Cargo.toml
        }
        "libgit2-sys" {
            # libgit2-sys requires SSLCreateContext which is only available since macOS 10.8
            # disable GIT_SECURE_TRANSPORT to avoid calling of SSLCreateContext and use OpenSSL instead
            reinplace "s|else if target.contains(\"apple\")|else if target.contains(\"apple_disabled\")|g" \
                ${cargo.home}/macports/${cname}-${cversion}/build.rs
        }
    }

    if {[option os.platform] ne "darwin" || [vercmp [option macosx_deployment_target] >= 10.6]} {
        return
    }

    switch ${cname} {
        "notify" {
            reinplace {s|default = \["macos_fsevent"\]|default = \["macos_kqueue"\]|g} \
                ${cargo.home}/macports/${cname}-${cversion}/Cargo.toml
        }
        "cargo-util" {
            reinplace {s|#\[cfg(not(target_os = "macos"))\]|#\[cfg(not(target_os = "macos_temp"))\]|g} \
                ${cargo.home}/macports/${cname}-${cversion}/src/paths.rs
            reinplace {s|#\[cfg(target_os = "macos")\]|#\[cfg(not(target_os = "macos"))\]|g} \
                ${cargo.home}/macports/${cname}-${cversion}/src/paths.rs
            reinplace {s|#\[cfg(not(target_os = "macos_temp"))\]|#\[cfg(target_os = "macos")\]|g} \
                ${cargo.home}/macports/${cname}-${cversion}/src/paths.rs
        }
    }
}

proc rust::import_crate {cname cversion chksum cratefile} {
    global cargo.home

    ui_info "Adding ${cratefile} to cargo home"
    rust::extract_crate ${cratefile}
    rust::write_cargo_checksum "${cname}-${cversion}" "\"${chksum}\""
    rust::old_macos_compatibility ${cname} ${cversion}
}

proc rust::import_crate_github {cname cgithub crevision chksum cratefile} {
    global cargo.home

    set crepo [lindex [split ${cgithub} "/"] 1]
    set cdirname "${crepo}-${crevision}"

    ui_info "Adding ${cratefile} from github to cargo home"
    rust::extract_crate ${cratefile}
    rust::write_cargo_checksum ${cdirname} "null"
    rust::old_macos_compatibility ${cname} ${crevision}
}

post-extract {
    if {[llength ${cargo.crates}] > 0 || [llength ${cargo.crates_github}]>0} {
        file mkdir "${cargo.home}/macports"

        # avoid downloading files from online repository during build phase
        # use a replacement for crates.io
        # https://doc.rust-lang.org/cargo/reference/source-replacement.html
        set conf [open "${cargo.home}/config.toml" "w"]
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
            rust::import_crate ${cname} ${cversion} ${chksum} ${cratefile}
        }
        foreach {cname cgithub cbranch crevision chksum} ${cargo.crates_github} {
            set cratefile ${cname}-${crevision}.tar.gz
            rust::import_crate_github ${cname} ${cgithub} ${crevision} ${chksum} ${cratefile}
        }
    }

    if {${subport} ne "rust" && [join [lrange [split ${subport} -] 0 1] -] ne "rust-bootstrap"} {

        # see comment below concerning RUSTC and RUSTFLAGS

        file mkdir "${cargo.home}"
        set conf [open "${cargo.home}/config.toml" "a"]

        puts $conf "\[build\]"
        puts $conf "rustc = \"${prefix}/bin/rustc\""
        if {[option rust.flags] ne ""} {
            puts $conf "rustflags = \[\"[join [option rust.flags] {", "}]\"\]"
        }

        # be sure to include all architectures in case, e.g., a 64-bit Cargo compiles a 32-bit port
        foreach arch {arm64 x86_64 i386 ppc ppc64} {
            puts $conf "\[target.[option triplet.${arch}]\]"
            puts $conf "linker = \"[compwrap::wrap_compiler ld]\""
        }
        close $conf
    }
}

proc rust::append_envs { var {phases {configure build destroot}} } {
    foreach phase ${phases} {
        ${phase}.env-delete ${var}
        ${phase}.env-append ${var}
    }
}

# Is build caching enabled ?
# WIP for now ...
#if {[tbool configure.ccache]} {
#    # Enable sccache for rust caching
#    depends_build-append port:sccache
#    rust::append_envs    RUSTC_WRAPPER=${prefix}/bin/sccache
#    rust::append_envs    SCCACHE_CACHE_SIZE=2G
#    rust::append_envs    SCCACHE_DIR=${workpath}/.sccache
#}

proc rust::set_environment {} {
    global prefix configure.pkg_config_path
    global subport configure.build_arch configure.universal_archs

    rust::append_envs     "RUST_BACKTRACE=1"

    rust::append_envs     CC=[compwrap::wrap_compiler cc]   {build destroot}
    rust::append_envs     CXX=[compwrap::wrap_compiler cxx] {build destroot}

    if { [option openssl.branch] ne "" } {
        set openssl_ver                     [string map {. {}} [option openssl.branch]]
        rust::append_envs                   OPENSSL_DIR=${prefix}/libexec/openssl${openssl_ver}
        compiler.cpath-prepend              ${prefix}/libexec/openssl${openssl_ver}/include
        compiler.library_path-prepend       ${prefix}/libexec/openssl${openssl_ver}/lib
        configure.pkg_config_path-prepend   ${prefix}/libexec/openssl${openssl_ver}/lib/pkgconfig
    }

    # Propagate pkgconfig path to build and destroot phases as well.
    # Needed to work with openssl PG.
    if { ${configure.pkg_config_path} ne "" } {
        rust::append_envs "PKG_CONFIG_PATH=[join ${configure.pkg_config_path} :]" {build destroot}
    }

    if {${subport} ne "rust" && [join [lrange [split ${subport} -] 0 1] -] ne "rust-bootstrap"} {

        # when CARGO_BUILD_TARGET is set or `--target` is used, RUSTFLAGS and RUSTC are ignored
        #     rust::append_envs     "RUSTFLAGS=-C linker=[compwrap::wrap_compiler ld]"
        #     rust::append_envs     "RUSTC=${prefix}/bin/rustc"
        # see https://github.com/rust-lang/cargo/issues/4423

        foreach stage {configure build destroot} {
            foreach arch [option muniversal.architectures] {
                ${stage}.env.${arch}-append "CARGO_BUILD_TARGET=[option triplet.${arch}]"
            }
        }
    }
}
port::register_callback rust::set_environment

proc rust::rust_pg_callback {} {
    global  subport \
            prefix

    if { ${subport} ne "rust" && [join [lrange [split ${subport} -] 0 1] -] ne "rust-bootstrap" } {
        # port is *not* building Rust

        foreach {f s} [option rust.remap] {
            rust.flags-prepend          --remap-path-prefix=${f}=${s}
        }

        depends_build-delete            port:rust
        depends_build-append            port:rust

        if { ${subport} ne "cargo" } {
            # port is building neither Rust nor Cargo
            depends_build-delete        port:cargo
            depends_build-append        port:cargo
            depends_skip_archcheck-delete   cargo
            depends_skip_archcheck-append   cargo
        }
    } else {
        # port is building Rust

        if { [option rust.llvm.legacy] } {
            depends_build-delete        path:lib/libMacportsLegacySupport.a:legacy-support
            depends_build-append        path:lib/libMacportsLegacySupport.a:legacy-support
        }

        if { [option rust.use_cctools] } {
            depends_build-delete        port:cctools
            depends_build-append        port:cctools
            depends_skip_archcheck-delete   cctools
            depends_skip_archcheck-append   cctools
        }
    }

    if { [option openssl.branch] ne "" } {
        set openssl_ver                 [string map {. {}} [option openssl.branch]]
        depends_lib-delete              port:openssl${openssl_ver}
        depends_lib-append              port:openssl${openssl_ver}
    }

    if { [string match "macports-clang*" [option configure.compiler]] && [option os.major] < 11 } {
        # by default, ld64 uses ld64-127 when 9 <= ${os.major} < 11
        # Rust fails to build when architecture is x86_64 and ld64 uses ld64-127
        depends_build-delete            port:ld64-274
        depends_build-append            port:ld64-274
        depends_skip_archcheck-delete   ld64-274
        depends_skip_archcheck-append   ld64-274
        configure.ldflags-delete        -fuse-ld=${prefix}/bin/ld-274
        configure.ldflags-append        -fuse-ld=${prefix}/bin/ld-274
    }

    # rust-bootstrap requires `macosx_deployment_target` instead of `os.major`
    if { [option os.platform] eq "darwin" && [vercmp [option macosx_deployment_target] < 10.6]} {
        # __Unwind_RaiseException
        depends_lib-delete              port:libunwind
        depends_lib-append              port:libunwind
        configure.ldflags-delete        -lunwind
        configure.ldflags-append        -lunwind

        if { [join [lrange [split ${subport} -] 0 1] -] eq "rust-bootstrap" } {
            # Bootstrap compilers are building on newer machines to be run on older ones.
            # Use libMacportsLegacySystem.B.dylib since it is able to use the `__asm("$ld$add$os10.5$...")` trick for symbols that are part of legacy-support *only* on older systems.
            set legacyLib               libMacportsLegacySystem.B.dylib
            set dep_type                lib

            # code should mimic legacy-support
            # see https://github.com/macports/macports-ports/blob/master/devel/legacy-support/Portfile
            set max_darwin_reexport 19
            if { [option configure.build_arch] eq "arm64" || [option os.major] > ${max_darwin_reexport} } {
                # ${prefix}/lib/libMacportsLegacySystem.B.dylib does not exist
                # see https://trac.macports.org/ticket/65255
                known_fail              yes
                pre-fetch {
                    ui_error "${subport} requires libMacportsLegacySystem.B.dylib, which is provided by legacy-support"
                    return -code error "incompatible system configuration"
                }
            }
        } else {
            # Use the static library since the Rust compiler looks up certain symbols at *runtime* (e.g. `openat`).
            # Normally, we would want the additional functionality provided by MacPorts.
            # However, for reasons yet unknown, the Rust file system (sys/unix/fs.rs) functions fail when they try to use MacPorts system calls.
            set legacyLib               libMacportsLegacySupport.a
            set dep_type                build
        }

        # LLVM: CFPropertyListCreateWithStream, uuid_string_t
        # Rust: _posix_memalign, extended _realpath, _pthread_setname_np, _copyfile_state_get
        depends_${dep_type}-delete      path:lib/${legacyLib}:legacy-support
        depends_${dep_type}-append      path:lib/${legacyLib}:legacy-support
        configure.ldflags-delete        -Wl,${prefix}/lib/${legacyLib}
        configure.ldflags-append        -Wl,${prefix}/lib/${legacyLib}
    }

    # sometimes Cargo.lock does not exist
    post-extract {
        if { ${cargo.update} } {
            system -W ${cargo.dir} "${cargo.bin} --offline update"
        }
    }
}
port::register_callback rust::rust_pg_callback
