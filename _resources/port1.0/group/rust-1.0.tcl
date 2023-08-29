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

# use `--remap-path-prefix` to prevent build information from bing included installed binaries
options     rust.remap
default     rust.remap          {${cargo.home} "" ${worksrcpath} ""}

# flags to be passed to the rust compiler
# --remap-path-prefix=... is eventually added unless rust.remap is empty
options     rust.flags
default     rust.flags          {}

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

    set version_current         1.70.0
    set version_m1              1.69.0
    set version_m2              1.68.2

    master_sites-append         https://static.rust-lang.org/dist:apple_vendor \
                                https://github.com/MarcusCalhoun-Lopez/rust/releases/download/${version_current}:macports_vendor \
                                file://[option prefix]/libexec/rust-bootstrap:transition_vendor

    if { [join [lrange [split ${subport} -] 0 1] -] eq "rust-bootstrap" } {
        set is_bootstrap        yes
    } else {
        set is_bootstrap        no
    }

    set rustc_version           ${version_m1}; # ensure value is always set (see https://trac.macports.org/ticket/65183)
    foreach arch ${architectures} {
        # rust-bootstrap requires `macosx_deployment_target` instead of `os.major`
        if { ${arch} in [option rust.upstream_archs] && [vercmp [option macosx_deployment_target] >= [option rust.upstream_deployment_target]]} {
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
            if { ${os.major} >= 11 || [option os.platform] ne "darwin" } {
                set rustc_version   ${version_m1}+0
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
                # bootstrap binaries not currently available for Tiger
                # https://trac.macports.org/ticket/65184
                if {$build_major != 8} {
                    distfiles-append    ${component}-${binTag}${extract.suffix}:${build_vendor}_vendor
                }
                # mirroring workaround for Snow Leopard i386 files
                if {[variant_exists mirror_i386] && [variant_isset mirror_i386]} {
                    set extrabintag     ${version_m1}+0-[option triplet.cpu.i386]-macports-[option triplet.os]10
                    distfiles-append    ${component}-${extrabintag}${extract.suffix}:macports_vendor
                }
            }
        } else {
            depends_extract-delete          port:rust-bootstrap-transition
            depends_extract-append          port:rust-bootstrap-transition
            depends_build-delete            port:rust-bootstrap-transition
            depends_build-append            port:rust-bootstrap-transition
            depends_skip_archcheck-delete   rust-bootstrap-transition
            depends_skip_archcheck-append   rust-bootstrap-transition

            if {[option muniversal.is_cross.[option configure.build_arch]]} {
                # if os.arch is arm and subport is rust-bootstrap-10.6, avoid
                #     Error: Cannot install rust-bootstrap-10.6 for the arch 'x86_64' because
                #     Error: its dependency rust-bootstrap-transition does not build for the required arch by default
                #     Error: and does not have a universal variant.
                known_fail                  yes
                pre-fetch {
                    ui_error "${subport} does not support cross-compilation"
                    return -code error "incompatible OS configuration"
                }
            }

            foreach component ${components} {
                set binTag          ${rustc_version}+0-[option triplet.cpu.${arch}]-${build_vendor}-[option triplet.os]${build_major}
                set distfile        [option prefix]/libexec/rust-bootstrap/${component}-${binTag}${extract.suffix}
                post-extract        "system -W \${workpath} \"\${extract.cmd} \${extract.pre_args} ${distfile} \${extract.post_args}\""
            }
        }
    }

    # upstream binaries
    checksums-append        rust-std-${version_m1}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  53e46f3e7e148cc4860f5e752f3e2590ad3abf9c \
                            sha256  e44d71250dc5a238da0dc4784dad59d562862653adecd31ea52e0920b85c6a7c \
                            size    44783473 \
                            rustc-${version_m1}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  956a17845cf43a68091011eb722c923d7f823e28 \
                            sha256  7b337037b7b7b2ec71cd369009cd94a32019466cdae56b6d6a8cfb74481a3de5 \
                            size    88715010 \
                            cargo-${version_m1}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  d6bc4e1e3fd2a4f279ee9a61bbcb20c71123ee16 \
                            sha256  3ed0b5eaaf7e908f196b4882aad757cb2a623ca3c8e8e74471422df5e93ebfb0 \
                            size    7379771 \
                            rust-std-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  200e0aaf3eab63c0b0fb4dfd8d6cbcec7688cd39 \
                            sha256  00307d648acc269a0874ba8de4f8eb3bd3b85a0f10e3da59ba1ff8c840e92b34 \
                            size    42521697 \
                            rustc-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  0ab0a1e48871bf7f919cde6a76026a6cd3207f9d \
                            sha256  aaecbc9591591b42f02befedb5c4a04c8faeecfacbaffb5c9ee4ad1f77b0a3ed \
                            size    94232290 \
                            cargo-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  7bbdbae8e74ed5b774c12837cee6e8446dfefdb4 \
                            sha256  b185ea41a0ad76ac23b08744732c51e4811528291f7193d612a42e3e54ecd535 \
                            size    6824595

    # upstream binaries
    checksums-append        rust-std-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  a8d6ead293d62ec3399fec6d540063dfc0e88db6 \
                            sha256  5d6a7d62ae67c2f7aae6eabb782a3125cf9fed6bbc2993d59b3714f4f832e797 \
                            size    46527398 \
                            rustc-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  4d70c6082b786c92e145094521cdd1e16872bf25 \
                            sha256  e0ba4545a390303a1447417ec19be2ad26ae33ee1b9a7b2e3e970e8a87e30ba7 \
                            size    90053307 \
                            cargo-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  723b9f1a8689b629a07abba0f62ca508a80aee99 \
                            sha256  c580e7dbf6bde9bf4246380ac1591682981dc7cbdb7b82a95eac8322d866e4bd \
                            size    7295998 \
                            rust-std-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  b5baa0eb8670b09ec5a48b2fc434dff4d09e3930 \
                            sha256  db2be7e5d766799796a71e43f141a5082ac30240e276c8c9b56800ab4638af92 \
                            size    44021003 \
                            rustc-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  1bb88dc08de7baec1772dd96222fc01ec4d23bea \
                            sha256  9cbec5ea622b445e620743cabc723534fa6e4871a53cb4743e6b28ce8e3d5112 \
                            size    95837590 \
                            cargo-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  d7eb4c3bc4bd9d1a6f154335dc4c5aba7305eb32 \
                            sha256  7317f1a2823a78f531f433d55cf76baf8701d16268bded12e0501fc07e74c6f4 \
                            size    6784373

    # MacPorts bootstrap binaries for older system
    checksums-append        rust-std-${version_m1}+0-x86_64-macports-darwin${extract.suffix} \
                            rmd160  dc5bfb7c1e7550cb31c97742806f09307de3c331 \
                            sha256  f59dbd7f6c2c2e54fbcf111371020da765a74da7762abaef3258db3ee07c5324 \
                            size    38534700 \
                            rustc-${version_m1}+0-x86_64-macports-darwin${extract.suffix} \
                            rmd160  7079b99ef6bea0e068299ca9307b2e8e8ae4cfc7 \
                            sha256  7543e6fdc6759722997cf2b20559efbca54beb6fe3de141110beae910164049a \
                            size    48434088 \
                            cargo-${version_m1}+0-x86_64-macports-darwin${extract.suffix} \
                            rmd160  ec0954f6380c29eb1ac8c45a7ee2798f17db7a87 \
                            sha256  aa9da6ca6c89be2b757d994c399906ac6db1dc25bca593fba6bcb9d3abe110d7 \
                            size    6806746 \
                            rust-std-${version_m1}+0-i686-macports-darwin${extract.suffix} \
                            rmd160  d7fb3a23b9b881a63df0e85a2bf9793029d1c74a \
                            sha256  c56a2f77b99a4dbfb124498b58858832fa9ecda45eb31f123444f5a876747a4d \
                            size    38085361 \
                            rustc-${version_m1}+0-i686-macports-darwin${extract.suffix} \
                            rmd160  5986ac908544228dd422da0b6b8c971686047878 \
                            sha256  1b7e2da41a3269fb659f214d36292d23f4a742914b9653d44f40aa5d59117149 \
                            size    61967635 \
                            cargo-${version_m1}+0-i686-macports-darwin${extract.suffix} \
                            rmd160  88d234d9d2bf1c1afe6eda53606246ea6a76ec00 \
                            sha256  e3d4a516bd8195e2d9d9a8a65bd96492709243bb2304d29f69dbd5b56cf0412e \
                            size    6801776 \
                            rust-std-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  9137d22131b6b4248688fdcaadfa3c0b48ca6dcc \
                            sha256  d4f5fcc1cc93e20d1fb59e3200d5b3f626523175379d26ebb150569098c1eff9 \
                            size    38568479 \
                            rustc-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  aeb41523914e1d78d5e855af819d312a42757f0b \
                            sha256  f9e6921831863937e627b2ced879a4da83268ec90385836c27130baaf26b46dc \
                            size    48591709 \
                            cargo-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  18b71c25b2c8ddcc9b1ab842a0792228b475290e \
                            sha256  056a10a8295a74cf72053dd3d162ef7dc6b889c7bab11591ac0e15e8f17795da \
                            size    6830401 \
                            rust-std-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  01e1e0de9e2358351c5daa8b84a3adfc748a78cd \
                            sha256  87f28750ab713d442f7141d3befab801d6c4d6df5d3e0159b52c4510d6cf9f2e \
                            size    38092729 \
                            rustc-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  49bb4c8ff63d25018b49346d2a1a5230ec327100 \
                            sha256  22e5bea0a45a9675bdc0a28b98c3fb3d0edfbf610f0862addad84c203185d132 \
                            size    62154136 \
                            cargo-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  d00d606c67550540db87522ee0bd5f4eda2a5b37 \
                            sha256  1d84a5d97fd626798ff2ef11b4ad2d111a97868a333e0dcd2e20d0e70e5d3824 \
                            size    6816237 \
                            rust-std-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  c15b519f52a1e901e030ebc46115fcd2ffbd9910 \
                            sha256  f97ebe5a998626fcbd14868196c08b5802247798fec6620dd4079bd250e5ef5f \
                            size    38391067 \
                            rustc-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  a12c1cfe38e1aac9b75d264d3ed3284ee1d1e8f0 \
                            sha256  2e7bf803c94ad33425d95ceb6e5cbd79c312b329cf351a00770ba51fb6033563 \
                            size    48299428 \
                            cargo-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  60517ccd8067c9999b762f4c1590ae33d6923395 \
                            sha256  68241264638b5fdc482d61b140b42b4e64c88949ca3289e28738f46f2a2444d3 \
                            size    6723825 \
                            rust-std-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  6bbd9289e96cecce5ca82987a157e6ecdf79dac7 \
                            sha256  14f754fca70e1bbe8755f55b257ef73559fa305722698bbdebe9729ddd37f47e \
                            size    37942326 \
                            rustc-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  c064ac084dd0156780075efaad5686b39620c265 \
                            sha256  8a94f9b30ac00581cbc5e84452e6bd8a96e1ae906359c4b97416ad86d1210db8 \
                            size    61961592 \
                            cargo-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  1e9a22befec111758527e71eea4b2e2db4e9a1e1 \
                            sha256  ca3fb4b44f870121cfff636965b222a641c21fd722003d76ad6288b983a11421 \
                            size    6720624

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
        # muniversal.build_arch is empty if we are not doing a universal build
        if {${arch} eq ""} {
            set arch [option configure.build_arch]
            if {${arch} eq ""} {
                error "No build arch configured"
            }
        }
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
            system -W ${worksrcpath} "${cargo.bin} --offline update"
        }
    }
}
port::register_callback rust::rust_pg_callback
