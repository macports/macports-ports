# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup supports the Rust language ecosystem
#
# Usage:
#
# PortGroup     rust 1.0
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

options     cargo.bin \
            cargo.home \
            cargo.crates \
            cargo.offline_cmd \
            cargo.crates_github \
            cargo.update

default     cargo.bin           {${prefix}/bin/cargo}
default     cargo.home          {${workpath}/.home/.cargo}
default     cargo.crates        {}
default     cargo.crates_github {}

# if a dependency has been patched, `--offline` might be a reasonable choice
default     cargo.offline_cmd   {--frozen}

# some packags do not provide Cargo.lock,
# so offer the option of running cargo-update
default     cargo.update        {no}

options     rust.upstream_deployment_target \
            rust.upstream_archs \
            rust.use_cctools \
            rust.archiver \
            rust.ranlib

# default macosx_deployment_target value of Rust function macos_default_deployment_target
# see https://github.com/rust-lang/rust/blob/master/compiler/rustc_target/src/spec/apple_base.rs
default     rust.upstream_deployment_target {[expr {${os.arch} eq "arm" ? 11.0 : 10.7}]}

# architectures for which an upstream bootstrap compiler is available
default     rust.upstream_archs     {[expr {${os.platform} eq "darwin" && ${os.major} >= 13 ? {arm64 x86_64} : {}}]}

# some tools provided by system are too old, so use MacPorts version instead
default     rust.use_cctools        {[expr {${os.platform} eq "darwin" && ${os.major} < 11 ? "yes" : "no"}]}
default     rust.archiver           {[expr {${rust.use_cctools} ? "${prefix}/bin/ar" : "/usr/bin/ar"}]}
default     rust.ranlib             {[expr {${rust.use_cctools} ? "${prefix}/bin/ranlib" : "/usr/bin/ranlib"}]}

# compiler runtime library
#     N.B.: `configure.ldflags-append {*}${rust.rt_static_libs}` might be insufficient
#     `rust.rt_static_libs` will not give the correct value until *after* the compiler is active
#     the compiler might not be active immediately if added as a dependency
options     rust.rt_static_libs
default     rust.rt_static_libs     {[rust::get_static_rutime_libraries]}

# force compiler runtime library to be included in link flags
options     rust.add_compiler_runtime
default     rust.add_compiler_runtime   {no}

# the distfiles of the main port will also be stored in this directory,
# but this is the only way to allow reusing the same crates across multiple ports.
default     dist_subdir             {[expr {[llength ${cargo.crates}] > 0 || [llength ${cargo.crates_github}] > 0 ? "cargo-crates" : ${name}}]}
default     extract.only            {[rust::disttagclean $distfiles]}

# to wrap linker, compiler_wrapper PG required existence of configure.ld
options     configure.ld
default     configure.ld            {${configure.cc}}

# Rust set its own compiler flags, so make empty by default
default     configure.cflags        {}
default     configure.cxxflags      {}
default     configure.ldflags       {[expr {${rust.add_compiler_runtime} ? ${rust.rt_static_libs} : {}} ]}
default     compiler.limit_flags    {yes}
default     configure.pipe          {no}
rename      portconfigure::should_add_stdlib  portconfigure::should_add_stdlib_real
rename      portconfigure::should_add_cxx_abi portconfigure::should_add_cxx_abi_real
proc        portconfigure::should_add_stdlib  {} {return no}
proc        portconfigure::should_add_cxx_abi {} {return no}

# enforce same compiler settings as used by rust
default compiler.cxx_standard           2017
default compiler.thread_local_storage   yes

# do not include os.major in target triplet
default     triplet.os              {${os.platform}}

# Rust does not easily pass external flags to compilers, so add them to compiler wrappers
default     compwrap.compilers_to_wrap          {cc cxx ld}
default     compwrap.ccache_supported_compilers {}

# possible OpenSSL versions: empty, 3, 1.1, and 1.0
options     openssl.branch
default     openssl.branch      {}

