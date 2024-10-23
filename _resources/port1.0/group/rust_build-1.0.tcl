# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup supports the building of the Rust language ecosystem
#     (e.g., building rust, cargo, rust-bootstrap, and their various subports).
# Ports that simply use the Rust language will likely have no need of this PortGroup.
#
# Usage:
#
# PortGroup     rust_build 1.0
#

####################################################################################################################################
# options for building Rust compilers
####################################################################################################################################

# Rust version being built (version of cargo port is not the same)
options     rust_build.version
default     rust_build.version          {${version}}

# possible versions of Rust binaries that can be used as stage0 compilers
#     see https://github.com/rust-lang/rust/blob/${rust_build.version}/src/stage0.json
# please make sure the versions are in descending order
options     rust_build.stage0_versions

if {${os.platform} eq "darwin" && ${os.major} > 16} {
    # (CURRENT) macOS 10.13 and later
    default     rust_build.stage0_versions  {1.81.0 1.80.1}
} else {
    # macOS 10.12 and earlier
    default     rust_build.stage0_versions  {1.77.0 1.76.0}
}

# Rust components to be built
options     rust_build.components
default     rust_build.components       {rust-std rustc cargo}

options     rust_build.use_cctools \
            rust_build.archiver \
            rust_build.ranlib

# some tools provided by system are too old, so use MacPorts version instead
default     rust_build.use_cctools      {[expr {${os.platform} eq "darwin" && ${os.major} < 11 ? "yes" : "no"}]}
default     rust_build.archiver         {[expr {${rust_build.use_cctools} ? "${prefix}/bin/ar" : "/usr/bin/ar"}]}
default     rust_build.ranlib           {[expr {${rust_build.use_cctools} ? "${prefix}/bin/ranlib" : "/usr/bin/ranlib"}]}

####################################################################################################################################
# for building LLVM as part of building the Rust compiler
####################################################################################################################################

options     rust_build.llvm.legacy
default     rust_build.llvm.legacy      {[expr {${os.major} < 11}]}

options     rust_build.llvm.cflags
default     rust_build.llvm.cflags      {[portconfigure::configure_get_cppflags] ${configure.optflags} [expr {${rust_build.llvm.legacy} ? "-isystem${prefix}/include/LegacySupport" : ""}]}

options     rust_build.llvm.cxxflags
default     rust_build.llvm.cxxflags    {[portconfigure::configure_get_cppflags] ${configure.optflags} [expr {${rust_build.llvm.legacy} ? "-isystem${prefix}/include/LegacySupport" : ""}]}

options     rust_build.llvm.ldflags
default     rust_build.llvm.ldflags     {[portconfigure::configure_get_ldflags] [expr {${rust_build.llvm.legacy} ? "${prefix}/lib/libMacportsLegacySupport.a" : ""}]}


####################################################################################################################################
# utility procedures
####################################################################################################################################

namespace eval rust_build {}

# TODO: move the MacPorts stage0 compilers to a better location
if {${os.platform} eq "darwin" && ${os.major} > 16} {
    # (CURRENT) macOS 10.13 and later
    set rust_version_current 1.82.0
} else {
    # macOS 10.12 and earlier
    set rust_version_current 1.78.0
}

