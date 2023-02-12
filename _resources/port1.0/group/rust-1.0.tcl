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

    set version_current         1.67.1
    set version_m1              1.66.1
    set version_m2              1.65.0

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
                            rmd160  16d571c35380554e4df9aa1504f014b8cacf1ca0 \
                            sha256  dff38a6930052a5bbcb189e879376ca75fe3ea229fe241fa636f362b2ce56298 \
                            size    46191425 \
                            rustc-${version_m1}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  25d065a3fac569372edf6b01be858d905dd1316d \
                            sha256  1cc7b8373ec086816ed53ea0e467fbbb1b38cb39dde50a695f8ff103992dd59f \
                            size    88306962 \
                            cargo-${version_m1}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  7fed6aab7419c882b2a75deb415b823d17eee2f7 \
                            sha256  125d0ec5b5a159f4f3757b4ae9eaa338afb7d38b4e290794b8157ed6ca8ac16f \
                            size    7144889 \
                            rust-std-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  7a4570941ac8f43a3b25d24d05c3e6bbb94db382 \
                            sha256  cc327dfbceac467ac7afef199ac218820b50dc62031370eea25e49ff5c290f63 \
                            size    43866429 \
                            rustc-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  04da8890e5419393443165f4eb9f60ca44a83326 \
                            sha256  ee3f7ab14cd8842abd31f21c575ef779afd2b32f584390b47886f30002cad646 \
                            size    88455996 \
                            cargo-${version_m1}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  cc7198ddf5469aeb99fe24e9e8e3fb38531779df \
                            sha256  01e83be8ce32e3af5155efde7f3e14b0864c1a73b2e73f03401bd14b67018ad7 \
                            size    6660173

    # upstream binaries
    checksums-append        rust-std-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  e7f034c7b84e03a0d094bbebc697eb83a4e3ae59 \
                            sha256  6b832ef5e94dc9d21c00b5c3cdbf5e4f4223a6215d6fa025ba064b7a24a4963a \
                            size    45706086 \
                            rustc-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  54152387cafdf10d2131aa4d9517ecf7784d5c6f \
                            sha256  be525d2eb2a55f7f5a9f5b3cffe5c1d7b511b4adf9cf5d5855b861138152f1fa \
                            size    86823029 \
                            cargo-${version_m2}-x86_64-apple-darwin${extract.suffix} \
                            rmd160  de37e51c5133b9789ca20b7b691137427ed1bf2d \
                            sha256  40cbbd62013130d5208435dc45d6c91703eb6a469b6d8eacf746eedc6974ccc0 \
                            size    7053486 \
                            rust-std-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  57c077850c93777ca64f96eb09673a340477e236 \
                            sha256  68316299635d2577af3b64a2de4839a107f6c33f92e9427d6127526d12ecf07f \
                            size    44490798 \
                            rustc-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  5d800161927dfaf5c8ac16f118e17abaab50ca4b \
                            sha256  bbcf34977e41b9f966746a559aa2af6fa7efd7f695338851b37f722f7a1104fb \
                            size    87892283 \
                            cargo-${version_m2}-aarch64-apple-darwin${extract.suffix} \
                            rmd160  57cb126c3804b6d0f95431fe58942e31db5a3f78 \
                            sha256  40858f3078b277165c191b6478c2aba7bf0010162273e28e9964404993eba188 \
                            size    6572061

    # MacPorts bootstrap binaries for older system
    checksums-append        rust-std-${version_m1}+0-x86_64-macports-darwin${extract.suffix} \
                            rmd160  2eee74d873d002faabd79544cf4045cdc71b4b3b \
                            sha256  9dd4db73d33f89c6482d51c465edb958d9994aec7fb8e6c873893f520f355e65 \
                            size    39884239 \
                            rustc-${version_m1}+0-x86_64-macports-darwin${extract.suffix} \
                            rmd160  e9982f9d88e90d20b7167991972aec69efb524e0 \
                            sha256  30012af5bae571e2c09c0165953b76c160f9ccdda5860ad5fe5cfaeb8741d34b \
                            size    48538571 \
                            cargo-${version_m1}+0-x86_64-macports-darwin${extract.suffix} \
                            rmd160  5da2b07af4d28660c933b90827f96672d4b712e0 \
                            sha256  9577e7285e47b5eb93af8afb86a80a9a1b18c5ae01b755587962b7b78617a89f \
                            size    6571170 \
                            rust-std-${version_m1}+0-i686-macports-darwin${extract.suffix} \
                            rmd160  cac09102b924c4efb387e33eb6c65dd8fe013297 \
                            sha256  4ad50a7995f340c74dbeb8e5def716e94782443c6e4e02149ab7be550e3fa2f6 \
                            size    39403697 \
                            rustc-${version_m1}+0-i686-macports-darwin${extract.suffix} \
                            rmd160  69fb7d9e9bbb3be7db444c23bae4b6903dbced34 \
                            sha256  21033dd9f96a7cd3a7baac1a9a08a742f9fdf071e64cfebbfa5ec19439d32b62 \
                            size    56277660 \
                            cargo-${version_m1}+0-i686-macports-darwin${extract.suffix} \
                            rmd160  788a46c09dea888765b9ee9205d987f31b924e2f \
                            sha256  7bd9645a3e4d235f5e4da850ab7fed1ad5eac365bd1f8785ff623f7504857179 \
                            size    6541454 \
                            rust-std-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  def122db3dbe77d1d2074d614345c832b3db65de \
                            sha256  2471c1ea754c83c7f54c67f216ca2848bcb259f134317e3dfe87010cd431f2ed \
                            size    39889666 \
                            rustc-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  702f9e0d093ba6c0563f87d2c3322789643b1607 \
                            sha256  e500a080f7fe99a6ddb6246d2a2bcb2bd5023ed6a4b0fc763c641a52a3db00a8 \
                            size    48629958 \
                            cargo-${version_m1}+0-x86_64-macports-darwin10${extract.suffix} \
                            rmd160  8ca337561d371885a29ecb4fa7f332e92b357a1b \
                            sha256  b55ca12a2f5c5d8a720b487c4093e7755ef9b1c97953d1e4406f96d31054e77f \
                            size    6573217 \
                            rust-std-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  c90e2020ff5abc664adea47c583be21d648af260 \
                            sha256  c747c974d76a667198b22d01d04f60b97caa27e6eeced77e19aa638c3cd0e2e5 \
                            size    39403600 \
                            rustc-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  8eeeb57eb3a09551402f22c93f21c5a86f8318a0 \
                            sha256  7c43022b8fce43d1d34a551ec79529e5620ef23344cd6fa26462a5e2f195eca4 \
                            size    56321861 \
                            cargo-${version_m1}+0-i686-macports-darwin10${extract.suffix} \
                            rmd160  6e030e550e4568967834fbef45afe1a9166637ac \
                            sha256  4c29a63dd4bdc9425e02cec39758da20af5ca5e16dc96efff074cee2a8abc1b0 \
                            size    6540689 \
                            rust-std-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  889562ac2546ca9c0cf46f8a9815b30f5f846f97 \
                            sha256  28544de0414560cc3db15bcba2a726b16b729a5034d144e96b2376c5f9af812c \
                            size    39766658 \
                            rustc-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  1a28964109b41bdf357109169ea86a98b5c028f6 \
                            sha256  4ceb5709f39ff33456f2284f8618b8c326e867cfee3c3b11a494c8da555e30c4 \
                            size    48376375 \
                            cargo-${version_m1}+0-x86_64-macports-darwin9${extract.suffix} \
                            rmd160  16b089ecc6a038c51a672c745c0534c98bd93316 \
                            sha256  1c941e727bd16593dbac8d43936f02d2d8a0a139d9a564789389bddef009ccf6 \
                            size    6488646 \
                            rust-std-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  e2d90169156d019210ba6c192f2fa26748b35087 \
                            sha256  8692543e421b06a2849fe0be0e3d5be841149bbbf9e5cce21323291ea4fba3a1 \
                            size    39289847 \
                            rustc-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  8bb9fdf103169499828d0bc282319c118332af71 \
                            sha256  2c70a24ea7f0c98a16256c185ed1d22680d6d341a9e92a57629b8bb4a24d4fcb \
                            size    56122112 \
                            cargo-${version_m1}+0-i686-macports-darwin9${extract.suffix} \
                            rmd160  96206a0c92e8c31a7cf7bad4609497b1beaad1d4 \
                            sha256  a2146faf4b491379f6b772847d8750936254dc367184f0e947c12f05f13fe66f \
                            size    6455911

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
