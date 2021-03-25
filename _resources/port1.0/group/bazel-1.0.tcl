# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     bazel 1.0

PortGroup java 1.0

namespace eval bazel { }

options bazel.min_xcode
default bazel.min_xcode 10.2

options bazel.build_cmd
default bazel.build_cmd bazel

options bazel.build_cmd_opts
default bazel.build_cmd_opts {[bazel::get_cmd_opts]}

options bazel.build_opts
default bazel.build_opts {[bazel::get_build_opts]}

options bazel.build_target
default bazel.build_target ""

options bazel.post_build_cmd
default bazel.post_build_cmd ""

options bazel.version
default bazel.version "latest"

options bazel.max_idle_secs
default bazel.max_idle_secs 30

options bazel.max_cpu_fraction
default bazel.max_cpu_fraction 0.5

options bazel.max_ram_fraction
default bazel.max_ram_fraction 0.5

options bazel.limit_build_jobs
default bazel.limit_build_jobs yes

options bazel.extra_build_opts
default bazel.extra_build_opts ""

options bazel.clean_post_build
default bazel.clean_post_build yes

options bazel.configure_cmd
default bazel.configure_cmd ./configure

options bazel.configure_args
default bazel.configure_args ""

options bazel.configure_pre_args
default bazel.configure_pre_args ""

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
destroot.env-append  JAVA_HOME=${java.home}

proc bazel::set_dep { } {
    ui_debug "Defining bazel port dependency"
    if { [option bazel.version] eq "latest" } {
        depends_build-append port:bazel
    } else {
        depends_build-append port:bazel-[option bazel.version]
    }
}
port::register_callback bazel::set_dep

variant mkl description {Enable Intel Math Kernel Library support} { }
# Enable MKL by default on 10.12 and newer.
#if {${os.major} >= 16} {
#    default_variants-append +mkl
#}

variant native description {Build from source for best native platform support} {
    # Prevent precompiled binaries to let compilation optimise the library for the user processor
    archive_sites
}

proc bazel::get_base_arch {} {
    global configure.build_arch
    # Currently only supports intel
    if { ${configure.build_arch} eq "x86_64" } {
        return "-march=x86-64"
    }
    return ""
}

supported_archs  x86_64
if {![variant_isset native]} {
    set base_march [bazel::get_base_arch]
    configure.env-append CC_OPT_FLAGS=${base_march}
    build.env-append     CC_OPT_FLAGS=${base_march}
    destroot.env-append  CC_OPT_FLAGS=${base_march}
    notes "This version is built based on a base architecture for convenience,
           which may not be optimized for your system. To build a version
           customized for your machine, use the +native variant"
}

proc bazel::set_env {} {
    ui_debug "Setting Bazel Env"
    if { [bazel::use_mp_clang] } {
        configure.env-append BAZEL_USE_CPP_ONLY_TOOLCHAIN=1
        build.env-append     BAZEL_USE_CPP_ONLY_TOOLCHAIN=1
        destroot.env-append  BAZEL_USE_CPP_ONLY_TOOLCHAIN=1
    }
}
port::register_callback bazel::set_env

# Configure phase
proc bazel::set_configure {} {
    global configure.args configure.pre_args configure.cmd
    # Set arguments
    configure.args     [option bazel.configure_args]
    configure.pre_args [option bazel.configure_pre_args]
    # configure command
    configure.cmd [option bazel.configure_cmd]
    ui_debug "Defined Bazel configure command ${configure.cmd} ${configure.args} ${configure.pre_args}"
}
port::register_callback bazel::set_configure

# Patch configuration
pre-configure {
    # enforce correct build settings
    # note final / is because ${worksrcpath} is a sym-link
    foreach f [ exec find ${worksrcpath}/ -name ".bazelrc" -or -name "configure" -or -name "configure.py" -or -name "compile.sh" -or -name "*.tpl" -or -name "*.bzl" -or -name "CROSSTOOL" -or -name "configure.py" -or -name "MOCK_CROSSTOOL" ] {
        foreach cmd {ar nm strip libtool ld objdump} {
            reinplace -q "s|/usr/bin/${cmd}|${prefix}/bin/${cmd}|g"    ${f}
        }
        reinplace -q "s|/usr/bin/clang|\"${configure.cc}\"|g"          ${f}
        reinplace -q "s|\"clang\"|\"${configure.cc}\"|g"               ${f}
        reinplace -q "s| clang | ${configure.cc} |g"                   ${f}
        reinplace -q "s|/usr/local/include|${prefix}/include|g"        ${f}
        reinplace -q "s|std=c++0x|std=c++11|g"                         ${f}
        reinplace -q "s|std=c++1y|std=c++14|g"                         ${f}
        reinplace -q "s|std=c++1z|std=c++17|g"                         ${f}
        reinplace -q "s|define=PREFIX=/usr|define=PREFIX=${prefix}|g"  ${f}
    }
    # If not native build, make sure not used...
    if {![variant_isset native]} {
        set base_march [bazel::get_base_arch]
        foreach f [ exec find ${worksrcpath}/ -name "configure" -or -name "configure.py" -or -name "CMakeLists.txt" -or -name "Makefile" -or -name "*.sh" ] {
            reinplace -q "s|-march=native|${base_march}|g" ${f}
        }
    }
}

