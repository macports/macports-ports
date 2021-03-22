# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     bazel 1.0

PortGroup java 1.0

namespace eval bazel { }

options bazel.min_xcode
default bazel.min_xcode 10.2

options bazel.build_target
default bazel.build_target ""

options bazel.post_build_cmd
default bazel.post_build_cmd ""

options bazel.version
default bazel.version "latest"

proc bazel::use_mp_clang {} {
    global configure.compiler xcodeversion
    return [ expr ( [ string match macports-clang-* ${configure.compiler} ] || [ vercmp ${xcodeversion} [option bazel.min_xcode] ] < 0 ) ]
}

# Required java version
java.version        11+
# LTS JDK port to install if required java not found
java.fallback       openjdk11
# JDK only needed at build time, but java PG sets lib dependency so
# declare no conflict to allow redistribution of binaries.
license_noconflict  ${java.fallback}
# append to envs
configure.env-append JAVA_HOME=${java.home}
build.env-append     JAVA_HOME=${java.home}
build.env-append     TMPDIR=${workpath}/tmp

proc set_bazel_dep { } {
    if { [option bazel.version] eq "latest" } {
        depends_build-append port:bazel
    } else {
        depends_build-append port:bazel-[option bazel.version]
    }
}
port::register_callback set_bazel_dep

variant mkl description {Enable Intel Math Kernel Library support} { }
# Enable MKL by default on 10.12 and newer.
#if {${os.major} >= 16} {
#    default_variants-append +mkl
#}

variant native description {Build from source for best native platform support} {
    # Prevent precompiled binaries to let compilation optimise the library for the user processor
    archive_sites
}

proc get_base_arch {} {
    global configure.build_arch
    # Currently only supports intel
    if { ${configure.build_arch} eq "x86_64" } {
        return "-march=x86-64"
    }
    return ""
}

supported_archs  x86_64
if {![variant_isset native]} {
    set base_march [get_base_arch]
    configure.env-append CC_OPT_FLAGS=${base_march}
    build.env-append     CC_OPT_FLAGS=${base_march}
    notes "This version is built based on a base architecture for convenience,
           which may not be optimized for your system. To build a version
           customized for your machine, use the +native variant"
}

proc bazel_set_env {} {
    if { [bazel::use_mp_clang] } {
        configure.env-append BAZEL_USE_CPP_ONLY_TOOLCHAIN=1
        build.env-append     BAZEL_USE_CPP_ONLY_TOOLCHAIN=1
    }
}
port::register_callback bazel_set_env

# Configure phase
# Remove all arguments
configure.args
configure.pre_args
# configure command
configure.cmd ./configure
# Patch configuration
pre-configure {
    # enforce correct build settings
    # note final / is because ${worksrcpath} is a sym-link
    foreach f [ exec find ${worksrcpath}/ -name "configure" -or -name "configure.py" -or -name "compile.sh" -or -name "*.tpl" -or -name "*.bzl" -or -name "CROSSTOOL" -or -name "configure.py" -or -name "MOCK_CROSSTOOL" ] {
        foreach cmd {ar nm strip libtool ld objdump} {
            reinplace -q "s|/usr/bin/${cmd}|${prefix}/bin/${cmd}|g" ${f}
        }
        reinplace -q "s|/usr/bin/clang|\"${configure.cc}\"|g"   ${f}
        reinplace -q "s|\"clang\"|\"${configure.cc}\"|g"        ${f}
        reinplace -q "s| clang | ${configure.cc} |g"            ${f}
        reinplace -q "s|/usr/local/include|${prefix}/include|g" ${f}
        reinplace -q "s|std=c++0x|std=c++11|g"                  ${f}
        reinplace -q "s|std=c++1y|std=c++14|g"                  ${f}
        reinplace -q "s|std=c++1z|std=c++17|g"                  ${f}
    }
    # If not native build, make sure not used...
    if {![variant_isset native]} {
        set base_march [get_base_arch]
        foreach f [ exec find ${worksrcpath}/ -name "configure" -or -name "configure.py" -or -name "CMakeLists.txt" -or -name "Makefile" -or -name "*.sh" ] {
            reinplace -q "s|-march=native|${base_march}|g" ${f}
        }
    }
}