# utility method to get bootstrap compilers
# should only be needed by Rust/Cargo ports
proc rust.add_bootstrap_components {architectures {components {rust-std rustc cargo}}} {
    global extract.suffix os.major subport

    set version_current         1.60.0
    set version_m1              1.59.0
    set version_m2              1.58.0

    master_sites-append         https://static.rust-lang.org/dist:apple_vendor \
                                https://github.com/MarcusCalhoun-Lopez/rust/releases/download/${version_current}:macports_vendor \
                                file://[option prefix]/libexec/rust-bootstrap:transition_vendor

    if { [join [lrange [split ${subport} -] 0 1] -] eq "rust-bootstrap" } {
        set is_bootstrap        yes
    } else {
        set is_bootstrap        no
    }

    foreach arch ${architectures} {
        # rust-bootstrap requires `macosx_deployment_target` instead of `os.major`
        if { ${arch} in [option rust.upstream_archs] && [vercmp [option macosx_deployment_target] [option rust.upstream_deployment_target]] >= 0 } {
            set build_vendor        apple
            if { ${is_bootstrap} } {
                set rustc_version   ${version_m2}
            } else {
                set rustc_version   ${version_m1}
            }
            set build_major         ""
        } elseif { ${arch} in [option rust.upstream_archs] && ${is_bootstrap} && ${subport} ne "rust-bootstrap-transition" } {
            set build_vendor        transition
            set build_major         ""
            set rustc_version       ${version_m1}
        } else {
            set build_vendor        macports
            if { ${os.major} >= 11 } {
                set rustc_version   ${version_m1}+1
                set build_major     ""
            } elseif { ${os.major} >= 10 } {
                set rustc_version   ${version_m1}+0
                set build_major     10
            } elseif { ${os.major} >= 9 } {
                set rustc_version   ${version_m1}+0
                set build_major     9
            } elseif { ${os.major} >= 8 } {
                set rustc_version   ${version_m1}+0
                set build_major     8
            }
        }

        if { ${build_vendor} ne "transition" } {
            foreach component ${components} {
                set binTag          ${rustc_version}-[option triplet.cpu.${arch}]-${build_vendor}-[option triplet.os]${build_major}
                distfiles-append    ${component}-${binTag}${extract.suffix}:${build_vendor}_vendor
            }
        } else {
            depends_extract-delete          port:rust-bootstrap-transition
            depends_extract-append          port:rust-bootstrap-transition
            depends_build-delete            port:rust-bootstrap-transition
            depends_build-append            port:rust-bootstrap-transition
            depends_skip_archcheck-delete   rust-bootstrap-transition
            depends_skip_archcheck-append   rust-bootstrap-transition

            foreach component ${components} {
                set binTag          ${rustc_version}+0-[option triplet.cpu.${arch}]-${build_vendor}-[option triplet.os]${build_major}
                set distfile        [option prefix]/libexec/rust-bootstrap/${component}-${binTag}${extract.suffix}
                post-extract        "system -W \${workpath} \"\${extract.cmd} \${extract.pre_args} ${distfile} \${extract.post_args}\""
            }
        }
    }

    # upstream binaries
    checksums-append        rust-std-${version_m1}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  420c6ae0086a68aa018c31f79b96eb2d1c556537 \
                            sha256  959af8bafbc9f3916a1d1111d7378fdd7aa459410cdd2d3bbfc2d9d9a6db0683 \
                            size    39328167 \
                            rustc-${version_m1}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  70eb8715fb4219be33d430e708883e5b035ad111 \
                            sha256  eb5b613800c75882bed9e3bb48c325aac0e5ce418ae2b19f51e4ccf7e4781e0b \
                            size    81261773 \
                            cargo-${version_m1}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  5c968f1dd476d0e7a340a23a03fa918aee17d3cb \
                            sha256  d0202b50b4f3d0e943a5d7e8d14420afeac8cf36e6136e8d5b7ddefb3538d62a \
                            size    6424124 \
                            rust-std-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  79767785ff058ea7173b234232f9f238b1a7c7b6 \
                            sha256  e70bd0c56f8f716238a1395c54dd9d993a3168e2764e404dc65553babf7aa127 \
                            size    38541530 \
                            rustc-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  18cb2608f941741b3dabe66a0668b6b3cf366994 \
                            sha256  caac78491d8f0844bb9a512989a409c35ff681a131495e7ebfacb69ba006bbc1 \
                            size    82983805 \
                            cargo-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  d2a4638a1509d051f0bce03ae043eccc4c612b0c \
                            sha256  4bdcb77ea084364b551a5cf969e263beb09afa39627f6dead262c8e2a7aed9c1 \
                            size    5750407

    # upstream binaries
    checksums-append        rust-std-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  10ddd3a98036998f0f3904223eadd77a8d61ed2b \
                            sha256  fa89e9ab2e3645d6732811dae3828c86fbd65cb7447ec33c84137e61b168396a \
                            size    38052490 \
                            rustc-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  37f05c82ab6e9297852eaef21f503c3781b852d3 \
                            sha256  3d3815385dda1c1d8617ee14b682ec3804307b0f5a0ac5604a7dc5efc783263f \
                            size    97525234 \
                            cargo-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  a549b5d7ce05fa2152ef81e8086320da11b7ecd3 \
                            sha256  60203fc7ec453f2a9eb93734c70a72f8ee88e349905edded04155c1646e283a6 \
                            size    6644822 \
                            rust-std-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  31a8636f80df5bef24b474814d8e53d8ddc2526a \
                            sha256  7c1d58bdc87b79f439b1083348a0e492305f8737ad1931755c26b2834a854f42 \
                            size    37218461 \
                            rustc-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  c73151a7c0d73b8500bb4cc1e8542fc32699b015 \
                            sha256  7b3291177d4f8a73c8e20185a04bbc88775fc85eeb271c19bc8f37fb5051ae0c \
                            size    98543672 \
                            cargo-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  b810fe314b99b9836fc05f333139d4e3c92012e8 \
                            sha256  9144ee0f614c8dcb5f34a774e47a24b676860fa442afda2a3c7f45abfe694e6a \
                            size    5906007

    # MacPorts bootstrap binaries for older system
    checksums-append        rust-std-${version_m1}+1-x86_64-macports-darwin${extract.suffix} \
                            rmd160  1012253985d0874f03b73e68bd5ed3f670d19b48 \
                            sha256  9523e1b8f41716c332fee71b21d6246a38d04601676496a4b90d150db2e80262 \
                            size    34743749 \
                            rustc-${version_m1}+1-x86_64-macports-darwin${extract.suffix} \
                            rmd160  316bdd5ac3e90d3579bb63476dbcf38b65127887 \
                            sha256  2725f410501db48d8a3800b434107272ce472495addfb4e10333268dd3a142f5 \
                            size    45349135 \
                            cargo-${version_m1}+1-x86_64-macports-darwin${extract.suffix} \
                            rmd160  a1deb9bcf4ad5350f2e95619cf56ae64c88b7a90 \
                            sha256  605e349444051ecdec591de5803b670c324cad9d461354594f5f2f787aa79333 \
                            size    5776737 \
                            rust-std-${version_m1}+1-i686-macports-darwin${extract.suffix} \
                            rmd160  acf846e7c8bc55c66d8705cb802fcdc13b02ae04 \
                            sha256  e86642ddc28319928d2e4daa6f27d70328db366134e25de347f9201e648cab7b \
                            size    34337717 \
                            rustc-${version_m1}+1-i686-macports-darwin${extract.suffix} \
                            rmd160  8efe84f913f9596a27b7a8cb119221dec9fcf4a5 \
                            sha256  20b9cca01e08f1a630b40726b142fce3d7bd67cdeac461a58ad0b5d8bbaad1e6 \
                            size    54928831 \
                            cargo-${version_m1}+1-i686-macports-darwin${extract.suffix} \
                            rmd160  470e8b657e9e734a2d143aece0cd6f685d933d74 \
                            sha256  cf590d37c38c85a18996b982a4301f86f5ea3116bad8f3aa839a5403e1d9ab76 \
                            size    5796220 \
                            rust-std-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  7dcbeed06544fafe639bcd208a22d704291f81c5 \
                            sha256  9ed0cd8b5cf1eada0e913ffba2fd57acfdfd0c5c12c0e77e9a8c2d65a4aa93e9 \
                            size    34709722 \
                            rustc-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  eb2c2081f79be0ae9566fe457daae6adbbd5e0b3 \
                            sha256  70cce383b8fec14d50395d6a5bc714de813b4b01c2c0aa6ca525f0c1ab790585 \
                            size    45465969 \
                            cargo-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  193b5ed2f97a478f5d6af2a90ba7f9f13c280a40 \
                            sha256  7d48f508599f405f925aeeceb54e90d0bb166351351f349e976191e40fff818f \
                            size    5549899 \
                            rust-std-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  742e22502c8c5f5ee480cd9df636586c73d7ac91 \
                            sha256  2215dcf144dd7fa90e87a5963afc58b48f790c459d1b3aaa906d87692f1c8fb6 \
                            size    34322500 \
                            rustc-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  8dc85c259e17222080638b1f0f5ab768fd011015 \
                            sha256  fc9222ca4bdc082e011b9685e063ab76df5597a48bedad88a1463d4596a09504 \
                            size    54993727 \
                            cargo-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  953ddf0e3c79edd88782c423139b0952a4551486 \
                            sha256  d8f2b0e51a56ceb6d490292cd2951924885e25559799c58bb85afdaa9c3ad4ad \
                            size    5558460 \
                            rust-std-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  d70ca575c3033babbf4168d19d17b5411e0b3a72 \
                            sha256  0b7faccc7562eb4e2ebdaa6dbe1b1f0fa96b281c150369362c0fa476c9f6aadb \
                            size    34587374 \
                            rustc-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  5308763cd24a7d49e920a380c283f827e86664c8 \
                            sha256  cb31791e2f639113446b1f577680fd26e8f73d5b5446d2b5c3734c8e1698710a \
                            size    45234053 \
                            cargo-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  bbdece9ce995adffe5615edf1d3dbddec3ef89af \
                            sha256  d2bd1ce9e1919ca21545e9f09006bb162123cac5c7071ac7bf0d6084b5f3438a \
                            size    5458503 \
                            rust-std-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  577db5cbef820ff7d7f5ec7dd14164b2642507df \
                            sha256  75b2e9c4beeeae1ada349580ebae4adfae3c3fc52cdc0d9685d9f6971a86a7f1 \
                            size    34173832 \
                            rustc-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  74889eae609934d298fcd6a6f79f6c2669c549d1 \
                            sha256  1d44388c9a5c9179b59e3224a8d1c8eda8f260a160cdc854708db23610fa2299 \
                            size    53624390 \
                            cargo-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  69c5d85e6477d09cd0127173cac1d7f39a3db4a4 \
                            sha256  a3734f4a33425a65c4d30f7f0fab1cc7e6d551458d6c7dc79e6e79b6f2a2f505 \
                            size    5473873

    return                  [lindex [split ${rustc_version} +] 0]
}

