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
default     rust_build.stage0_versions  {1.76.0 1.75.0}

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
    set                         version_current 1.77.1
    master_sites-append         https://static.rust-lang.org/dist:apple_vendor \
                                https://github.com/MarcusCalhoun-Lopez/rust/releases/download/${version_current}:macports_vendor \
                                file://[option prefix]/libexec/rust-bootstrap:transition_vendor

    # upstream binaries
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

    # MacPorts bootstrap binaries for older system
    checksums-append            rust-std-1.76.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  2ee291c5ea484cd0e82210cfb1523e9c5c7c1c4b \
                                sha256  2add5dead14200b772a8761904e4e44f177aed83ffdf753d243859a8806a5792 \
                                size    33953064 \
                                rustc-1.76.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  356827395fe12111b9edc76d37f8d30c8aa8d098 \
                                sha256  f7410d52b2c6a43363d6cba814b56f910016c4701216184d191e0a2c6cb7733c \
                                size    46606147 \
                                cargo-1.76.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  530b08103afb02c3e7766c28405757395f94bdf6 \
                                sha256  a8df6dffc82a1ece00fe235238f55d126cb6210eba727610e0d3e6b01484c695 \
                                size    9437704 \
                                rust-std-1.76.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  9d328d4231c98a4459fcec8b936a22e54ed2f4c7 \
                                sha256  e9c3edc49d2df3675be018922ae1189cb8548771e5fb8203821c114a72330a50 \
                                size    35424321 \
                                rustc-1.76.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  3e055461cd11e37c5f1a0ee5fe39b01a120f2e9a \
                                sha256  5b1cd6bd23a5f7d7b09ecd69578f403b584f73bd64ca03e849fe13e96b6e3af0 \
                                size    48978221 \
                                cargo-1.76.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  9d1381ec28510725a895a62633a0ae5f00d322c9 \
                                sha256  6ee5f36f71e3d8e82e64200cfd7a4b7fbbf46375ed59bdf2b35f541ab378dde6 \
                                size    10408594 \
                                rust-std-1.76.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  dcbd76a0e53ff1634430c03b5d2bb7a7b24386b4 \
                                sha256  2bea61f1135f9ac86e8c2bf2e1b42919ebd99fd631d33dfbedb616abe131bdd8 \
                                size    35102266 \
                                rustc-1.76.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  5f051b587b7215251a759c74b307e622ca6b384e \
                                sha256  ed35ea4cce9348388d314a06d3ae277aaae21e15ba7765435e4da1f5e9d93b1e \
                                size    65793899 \
                                cargo-1.76.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  47a716533928086678ea78bfa5f4068b6bdff283 \
                                sha256  ea55616dc2d7a28292de040b64f332e8b9624e0c8a02272b069170356f37a926 \
                                size    10342428 \
                                rust-std-1.76.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  090bab800835001ee737b9477c17ee412cbacf95 \
                                sha256  cf9b423e87db290d67ecf6d76150d58e7c2ac48452fd1017134c0e6bfe62d002 \
                                size    35452712 \
                                rustc-1.76.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  566cdc76d40bc197a4323d436fecbdc9d1a761ee \
                                sha256  88906611b08b01f020cb0ba7924feeb2128cebc305f894b759bc0e810b20f803 \
                                size    49651116 \
                                cargo-1.76.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  15007c01462b979ada0a61574eb1a070f450b362 \
                                sha256  ac6e5db15d7627f90674e591676185a8f9a48861088da4dd9ab3a5f3c81b9606 \
                                size    10602892 \
                                rust-std-1.76.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  1724ae5c39bae1735dbb55d1ba0ff7d8a9e9c1bb \
                                sha256  39d33cdb5a49ffae4f410def3df003f9a2815e02ca71c157d468bf069deddffe \
                                size    35128293 \
                                rustc-1.76.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  fc6f9f26ee89f970dde93192d5e46fd2ad868a4b \
                                sha256  5e7cc54c679a11ac07f3ee1d6280b8b7b95d8b1db2d2a6029a9222995b6eee1d \
                                size    66993675 \
                                cargo-1.76.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  97ca9d594c6ad064d827409da4d9bddaad52655e \
                                sha256  a2200ad23f25f927791d13ad0acc7c5cd6d560706865709094d9b4743dc73374 \
                                size    10508437 \
                                rust-std-1.76.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  2c76f28b0781ae05b8181598c58eaa3a14d7f463 \
                                sha256  8e4c5649210f9cf782db54b25bb33bb752047657e7557c1be1776a6e3d8c89ce \
                                size    35464588 \
                                rustc-1.76.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  6b9d5e056c19696bb6bd27ba192f5c40de9885e0 \
                                sha256  64fb327419b2be98d0461072209b1624701298f5b3cbdab1c0df4f69644813ff \
                                size    49717437 \
                                cargo-1.76.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  e9b99df656c117a08ec1cf2264b0b567c3fb6179 \
                                sha256  f54fe6d43f67657b270058c44d9b57ad09b3c8d9e87958327ac260f03435077a \
                                size    10607076 \
                                rust-std-1.76.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  db80b2382a20899feef1c181d4719c622a9677b6 \
                                sha256  844f5ae3da7d0e45d8fc51255bafb51886ebfbdc687fcd5473116a237bd3b225 \
                                size    35161641 \
                                rustc-1.76.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  575ed1f7ff5aab7f45ef2c0d1c4b3e78f0a152e6 \
                                sha256  1c604ce9150c12e46aab63ea633e92c172c377cad0730dd5799eeca2503f39d0 \
                                size    67041904 \
                                cargo-1.76.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  a3d9aa56269e3b81b211977e4c5e50b121a12227 \
                                sha256  2b64c97ca57752ab05cd43a33c4df0c6cde0d452776e0ebd3af86bcc89f25dfb \
                                size    10511559\
                                rust-std-1.76.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  d2933932f7ce50efa3c4336b9f4c43c225f1f9ac \
                                sha256  fc73b2dc996aca8459f741735c44245948e6fa51dc0fd761de73f1498fd7dc8a \
                                size    35373013 \
                                rustc-1.76.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  039e422ae8fbb02ad556e8537565129d488bde1a \
                                sha256  3978ed87887fc25cb4a79fb9cce8d8b5dabb588253a9aada39e7209b6f55c52f \
                                size    49510583 \
                                cargo-1.76.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  de5d0dde259d3149d60b411c2513900b17525f49 \
                                sha256  44fbf668a1d1bdf4cad7feb5bcdcd4dfb954fe197a2a8e0e7508438ebfd61c32 \
                                size    10462717 \
                                rust-std-1.76.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  28ca33e12ea5a2f01d4da9bf971839a587d6dc1a \
                                sha256  e06a41630eb3f8134033df435fcbb5dfcd721ed0e98f91ad717ac93e99139301 \
                                size    35057895 \
                                rustc-1.76.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  393781cbe232c82532be6cbd149d043715c95214 \
                                sha256  cff6116edd3448bde7dc078a716a1db7beb03d6f5da4f6b81a4f1dc2ac3c30db \
                                size    66856821 \
                                cargo-1.76.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  c6f86d20103b7c26dd49b6b3b74fab394e71b918 \
                                sha256  1ed5bd071ece2e954ac82a44129d6122529ab381829390f9c54ca10ddb26ac69 \
                                size    10368648

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