pre-build {
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
}

proc bazel::get_cmd_opts {} {
    global bazel.max_idle_secs workpath
    # Generate the bazel build command
    set bazel_cmd_opts "--max_idle_secs=${bazel.max_idle_secs} --output_user_root=${workpath}/bazel_build"
    ui_debug "Defined Bazel build command options ${bazel_cmd_opts}"
    return ${bazel_cmd_opts}
}

proc bazel::get_build_opts {} {
    global build.jobs configure.cc configure.cflags configure.cxxflags configure.ldflags
    global use_parallel_build bazel.limit_build_jobs
    # Bazel build options
    # See https://docs.bazel.build/versions/master/memory-saving-mode.html 
    set bazel_build_opts "--subcommands --compilation_mode=opt --verbose_failures --nouse_action_cache --discard_analysis_cache --notrack_incremental_state --nokeep_state_after_build "
    # Extra user defined build options
    set bazel_build_opts "${bazel_build_opts} [option bazel.extra_build_opts]"
    # Always disable as bazel sets build jobs differently
    use_parallel_build no
    # Limit bazel resource utilisation
    if { [option bazel.limit_build_jobs] } {
        # Limit the number of parallel jobs to the number of physical, not logical, cpus.
        # First current setting to ensure we would be reducing the current setting.
        set physicalcpus [sysctl hw.physicalcpu]
        if { ${build.jobs} > ${physicalcpus} } {
            build.jobs ${physicalcpus}
        }
        set bazel_build_opts "${bazel_build_opts} --jobs ${build.jobs}"
        if { [option bazel.max_ram_fraction] > 0 } {
            set bazel_build_opts "${bazel_build_opts} --local_ram_resources=HOST_RAM*[option bazel.max_ram_fraction]"
        }
        if { [option bazel.max_cpu_fraction] > 0 } {
            set bazel_build_opts "${bazel_build_opts} --local_cpu_resources=HOST_CPUS*[option bazel.max_cpu_fraction]"
        }
    }
    # hack to try and transfer MP c, c++ and ld options to bazel...
    foreach opt [list {*}${configure.cflags} ] {
        set bazel_build_opts "${bazel_build_opts} --conlyopt \"${opt}\""
    }
    foreach opt [list {*}${configure.cxxflags} ] {
        set bazel_build_opts "${bazel_build_opts} --cxxopt \"${opt}\""
    }
    foreach opt [list {*}${configure.ldflags} ] {
        set bazel_build_opts "${bazel_build_opts} --linkopt \"${opt}\""
    }
    if { [bazel::use_mp_clang] } {
        set bazel_build_opts "${bazel_build_opts} --action_env CC=${configure.cc}"
    }
    if {[variant_isset mkl]} {
        set bazel_build_opts "${bazel_build_opts} --config=mkl"
    }
    if {![variant_isset native]} {
        set base_march [bazel::get_base_arch]
        set bazel_build_opts "${bazel_build_opts} --copt=${base_march}"
    } else {
        set bazel_build_opts "${bazel_build_opts} --copt=-march=native"
    }
    ui_debug "Defined Bazel build options ${bazel_build_opts}"
    return ${bazel_build_opts}
}

proc bazel::configure_build {} {
    if { [option bazel.build_cmd] ne "" } {

        global bazel.build_cmd bazel.build_opts bazel.build_target
        global build.jobs build.cmd build.args build.post_args

        ui_debug "Configuring bazel build command and arguments"

        set bazel_build_env ""
        if { [bazel::use_mp_clang] } {
            set bazel_build_env "BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 ${bazel_build_env}"
        }
        if {![variant_isset native]} {
            set base_march [bazel::get_base_arch]
            set bazel_build_env "CC_OPT_FLAGS=${base_march} ${bazel_build_env}"
        }

        build.cmd       "${bazel_build_env} [option bazel.build_cmd] [option bazel.build_cmd_opts]"
        build.args      "[option bazel.build_opts]"
        build.post_args "[option bazel.build_target]"

        ui_debug "Bazel build command  : [option bazel.build_cmd]"
        ui_debug "Bazel build options  : [option bazel.build_cmd_opts] [option bazel.build_opts]"
        ui_debug "Bazel build target   : [option bazel.build_target]"
        ui_debug "Bazel post-build cmd : [option bazel.post_build_cmd]"

    }
}
port::register_callback bazel::configure_build

post-build {
    # Post build command
    system -W ${worksrcpath} "[option bazel.post_build_cmd]"
    # Clean up
    if { [option bazel.clean_post_build] } {
        system -W ${worksrcpath} "[option bazel.build_cmd] [option bazel.build_cmd_opts] clean"
    }
}