####################################################################################################################################
# for building LLVM as part of building the Rust compiler
####################################################################################################################################

options     rust.llvm.legacy
default     rust.llvm.legacy        {[expr {${os.major} < 11}]}

options     rust.llvm.cflags
default     rust.llvm.cflags        {[portconfigure::configure_get_cppflags] ${configure.optflags} [expr {${rust.llvm.legacy} ? "-isystem${prefix}/include/LegacySupport" : ""}]}

options     rust.llvm.cxxflags
default     rust.llvm.cxxflags      {[portconfigure::configure_get_cppflags] ${configure.optflags} [expr {${rust.llvm.legacy} ? "-isystem${prefix}/include/LegacySupport" : ""}]}

options     rust.llvm.ldflags
default     rust.llvm.ldflags       {[portconfigure::configure_get_ldflags] [expr {${rust.llvm.legacy} ? "${prefix}/lib/libMacportsLegacySupport.a" : ""}]}

####################################################################################################################################
# utility procedures
####################################################################################################################################

# MacPorts architecture name --> Rust architecture name
proc rust.rust_arch {arch} {
    switch ${arch} {
        arm64       {return aarch64}
        i386        {return i686}
        ppc         {return powerpc}
        ppc64       {return powerpc64}
        default     {return ${arch}}
    }
}