proc rust_build::callback {} {
    global                      extract.suffix rust_version_current

    master_sites-append         https://static.rust-lang.org/dist:apple_vendor \
                                https://github.com/MarcusCalhoun-Lopez/rust/releases/download/${rust_version_current}:macports_vendor \
                                file://[option prefix]/libexec/rust-bootstrap:transition_vendor

    # 1.81.0
    checksums-append            rust-std-1.81.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  cc350d0dad972ffeeb6d81ff7636cbb9879fcbe9 \
                                sha256  44809c3b92c7500c64517151f1e3389b32913a35414553395104bc4a0ee35f69 \
                                size    40942716 \
                                rustc-1.81.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  b69c0213da0aaabeb8d56f0ba27bf14d546c0a67 \
                                sha256  9c3d36b8860011bddec580b12e4b6937aa0657b393e7aeb20f1dc90e743ffa7e \
                                size    92766082 \
                                cargo-1.81.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  92804e2ab2ef0235fca79b02b27ce1b569dcacad \
                                sha256  bca2ed0f3b5dec19bd53b0a7d999eb1b495cd5ace69aafa088b44d83f44e3a8d \
                                size    10520443 \
                                rust-std-1.81.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  5f00ea9afd929e1b6d1870cd9946bab191ef0a19 \
                                sha256  ce8ad1cf2c5a7948a8f468025a5985a5249ba2fdf3303ef753170904451b4fa4 \
                                size    42635280 \
                                rustc-1.81.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  38d94c4b30f134a36d58f62206331b2fa9a64ae3 \
                                sha256  8c5b7c032db01403057e0cf3e1405d05ac1fc522bb2dc4703a0f4753f3b5aa7a \
                                size    93666190 \
                                cargo-1.81.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  7799a883cae4942c4f1d4560fe5c6a2ecb2d4570 \
                                sha256  5f7ce48ff15f4e7f8ea96141fffccd164770c492076baddb419f76068e7faa8c \
                                size    10267303

    # 1.80.1
    checksums-append            rust-std-1.80.1-aarch64-apple-darwin${extract.suffix} \
                                rmd160  600230c291c4d63ec59ff61acf800e4d338d4a44 \
                                sha256  7da7be82dd9e6697829e271feaa5898a089721e5b52bac764e3672472dd69081 \
                                size    40245667 \
                                rustc-1.80.1-aarch64-apple-darwin${extract.suffix} \
                                rmd160  e6f254ce0500968f2ae35545af0e53a63884faff \
                                sha256  dc1fa2b91b259e86d68838028099969939f7074fd554c35acf87889faf29748f \
                                size    90709374 \
                                cargo-1.80.1-aarch64-apple-darwin${extract.suffix} \
                                rmd160  5ba3f24dd08816d06c0b10e9742e4fe25ad43ec7 \
                                sha256  effbc189e39d518fbbd2a67cc8e5f0fd6f0c1cf45f058fa667b30eed1b4a99b7 \
                                size    10293248 \
                                rust-std-1.80.1-x86_64-apple-darwin${extract.suffix} \
                                rmd160  f4f728fd4ce7fd75a4a0c9f764c4f00a399af106 \
                                sha256  8fe1bd5ac9fb8741d3049b753a6eabec0e88d9c2c0276fdff34f868b35edda41 \
                                size    41992918 \
                                rustc-1.80.1-x86_64-apple-darwin${extract.suffix} \
                                rmd160  5c6bcf2df9ad65bf4e4bbec33883036ee63c6967 \
                                sha256  776599e893224237a780990d7a3ff63b54563439280534b279fc47287d4c1d13 \
                                size    91381247 \
                                cargo-1.80.1-x86_64-apple-darwin${extract.suffix} \
                                rmd160  4f93d5424a4fdfc00993a153f1424c114ff04397 \
                                sha256  3356b40035d8d0792818c1ae0e93409953211d3a0bc84c648142face964324b0 \
                                size    10053580

    # 1.77.0
    checksums-append            rust-std-1.77.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  100795b091d9227b455271e87902cf37fe34b948 \
                                sha256  e8aec533035bee2ebe5418893fa62bbd7357ccee2656ee0988a9a699dd874f19 \
                                size    40392780 \
                                rustc-1.77.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  15d4355e50de0e001ca62c96b8bd6e5e1f009a9b \
                                sha256  d981f3b13a3b55b290a86077e85c9a0419a9c79172704b262238562ccd178c5b \
                                size    100906356 \
                                cargo-1.77.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  8b7a83a59afb374332c7b14217b87d6b5feeee3f \
                                sha256  da3081d86d8059c0db5bbe3b9f2dc3b446c5d3b356c9230eb96cf6f53d7483bd \
                                size    9947870 \
                                rust-std-1.77.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  88892ba122acf6d4593b4f92518b45cb7682e220 \
                                sha256  9d717fe4ceb555e86b6f7da96387d354272e25abe18b80a353da436ce8f1b0dc \
                                size    42031551 \
                                rustc-1.77.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  17ffebc17c95e323053287ab3678d794b7f56ff2 \
                                sha256  86f02f3877c66a42e1171dfc20d6e80d177714f20cd47c79f6dc35dc04529f90 \
                                size    91141593 \
                                cargo-1.77.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  884da1e9e1b5d913b1e1bdbbc3f681ce456113d3 \
                                sha256  611f042a09d2fb0ecc96da2a1a25639e3dca8dbe1772dc690d9dbcaf384babb5 \
                                size    10521351

    # 1.76.0
    checksums-append            rust-std-1.76.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  74402a9f9c14e2ea901f350d4cdcdc4fdad9c0d2 \
                                sha256  094aaa4f05aed3577e19ab42c7f1d2e310efe79901339e9a0d57767353ce0ba0 \
                                size    40701506 \
                                rustc-1.76.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  6e212693c1e6aeb08175da53662e80c19859a735 \
                                sha256  776e43b3bbdf248c9cfce9fc4a9109149a77ce74ac0fd9f541dc14d5661b782c \
                                size    102673629 \
                                cargo-1.76.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  4b3ea0a434f7a37f24e3e480888f051ddfb280ae \
                                sha256  ba7039cfad5310bef8d521e3a4f1dca2f79fb0adb2ff1715c24a4d9eca2b2411 \
                                size    10547595 \
                                rust-std-1.76.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  2848ee3b5ce677d76dd70bb58c69b3caa063ecad \
                                sha256  0ceb5c8891a782fa8a492ca49410291cf93d643a87c3699d3945b6ea48ed1b01 \
                                size    42449536 \
                                rustc-1.76.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  c2710f48068d3700cd9925b4eeb5d6ab96588c6e \
                                sha256  2a4574a4b5f3f262bc6961fd3f47ecfdb4df848522bb1b46fbaa20be1e952341 \
                                size    91867640 \
                                cargo-1.76.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  0325ebe1ba17be81890318af95ae7078dd369e55 \
                                sha256  849d5fb21f2e55c7a5eb1133edc17dde0f9638003fbba8070a4dd13385c8e3fb \
                                size    11189029

    # MacPorts bootstrap binaries for older system
    checksums-append            rust-std-1.77.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  209c032afd18f3d3fffb744012b05d4092f7eaed \
                                sha256  c21b923f5e0e19d911e7ea48fbb1d5f6c2de00c43c339531632077c720be285f \
                                size    33580589 \
                                rustc-1.77.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  0972eb03e8a66916e01db59fdf10d0a4105ede3e \
                                sha256  e56515881f85a7cde75113cfa7a08bc0271996a4db2b39abac3222ec8eb20a9c \
                                size    45495452 \
                                cargo-1.77.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  bf601f4ccd639887accbc7035fe6d610b2e2a80d \
                                sha256  ea81ff7bdca0e6df8ab60b8add4f986053d9b2571a84ac87170213fd0463be4c \
                                size    8840416 \
                                rust-std-1.77.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  f4e3b07da10add61d5251b074a7456b8e06f30b2 \
                                sha256  3c8e099b2e39017988a4eb4c8e710f694d87e3fd4bacb1d7e0a04d37a5b4d613 \
                                size    34931751 \
                                rustc-1.77.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  9d773db3c53bd9e91049efff01581e119bf68439 \
                                sha256  7857f7aa9efc1f7da125d967ce54332a8545929078c0efaa8af75899a6ece692 \
                                size    47856865 \
                                cargo-1.77.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  6926de6dcb32a668547857d47c0aede4eb226695 \
                                sha256  929030fa677dc68e70922e2d4640649f4c7c16f0d06c7d93eb246da12b53b62e \
                                size    9739584 \
                                rust-std-1.77.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  904be0c25e6af6e517bb8259d9b8ebb8b7a9dc78 \
                                sha256  196aecec3a50321faa26a2361aebac108e0795e406610a7e993e0bef247a3b22 \
                                size    34612949 \
                                rustc-1.77.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  a19c557422be9cc5a6571e67dc285640f55a5de7 \
                                sha256  b9fd8e59d7f515041a2d9b654a3b024ade6b8bed3f04c972e09c0822cee1d067 \
                                size    63643724 \
                                cargo-1.77.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  37a7a995e428ea586f67ecd513fe305989ccdcaf \
                                sha256  dc7107b9d9e5bd27aa4ee429ff8698236585dd2cbb1eb16ef1d1191a71ddaaed \
                                size    9674446 \
                                rust-std-1.77.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  3aeb4ac66e8c7c88be8b3f1ac9eef65b295997c7 \
                                sha256  79881f143d1a0190f69a69771b74d5ab23aff83a8d7ca2285ddc3c94976083ea \
                                size    34957998 \
                                rustc-1.77.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  ac6aaeff756a29ebe892c271c8b2ad3153ff09d1 \
                                sha256  1cbdeac287282eb50bfdbe028ff586891235091b6624274a004eecf9215e23b9 \
                                size    48510110 \
                                cargo-1.77.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  61727e53f19ef305d806e5c15c218b9ab3b18123 \
                                sha256  4b948b17ff8743ca39d683ad63cd0ee2449333d0dc54e654f43f37d63b595fd4 \
                                size    9925023 \
                                rust-std-1.77.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  97167ee768bb6df20dc6eb48a2803168f992bb8c \
                                sha256  b45f2726151e3caa47c2dbd57b935da80f7735e7ca4e3b35d925284c8950aba9 \
                                size    34628935 \
                                rustc-1.77.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  6cc559c54fd69f6cb7b026eeaa2682d872b13bb8 \
                                sha256  a7f4512f3cb4c0cb3448c44f3f96af6bc54726e03c2a6ba482eed8b611f00cfb \
                                size    64799018 \
                                cargo-1.77.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  45a9cac6c5d0c76ffd34e822594d13715604b53d \
                                sha256  045ddceb278eca1224e838fc0bb2db1fd8709fc0517d753a2d9eb0ed491d84f9 \
                                size    9833525 \
                                rust-std-1.77.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  282d517a43c9c0ba2165b0c86a50d58a5126323e \
                                sha256  efac56ec008eddc46165feb13780179cf2325d1e1f95f7bd8519e57eb40d7f87 \
                                size    34947128 \
                                rustc-1.77.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  f102a98169799dc546683801b12aec471d9cb4e9 \
                                sha256  9cbae2651c6319b3cf4c963d3ad8216b511f6559079c73b656b1666bde73d5a1 \
                                size    48581212 \
                                cargo-1.77.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  7c98b79b80eff26ab5ab99d545b6ad26888e5afc \
                                sha256  6205ef910872eb99a86171eb1a86c11c0babfca7855ff846f018412f67d879f4 \
                                size    9942177 \
                                rust-std-1.77.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  4f597459310e252e5d7aa94ff44dae0bf8955d5b \
                                sha256  b7beb0a03caa554472886a31afb223563f0689292f05b82235253ffa1b50ede3 \
                                size    34607178 \
                                rustc-1.77.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  fab558ac445b9fa1e7ac82a748c890366610a84d \
                                sha256  fa43ceec36fc93384abb199b9d46c5b51b48cec5d8b5ad402fd338f3f882e8f4 \
                                size    64875240 \
                                cargo-1.77.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  7e0306bf85c23ca23664ec33927cdde503e161a0 \
                                sha256  cfcfb05ed3f51bc48f0a1a8655126c939fb1e739a9cfeae15d427140b4a1d982 \
                                size    9858458 \
                                rust-std-1.77.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  4be19067d479e1cd767e1626a953603dda00bc70 \
                                sha256  03dba50acbc3ed3ac5c72ef710cb6fbe659975f4658b5af12ae36b269f1f68fa \
                                size    34842280 \
                                rustc-1.77.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  49c9e2dc7e877f6f30d8e309bd5e62c7c32fc157 \
                                sha256  2627d2ddbe8a18d15ecdcf8a46687373069c6f1d1572321da41b147d29c95c02 \
                                size    48391467 \
                                cargo-1.77.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  b2b0b953aa86684032dd50a95aca6438baf8a9a5 \
                                sha256  9835645ddb52c2a3d29a80ed6ed57c862729df645056619254f60d5cabb2c0be \
                                size    9808608 \
                                rust-std-1.77.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  f96b1f09bb7f56b06bb72848d7a3394937498208 \
                                sha256  510655920f1b88f9ae460cc900a20a7f1544c67b17b405653278bc5d329dab8e \
                                size    34528608 \
                                rustc-1.77.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  e1d8b393a21290ed3d02952496dabfdf79c41dc3 \
                                sha256  c32c669704a39f7218b612ff585ff0d90efe2df724ed9fd6d4d7509465678666 \
                                size    64690666 \
                                cargo-1.77.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  4ab047afe8a2bc65cd4fa8c62e7f9ff2ed2c746c \
                                sha256  fb70510ad7bcdb71db9d6674f88bcf7ce6d29b9eedb52eacffdfef3b0b627f78 \
                                size    9722271


    foreach arch [option muniversal.architectures] {
        lassign [rust_build.stage0_info ${arch}] stage0_version stage0_arch stage0_vendor stage0_os_version
        if { ${stage0_vendor} eq "" } {
            # Upstream provides stage0 compilers, but they only run on newer systems.
            # In order to provide stage0 compilers for older systems, we need to build them on newer systems with `macosx_deployment_target` set to the older system values.
            # However, setting `macosx_deployment_target` can cause runtime errors in the upstream stage0 compilers if they use newer features.
            # For example, thread local storage was not available prior to Mac OS X 10.7.
            # Attempting to run the upstream stage0 compiler with `macosx_deployment_target` set to 10.6 causes a runtime error, even on newer systems.
            # Use an intermediate stage0 compiler with problematic features (such as thread local storage) turned off.
            depends_extract-delete          port:rust-bootstrap-transition
            depends_extract-append          port:rust-bootstrap-transition
            depends_build-delete            port:rust-bootstrap-transition
            depends_build-append            port:rust-bootstrap-transition
            depends_skip_archcheck-delete   rust-bootstrap-transition
            depends_skip_archcheck-append   rust-bootstrap-transition

            set binTag                  ${stage0_version}+0-[option triplet.cpu.${stage0_arch}]-transition-[option triplet.os]
            foreach component [option rust_build.components] {
                set distfile            [option prefix]/libexec/rust-bootstrap/${component}-${binTag}${extract.suffix}
                post-extract            "system -W \${workpath} \"\${extract.cmd} \${extract.pre_args} ${distfile} \${extract.post_args}\""
            }
        } else {
            if { ${stage0_vendor} eq "macports" } {
                set full_stage0_version ${stage0_version}+0
            } else {
                set full_stage0_version ${stage0_version}
            }

            set binTag                  ${full_stage0_version}-[option triplet.cpu.${stage0_arch}]-${stage0_vendor}-[option triplet.os]${stage0_os_version}
            foreach component [option rust_build.components] {
                distfiles-delete        ${component}-${binTag}${extract.suffix}:${stage0_vendor}_vendor
                distfiles-append        ${component}-${binTag}${extract.suffix}:${stage0_vendor}_vendor
            }
        }
    }

    if { [variant_exists mirror_all_architectures] && [variant_isset mirror_all_architectures] } {
        foreach arch {arm64 i386 x86_64} {
            if {$arch eq "arm64"} {
                set mdts [list 11.0]
            } else {
                set mdts [list 10.5 10.6 10.7 10.12]
            }
            foreach mdt $mdts {
                lassign [rust_build.stage0_info ${arch} ${mdt}] stage0_version stage0_arch stage0_vendor stage0_os_version
                if { ${stage0_vendor} ne "" } {
                    if { ${stage0_vendor} eq "macports" } {
                        set full_stage0_version ${stage0_version}+0
                    } else {
                        set full_stage0_version ${stage0_version}
                    }
                    set binTag              ${full_stage0_version}-[option triplet.cpu.${stage0_arch}]-${stage0_vendor}-[option triplet.os]${stage0_os_version}
                    foreach component [option rust_build.components] {
                        distfiles-delete        ${component}-${binTag}${extract.suffix}:${stage0_vendor}_vendor
                        distfiles-append        ${component}-${binTag}${extract.suffix}:${stage0_vendor}_vendor
                    }
                }
            }
        }
    }

    # this must come after `post-extract` for rust-bootstrap-transition
    post-extract {
        # ensure std library can be found by rust binary
        foreach std_dir [glob -types d -directory ${workpath} -tails -nocomplain rust-std-*] {
            set run_platform            [join [lrange [split ${std_dir} -] end-2 end] -]
            set rustc_dir               rustc-[join [lrange [split ${std_dir} -] 2 end] -]
            ln -s                       ${workpath}/${std_dir}/rust-std-${run_platform}/lib/rustlib/${run_platform}/lib \
                                        ${workpath}/${rustc_dir}/rustc/lib/rustlib/${run_platform}/
        }
    }

    if { [option subport] ne "cargo" } {
        if { [option rust_build.llvm.legacy] } {
            depends_build-delete        path:lib/libMacportsLegacySupport.a:legacy-support
            depends_build-append        path:lib/libMacportsLegacySupport.a:legacy-support
        }

        if { [option rust_build.use_cctools] } {
            depends_build-delete        port:cctools
            depends_build-append        port:cctools
            depends_skip_archcheck-delete   cctools
            depends_skip_archcheck-append   cctools
        }
    }

}
port::register_callback         rust_build::callback

