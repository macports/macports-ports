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
default     rust_build.stage0_versions  {1.75.0 1.74.0}

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

proc rust_build::callback {} {
    global                      extract.suffix

    # TODO: move the MacPorts stage0 compilers to a better location
    set                         version_current 1.76.0
    master_sites-append         https://static.rust-lang.org/dist:apple_vendor \
                                https://github.com/MarcusCalhoun-Lopez/rust/releases/download/${version_current}:macports_vendor \
                                file://[option prefix]/libexec/rust-bootstrap:transition_vendor

    # upstream binaries
    checksums-append            rust-std-1.75.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  26cc550b89f91b48f731bb83f0ea48970c1a8cc6 \
                                sha256  8eedd403d05829369e3dd84c6815f69fb7e5495d3ee3bf2b4b2f04d8591fe639 \
                                size    39710389 \
                                rustc-1.75.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  9ffb6a9546a71fab49c5cbf44376d58983b25a93 \
                                sha256  0c9b1a24f08f7b7eeb411a4a62e2d8f4dbc07af7b26f93306b1c3b5d7abc0a3a \
                                size    86790447 \
                                cargo-1.75.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  5e60da8ccf57a0e34632e227e4f9077421843b23 \
                                sha256  16eac1143417207620654606f09e575bbdb66014bbd571e89182a4e4f630a3a1 \
                                size    9299026 \
                                rust-std-1.75.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  4e9d46b3c2c19c67ce0330c0e59750a60ac70856 \
                                sha256  65098155333de2e446df61cdaf12a0c441358b7973f3cb1ba95fd11bda890406 \
                                size    41447513 \
                                rustc-1.75.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  f98b9ca79aedb5517c578112d39c90491740300a \
                                sha256  ed2c9bbae4bda6d89c091a7b32c60655358ec1ade58677eaaa0e5e16ec4fb163 \
                                size    91245450 \
                                cargo-1.75.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  0dc7eb10bc40b5534333480cf102bf6b6786679b \
                                sha256  c54a64ce2e7b6d143e10d3ebd18ab8d41783558b1d9706fded1d75a2826a3463 \
                                size    9826785

    # upstream binaries
    checksums-append            rust-std-1.74.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  a6735b637e21304f261e1cac3e08d8872b4ba9de \
                                sha256  5c02396eb7cfe1a3c12b01dffd758cf862c4264df6280727798745b98f245082 \
                                size    40113695 \
                                rustc-1.74.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  8396773736e005cba5c6b59e55c76d6eb7063f7c \
                                sha256  03a8e33693d4e532368708cff5fafbde71e612c0e5c5f14b5fb80be0d7817a8a \
                                size    101571677 \
                                cargo-1.74.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  b8350c6b7b5f74d27bb29ea03d8cf58fc34a8bed \
                                sha256  b7e4c2a829bd8bc90101067ba96b71ecd73fe130401b2478b095047bd8acb469 \
                                size    9442407 \
                                rust-std-1.74.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  3a37030aa11531f969c134b4586890625b0eeb41 \
                                sha256  ffd3de3b29d324d7c8b8b57569c11bf3749fc6313ec0b2638ef38997bdbdb6fc \
                                size    41948644 \
                                rustc-1.74.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  f31cec9a10d05d5ea499587b0ea74849acb3016d \
                                sha256  3919989c194b2a6674702f0323cac4229d7c6939c933acf4e4451c144f69c8ed \
                                size    91230594 \
                                cargo-1.74.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  490bc0cb6c5b5f301cbd7ded44edef14166f7357 \
                                sha256  f45dec402a07acf072f1f58064cb3d21cd795914182e8260d88fce73f082b577 \
                                size    9984570

    # MacPorts bootstrap binaries for older system
    checksums-append            rust-std-1.75.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  1d496fd591cfccaad42dee5844720419b1e62ef7 \
                                sha256  4e13100c5ef8c48810a0c146cd81fdac5ff44a788edc7305390ac36f857c020d \
                                size    32935810 \
                                rustc-1.75.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  a1d3b1bd5f741ab71fcc30517eb139ffff8e092f \
                                sha256  02213fedbec6aa4ddde6484d11f63fee09317d573248f83923feb4c63c29b172 \
                                size    48260691 \
                                cargo-1.75.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160 07b613e0399296e8f94c170a0ee8e4df02c09f56 \
                                sha256  24951b3396462afe6c230d40f87e6865c426ccb447f64bb8b065d75d7c60655f \
                                size    8180003 \
                                rust-std-1.75.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  4ab0d2b16707b5dc8eddd4cd14827b9bf0cd8249 \
                                sha256  a3e977f94dc6a8024659ed43f34b61d119d0bb047297d590c668c251bba7a410 \
                                size    34426727 \
                                rustc-1.75.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  b21ab4e8bf77e721be474e39d74e3d248ea9ca8d \
                                sha256  f3eae73cc50213e4dbfd01e09ac383c6fe5c9573cf17b89aa5acb1dbe2443f1e \
                                size    48410237 \
                                cargo-1.75.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  6bf45180fbc1cc5961334b9ba680e6719a24d674 \
                                sha256  73dab3963697fdcb7cb0657191d7e0bceb1ea1f68cf76a3125e3c34a9cc316a4 \
                                size    9030514 \
                                rust-std-1.75.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  57084a6e39a5571ae75469884b9e33f4b58aff31 \
                                sha256  5655beb58184a24c9aee3cafd6c9bd28a4eb42c8051b5f8678c5127d972d5949 \
                                size    34111790 \
                                rustc-1.75.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  724269e21659b5e83a9f58fef7215691a378f61b \
                                sha256  d7c23f972f9ce312f58c13e455d2381225b74f88fe08dd78b9c3d89ef598b1ca \
                                size    64910950 \
                                cargo-1.75.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  ecf3293e94e81f82ded28c7f7c5645659c20cf2a \
                                sha256  d528f5883838e974a526aa9cf9d65b01294b864cd68ca94c1d5f94ae2d3488c3 \
                                size    9061794 \
                                rust-std-1.75.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  fb498d3a838854c6d1a0e8c0e29b9897f2db14a9 \
                                sha256  adea14e16be4ef562a0bbaac34784d95ce0a4ef4b2bb40392a027ebfe0736532 \
                                size    34452154 \
                                rustc-1.75.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  e15d2eae82a770023256a461204622fdf11ce480 \
                                sha256  18db23cc05e2b01023558c7963275b767ba1968a4e86664fbf6b5fe81dc8ad67 \
                                size    49061492 \
                                cargo-1.75.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  69a18ada4bdabcf9cadcae26e50f8fb3503719fb \
                                sha256  83b12efa12be7f313ae0a1feb058ea208bb5addd7a26809cafb8e90a505de3e1 \
                                size    9193597 \
                                rust-std-1.75.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  afe9333ffbd0a7719818516394374ff2398b242d \
                                sha256  f4cb36f63bdfcf2c323e6364ae87cea457066e7a4bd97eda9425cdf8410ff852 \
                                size    34137975 \
                                rustc-1.75.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  380b309815541eabe889b1f7b667dbf5284120b4 \
                                sha256  2278aa3990d490b3f6562c9bc21decd1afb010af896866b9c9e7433522d9f276 \
                                size    66079200 \
                                cargo-1.75.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  69bc5b8f623e385940089de13d6df7bd86c8d1d7 \
                                sha256  68594ced3547ab7a6988f18e5ab24de3e28f4dbc2efdd91c6ad7658cee264ee1 \
                                size    9201964 \
                                rust-std-1.75.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  c62bdc829b30e50508f645fce8128267a02021e3 \
                                sha256  a97d20e6c6f4aeeaae3631ecf5f20fc8f21a224a35831e06d822fa112f36392f \
                                size    34458904 \
                                rustc-1.75.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  7fc9f954d445c45a5234a4de91ce90087d384ea2 \
                                sha256  59273656fc3b641d102a372945bea124136b9aeb8f96c97f2b62422e4a92a5d1 \
                                size    49145901 \
                                cargo-1.75.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  835274c161d19d722a9d8b6bb31658f8f2ea4ae8 \
                                sha256  6a2d7cc221aeb9a0b2feb9dc6546144b07ed8fa40909001c2b5ebebbd598187f \
                                size    9209718 \
                                rust-std-1.75.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  d30e23a4e712cb074a57c061d150bd4831fa3973 \
                                sha256  05e33015dcab99fc2f434bd34511912a1ff803c20ec7dcc6cbc2240e92c1de27 \
                                size    34129419 \
                                rustc-1.75.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  fe4325b33a8c31358702576bef4158f0c2db9144 \
                                sha256  dc2a93efc4cd4cd8775351bb1166138c577c3d3c5a5acd6e8c3541ac41974439 \
                                size    66078870 \
                                cargo-1.75.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  adac5c060d2a17b7b420af3299f9f1435fc0b932 \
                                sha256  52c9000e504361054b0e19df632248b6a7721adc9625bb64b4272bc8f858326b \
                                size    9217938 \
                                rust-std-1.75.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  63592f61cdb2b4cfd537013492c6bee9c7997beb \
                                sha256  61481bbf2311ba2b8d1d6494d43ee3325a882ee30bc8b32c1f7820b4a33b6248 \
                                size    34365161 \
                                rustc-1.75.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  3f9c126c357d7e4089d29c92138a39980a45d796 \
                                sha256  680d07a8ee6674e00f53fafe4b1d4d85c64d510d9700f45a62fed38ef758edb2 \
                                size    48937008 \
                                cargo-1.75.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  165a8958dab4965c5977a2d8fd716cc9fc09bb7b \
                                sha256  3cc2d89948d9e330cb1e521ead4fe08f5f3b78f82e00e396e6c6e3671359d3ba \
                                size    9069173 \
                                rust-std-1.75.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  d41a28ad1603177ec85f03635b8a2372302748ba \
                                sha256  20539e0d02603acbb1883e36ae074e5d304e7dcb823df76930849645381c2ab1 \
                                size    34045760 \
                                rustc-1.75.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  198db29de2a52dde0acdf444542b0b224f40bd62 \
                                sha256  8a849e794134f1dafecda831b04666c1bc481926a9a16b3f5b9df985cde67a73 \
                                size    65909304 \
                                cargo-1.75.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  2041cfd38d4d84f8b61e4814e77c7728c2dc6372 \
                                sha256  b55605958721fb9e7342b7654fbb72d739b60c78e8e4632af46d1f6ea7eee5f7 \
                                size    9083486

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
        return -code error "rust_build.version ([option rust_build.version]) must be newer than rust_build.stage0_versions ([option rust_build.stage0_versions])"
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