# Rust architecture name --> MacPorts architecture name
proc rust.marcports_arch {rarch} {
    switch ${rarch} {
        aarch64     {return arm64}
        i686        {return i386}
        powerpc     {return ppc}
        powerpc64   {return ppc64}
        default     {return ${rarch}}
    }
}

####################################################################################################################################
# compatibility procedures
####################################################################################################################################
proc cargo.rust_platform {{arch ""}} {
    if {${arch} eq ""} {
        set arch [option muniversal.build_arch]
    }
    return [option triplet.${arch}]
}

####################################################################################################################################
# internal procedures
####################################################################################################################################

namespace eval rust {}

# for symbol ___emutls_get_address (used when thread-local-storage is emulated)
#
# for Clang, provides symbol ___muloti4
# since https://github.com/rust-lang/rust/commit/8a6ff90a3a41e6ace18aeb089ea0a0eb3726dd08
#
proc rust::get_static_rutime_libraries {} {
    set libs [list ]

    if {[string match *clang* [option configure.compiler]]} {
        set libName lib/[option os.platform]/libclang_rt.osx.a
    } else {
        set libName libgcc_eh.a
    }

    if {![catch [list exec [option configure.cc] --print-search-dirs] results]} {
        foreach ln [split ${results} \n] {
            set splt [split ${ln} =]
            if {[lindex ${splt} 0] eq "libraries: "} {
                foreach dir [split [lindex ${splt} 1] :] {
                    set fl [string trimright ${dir} "/"]/${libName}
                    if {[file exists ${fl}]} {
                        lappend libs ${fl}
                    }
                }
            }
        }
    }

    return ${libs}
}