# utility method to get information about stage0 bootstrap compilers
# returns
#     stage0_version: version of the stage0 compiler
#     stage0_arch: architecture of the stage0 compiler
#     stage0_vendor: apple (upstream), macports (built via MacPorts port rust-bootstrap), or "" (use locally built port)
#     stage0_os_version: append to operatingsystem part of target triplet machine-vendor-operatingsystem in name of stage0 compiler
proc rust_build.stage0_info {arch {mdt {}}} {

    if {$mdt eq {}} {
        set mdt [option macosx_deployment_target]
    }

    # are we building a stage0 compiler or just using one?
    if { [join [lrange [split [option subport] -] 0 1] -] eq "rust-bootstrap" } {
        set building_stage0 "yes"
    } else {
        set building_stage0 "no"
    }

    # find a stage0 version older than the current Rust version
    set stage0_version ""
    foreach v [option rust_build.stage0_versions] {
        if { [vercmp [join [lrange [split ${v} .] 0 1] .] < [join [lrange [split [option rust_build.version] .] 0 1] .]] } {
            set stage0_version  ${v}
            break
        }
    }

    if { ${stage0_version} eq "" } {
        ui_warn "rust_build.version ([option rust_build.version]) must be newer than rust_build.stage0_versions ([option rust_build.stage0_versions])"
    }

    # rust-bootstrap requires `macosx_deployment_target` instead of `os.major`
    if { [option os.platform] eq "darwin" && [vercmp $mdt >= "10.12"] } {
        if { ${arch} in "arm64 x86_64" } {
            # upstream support
            # see https://doc.rust-lang.org/nightly/rustc/platform-support.html
            if { ${building_stage0} } {
                # cross-compiling with upstream compiler is possible
                return      [list ${stage0_version} [option configure.build_arch] "apple" ""]
            } else {
                return      [list ${stage0_version} ${arch} "apple" ""]
            }
        } else {
            if { ${building_stage0} } {
                # cross-compiling with upstream compiler is possible
                return  [list ${stage0_version} "x86_64" "apple" ""]
            } else {
                # no upstream support; use MacPorts compiler
                return  [list ${stage0_version} ${arch} "macports" ""]
            }
        }
    } elseif { [option os.platform] eq "darwin" && [vercmp $mdt >= "10.7"] } {
        if { ${building_stage0} } {
            # use `platforms` in rust-bootstap port to ensure upstream compiler runs
            return      [list ${stage0_version} "x86_64" "apple" ""]
        } else {
            # no upstream support; use MacPorts compiler
            return      [list ${stage0_version} ${arch} "macports" "11"]
        }
    } elseif { [option os.platform] eq "darwin" && [vercmp $mdt >= "10.6"] } {
        if { ${building_stage0} } {
            # use local port since it must be build without thread-local storage even of OS supports it
            return      [list [option rust_build.version] [option configure.build_arch] "" ""]
        } else {
            # no upstream support; use MacPorts compiler
            return      [list ${stage0_version} ${arch} "macports" "10"]
        }
    } elseif { [option os.platform] eq "darwin" && [vercmp $mdt >= "10.5"] } {
        if { ${building_stage0} } {
            # use local port since it must be built without thread-local storage even of OS supports it
            return       [list [option rust_build.version] [option configure.build_arch] "" ""]
        } else {
            # no upstream support; use MacPorts compiler
            return       [list ${stage0_version} ${arch} "macports" "9"]
        }
    } else {
        # ensure valid return value
        return          [list ${stage0_version} ${arch} [option triplet.vendor] ""]
    }
}

# see https://trac.macports.org/ticket/65184
variant mirror_all_architectures description {Add additional distfiles for mirroring} {}