# Limit the number of parallel jobs to the number of physical, not logical, cpus.
# First current setting to ensure we would be reducing the current setting.
set physicalcpus [sysctl hw.physicalcpu]
if { ${build.jobs} > ${physicalcpus} } {
    build.jobs ${physicalcpus}
}

build {
    
    # bazel cannot build if gcc is 'port selected'
    # https://trac.macports.org/ticket/58569
    # https://trac.macports.org/ticket/58679
    # Until it can be figured out how to stop bazel finding and using macports gcc
    # just detect when this situation arises and error out...
    if { [file exists ${prefix}/bin/gcc] } {
        ui_error "${subport} cannot be built with 'port select gcc' active."
        ui_error "Please run 'sudo port select gcc none' and try again."
        ui_error "Once the build is complete, you can safely re-select your preferred gcc."
        return -code error "build error"
    }
    # Build using the wonderful bazel build system ...
    set bazel_cmd "bazel --max_idle_secs=60 --output_user_root=${workpath}"
    set bazel_build_opts "-s -c opt --verbose_failures --config=opt"
    # Limit bazel resource utilisation
    set bazel_build_opts "${bazel_build_opts} --jobs ${build.jobs} --local_ram_resources=HOST_RAM*0.5 --local_cpu_resources=HOST_CPUS*.5"
    # Explicitly pass SDK https://github.com/bazelbuild/rules_go/issues/1554
    # Check versioned SDK actually exists... https://trac.macports.org/ticket/60317
    # Disable but keep the code below commented for reference, for now, as need to see how it plays out
    # See https://trac.macports.org/ticket/62474
    #if {[string first ${configure.sdk_version} ${configure.sdkroot}] != -1} {
    #    set bazel_build_opts "${bazel_build_opts} --macos_sdk_version=${configure.sdk_version}"
    #} else {
    #    ui_warn "configure.sdkroot='${configure.sdkroot}' does not match configure.sdk_version='${configure.sdk_version}'"
    #}
    # hack to try and transfer MP c, c++ and ld options to bazel...
    foreach opt [list {*}${configure.cflags} ] {
        set bazel_build_opts "${bazel_build_opts} --conlyopt '${opt}'"
    }
    foreach opt [list {*}${configure.cxxflags} ] {
        set bazel_build_opts "${bazel_build_opts} --cxxopt '${opt}'"
    }
    foreach opt [list {*}${configure.ldflags} ] {
        set bazel_build_opts "${bazel_build_opts} --linkopt '${opt}'"
    }
    if { [bazel::use_mp_clang] } {
        set bazel_build_opts "${bazel_build_opts} --action_env CC=${configure.cc}"
        set bazel_cmd "BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 ${bazel_cmd}"
    }
    if {[variant_isset mkl]} {
        set bazel_build_opts "${bazel_build_opts} --config=mkl"
    }
    if {![variant_isset native]} {
        set base_march [get_base_arch]
        set bazel_build_opts "${bazel_build_opts} --copt=${base_march}"
        set bazel_cmd "CC_OPT_FLAGS=${base_march} ${bazel_cmd}"
    }
    ui_debug "Bazel build command : ${bazel_cmd}"
    ui_debug "Bazel build options : ${bazel_build_opts}"
    ui_debug "Bazel build target  : [option bazel.build_target]"
    # Run the build
    system -W ${worksrcpath} "${bazel_cmd} build ${bazel_build_opts} [option bazel.build_target]"
    # Post build command
    system -W ${worksrcpath} "[option bazel.post_build_cmd]"
    # Clean up
    system -W ${worksrcpath} "${bazel_cmd} clean"
}