proc rust::configure_ldflags_proc {option action args} {
    if {$action ne "read"} return
    if {[option rust.add_compiler_runtime]} {
        configure.ldflags-delete    {*}[option rust.rt_static_libs]
        configure.ldflags-append    {*}[option rust.rt_static_libs]
    }
}
option_proc configure.ldflags rust::configure_ldflags_proc

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
            if { "i386" in [option muniversal.architectures] } {
                # see https://gitlab.com/worr/rust-kqueue/-/merge_requests/10
                reinplace {s|all(target_os = "freebsd", target_arch = "x86")|all(any(target_os = "freebsd", target_os = "macos"), any(target_arch = "x86", target_arch = "powerpc"))|g} \
                    ${cargo.home}/macports/${cname}-${cversion}/src/time.rs
                cargo.offline_cmd-replace --frozen --offline
            }
        }
    }

    # rust-bootstrap requires `macosx_deployment_target` instead of `os.major`
    if {[option os.platform] ne "darwin" || [vercmp [option macosx_deployment_target] 10.8] >= 0} {
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

    if {[option os.platform] ne "darwin" || [vercmp [option macosx_deployment_target] 10.6] >= 0} {
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
    rust::old_macos_compatibility ${cname} ${cversion}
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

    # Propagate pkgconfig path to build and destroot phases as well.
    # Needed to work with openssl PG.
    if { ${configure.pkg_config_path} ne "" } {
        rust::append_envs "PKG_CONFIG_PATH=[join ${configure.pkg_config_path} :]" {build destroot}
    }

    rust::append_envs     CC=[compwrap::wrap_compiler cc]   {build destroot}
    rust::append_envs     CXX=[compwrap::wrap_compiler cxx] {build destroot}

    if { [option openssl.branch] ne "" } {
        set openssl_ver                 [string map {. {}} [option openssl.branch]]
        rust::append_envs               OPENSSL_DIR=${prefix}/libexec/openssl${openssl_ver}
        compiler.cpath-prepend          ${prefix}/libexec/openssl${openssl_ver}/include
        compiler.library_path-prepend   ${prefix}/libexec/openssl${openssl_ver}/lib
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

    if { [string match "macports-clang*" [option configure.compiler]] && [option os.major] == 10 } {
        # by default, ld64 uses ld64-127 when 9 <= ${os.major} < 11
        # Rust fails to build when ${os.major} >= 10 and ld64 uses ld64-127
        # ld64-274 does not seem to build when ${os.major} < 10
        depends_build-delete            port:ld64-274
        depends_build-append            port:ld64-274
        depends_skip_archcheck-delete   ld64-274
        depends_skip_archcheck-append   ld64-274
        configure.ldflags-delete        -fuse-ld=${prefix}/bin/ld-274
        configure.ldflags-append        -fuse-ld=${prefix}/bin/ld-274
    }

    # rust-bootstrap requires `macosx_deployment_target` instead of `os.major`
    if { [option os.platform] eq "darwin" && [vercmp [option macosx_deployment_target] 10.6] < 0 } {
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
        configure.ldflags-delete        ${prefix}/lib/${legacyLib}
        configure.ldflags-append        ${prefix}/lib/${legacyLib}
    }

    # sometimes Cargo.lock does not exist
    post-extract {
        if { ${cargo.update} } {
            system -W ${worksrcpath} "${cargo.bin} --offline update"
        }
    }
}
port::register_callback rust::rust_pg_callback
