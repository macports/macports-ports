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
default     rust_build.stage0_versions  {1.74.0 1.73.0}

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
    set                         version_current 1.75.0
    master_sites-append         https://static.rust-lang.org/dist:apple_vendor \
                                https://github.com/MarcusCalhoun-Lopez/rust/releases/download/${version_current}:macports_vendor \
                                file://[option prefix]/libexec/rust-bootstrap:transition_vendor

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

    # upstream binaries
    checksums-append            rust-std-1.73.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  2aca579bc99ece76ffdfd4b110212fe4ca82e656 \
                                sha256  651d9ccf5282c67b4f5bcf0eb194b0d29750667271144c3921016a018e33e3c5 \
                                size    40836286 \
                                rustc-1.73.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  bfdb11a317401146484dc5eba074ea41b99dade1 \
                                sha256  f5c938b2aedaf3451e41b696875aab7f66c435d8245af3af1f61ec636b0e64ee \
                                size    101863654 \
                                cargo-1.73.0-aarch64-apple-darwin${extract.suffix} \
                                rmd160  b361e49a5d09da64a694f72fa0ca2cbd387883f7 \
                                sha256  370496a66ccadb3d07800949eee01f0088b3efb220fa80973a7ff7e68b1097c8 \
                                size    8946256 \
                                rust-std-1.73.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  9abace8995015646dc2885c3f63be9284b85bf6f \
                                sha256  1726086f74e6348a95286dde2810c5da6f9591cd5989f38178026fcd4b720b9c \
                                size    42841277 \
                                rustc-1.73.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  77b0181229d016d8890f935c2f72fa3a3b2e38a5 \
                                sha256  4ef3199cbdb16f1001db1fcb880c1cc0c8a898b915f03faed7e5d1d553ceaf83 \
                                size    93781287 \
                                cargo-1.73.0-x86_64-apple-darwin${extract.suffix} \
                                rmd160  92a310ba2e1072a0a4563e8312be9a35a971566f \
                                sha256  1a69a767e0ecd3e4de896c653ff266b6f16400144fe30141eb83f785cd93945b \
                                size    9640305

    # MacPorts bootstrap binaries for older system
    checksums-append            rust-std-1.74.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  6099a9218abbcc1b0c88f19bbef5b2d1b5d0a250 \
                                sha256  30f5fc772ff9034d24273df45e2bb3b9b8246cc414d1da22f5f9fbf429627308 \
                                size    33442823 \
                                rustc-1.74.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  f5aa5c30b964e4e10dcd0f2c672bec3c290fea76 \
                                sha256  ac7804b9b455a35412c2ffa33c49a4f773257dc6733ad5f2eb6b939f82f02aa9 \
                                size    46165315 \
                                cargo-1.74.0+0-aarch64-macports-darwin${extract.suffix} \
                                rmd160  81769d5045a0c838a0577313c270b5426aaf44aa \
                                sha256  57dfc7ecf53c67e50616d7e8ab49e2480883e5e149746566c5c066b5dd315e6e \
                                size    8402948 \
                                rust-std-1.74.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  02860b782563b24bc6ac8728a14172a924d22125 \
                                sha256  5606a911d2bdb2e9c9661543b754807290ccf95e20f0fcb053550199791aa579 \
                                size    35030357 \
                                rustc-1.74.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  e51780291722b9d8f84307fec2efc2937a26f9cf \
                                sha256  0ebb9416c0789e50f9375ac14312272eb5b8e28ba4dd103c2ce2287aa18e14c5 \
                                size    48429770 \
                                cargo-1.74.0+0-x86_64-macports-darwin${extract.suffix} \
                                rmd160  3157d2778212d373c544658aa21f06dc6f43adce \
                                sha256  afd7f72b33ba82a03d8412d8dd63c708df03b1e4d34616dd0902ed611a38ab9d \
                                size    9196213 \
                                rust-std-1.74.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  529baada10e44847878648aebc61ab66d284c79f \
                                sha256  7a5ed2512d6c9547f73cb33318eb3e8acc6d88f47f7a85556818b0c7d1507b62 \
                                size    34657664 \
                                rustc-1.74.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  edccea7fcaa308fe1cc9cfec190d000cdcb8f12c \
                                sha256  a0fc79dbda7ec4842996a37b02d9bbe4cdb026196574aa8b25a42381cf0dc0f8 \
                                size    64667460 \
                                cargo-1.74.0+0-i686-macports-darwin${extract.suffix} \
                                rmd160  d49092d0cd477bf1ab656c9f3f861560a3c59865 \
                                sha256  f2255cf447d7527820d4e45f195323e3ad240dcd2a8ff54fe0fd0f5832e22d67 \
                                size    9135774 \
                                rust-std-1.74.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  0c2117e6bec0839bef7a7800ac39755b3eec8eb0 \
                                sha256  2640ce6361933829afd961dc3cdfbdffe5215a603dadb1f9855cd02c166db718 \
                                size    35075540 \
                                rustc-1.74.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  0efb2d1c83eb1fea39be4cb55db40c07d923906b \
                                sha256  e468b464174e1aad2a98d9b1101eb37d42ed266d7cf41488d1fc1fec1cc406e0 \
                                size    49193866 \
                                cargo-1.74.0+0-x86_64-macports-darwin11${extract.suffix} \
                                rmd160  2c8db29fbbb0cce53cd0facc825bede927c88455 \
                                sha256  31e7a8fb54025911e0b1042c33952105ae1fb0a3dbc64f6c34876b84cf4bc7cd \
                                size    9392310 \
                                rust-std-1.74.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  fa31ad6e2cc59f04e5a1f480647eb00b93d0f06e \
                                sha256  4b5fc92745065eaa791127dea6f0d8bc311e6ca941f93c0d55cd9f965ad0d993 \
                                size    34695914 \
                                rustc-1.74.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  34c68cddf66c78b850e7ab2072c1a326a3649c34 \
                                sha256  d4ef2a917e1ee7ef585b76257822ae411dcc52eb4d0bfb64319c7fcf58caceeb \
                                size    65973754 \
                                cargo-1.74.0+0-i686-macports-darwin11${extract.suffix} \
                                rmd160  65a16b7aaf01ab7dccdbe6481ae474015058a235 \
                                sha256  f51d1a4dee0cd8b8a8dc79e5cb281f9cfaede45c6f1cc8db024a08cf465d00bf \
                                size    9319889 \
                                rust-std-1.74.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  3b25f29c922df9cccb2809e65dee96e6d8242f04 \
                                sha256  c2c0309b792aa8e29aa9bd16bb053859b95543fdb5674e6a352c4b0c0bfc2253 \
                                size    35072661 \
                                rustc-1.74.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  819bf7e7fa9e181b2f3e9948b0ed2c28e387aa74 \
                                sha256  ea9b37467f9331c84e4ecf82d084f51b61db44a5d5fb5ca36fe77461d6088e5a \
                                size    49301375 \
                                cargo-1.74.0+0-x86_64-macports-darwin10${extract.suffix} \
                                rmd160  921e942c26a2fd24f58191a734a3ebfbbb6a7ce1 \
                                sha256  a71f44d029ac4c54e39ea04e98c195976627046c0e54d3d841926d91eedcbf81 \
                                size    9407556 \
                                rust-std-1.74.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  df4b84f0ba430546780395fd5f8b957563319f7b \
                                sha256  c104368cab1ae6d986786cf3556dab80cb6709258f2352160c8e85fedb0d52ac \
                                size    34753545 \
                                rustc-1.74.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  06c4a7e36c70b73864840c2ff9cc18ddbaeac7e7 \
                                sha256  d7dc157e7579606b51caf3f2deddc82c46af745ac9d0de20a882409b41afd2c2 \
                                size    66055887 \
                                cargo-1.74.0+0-i686-macports-darwin10${extract.suffix} \
                                rmd160  20281347be8aaa557d7ad60efbc6e953713e38a3 \
                                sha256  e3466085249e006874f79486ae95cf5f3322342caadaee4fcca84c675fea2a53 \
                                size    9329343 \
                                rust-std-1.74.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  15a1074fa038eb325e45e55f2f0b5524671a69cd \
                                sha256  c009f743d96aef7869febc938aad81e18deb557c441910584287bd3b837d0a5a \
                                size    34917128 \
                                rustc-1.74.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  429a217951de970e409409dbce30019c924f8673 \
                                sha256  b0dfc900515e1f69362a001c070a9076d948f18f44c6582895062b19933ba231 \
                                size    48861901 \
                                cargo-1.74.0+0-x86_64-macports-darwin9${extract.suffix} \
                                rmd160  cdfb1b5eba8df0e4629f10e0122387f5d3d21407 \
                                sha256  e3a440659113df80d1933736357c481ba37d9d65c73927c8a5d19e3dc969823e \
                                size    9241995 \
                                rust-std-1.74.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  81f1ddb318d19e3aada766ce1909b603dc4a49af \
                                sha256  203e9c2efce33be6b2d989410594c4386252ef16283575a7e7eeea86dd8df8db \
                                size    34599273 \
                                rustc-1.74.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  281fe865e84af51717b9cdb561067bc384d7dedb \
                                sha256  db1b95bf5d495249c7fc28fc354846620ee88f9450d388767816c7181d59d84b \
                                size    65663557 \
                                cargo-1.74.0+0-i686-macports-darwin9${extract.suffix} \
                                rmd160  eacf418b9e81d40eccd83bc2fdce7a7c374552c4 \
                                sha256  48c42cf18cfa4f54e15739f8771034cd16f4df85db563eaf3e17c4efbe9506cc \
                                size    9165373

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
        foreach arch [option configure.universal_archs] {
            lassign [rust_build.stage0_info ${arch}] stage0_version stage0_arch stage0_vendor stage0_os_version
            if { ${stage0_vendor} ne "" } {
                set binTag              ${stage0_version}-[option triplet.cpu.${stage0_arch}]-${stage0_vendor}-[option triplet.os]${stage0_os_version}
                distfiles-delete        ${component}-${binTag}${extract.suffix}:${stage0_vendor}_vendor
                distfiles-append        ${component}-${binTag}${extract.suffix}:${stage0_vendor}_vendor
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
proc rust_build.stage0_info {arch} {

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
    if { [option os.platform] eq "darwin" && [vercmp [option macosx_deployment_target] >= "10.12"] } {
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
    } elseif { [option os.platform] eq "darwin" && [vercmp [option macosx_deployment_target] >= "10.7"] } {
        if { ${building_stage0} } {
            # use `platforms` in rust-bootstap port to ensure upstream compiler runs
            return      [list ${stage0_version} "x86_64" "apple" ""]
        } else {
            # no upstream support; use MacPorts compiler
            return      [list ${stage0_version} ${arch} "macports" "11"]
        }
    } elseif { [option os.platform] eq "darwin" && [vercmp [option macosx_deployment_target] >= "10.6"] } {
        if { ${building_stage0} } {
            # use local port since it must be build without thread-local storage even of OS supports it
            return      [list [option rust_build.version] [option configure.build_arch] "" ""]
        } else {
            # no upstream support; use MacPorts compiler
            return      [list ${stage0_version} ${arch} "macports" "10"]
        }
    } elseif { [option os.platform] eq "darwin" && [vercmp [option macosx_deployment_target] >= "10.5"] } {
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
