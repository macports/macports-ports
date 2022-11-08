# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Usage:
# PortGroup     bazel 1.0

PortGroup java 1.0
PortGroup compiler_blacklist_versions 1.0
PortGroup legacysupport 1.1
PortGroup compiler_wrapper 1.0

namespace eval bazel { }

options bazel.version
default bazel.version "latest"

options bazel.min_xcode
default bazel.min_xcode 12.2

options bazel.build_cmd
default bazel.build_cmd {[bazel::get_bazel_executable]}

options bazel.build_cmd_opts
default bazel.build_cmd_opts {[bazel::get_cmd_opts]}

options bazel.build_opts
default bazel.build_opts {[bazel::get_build_opts]}

options bazel.build_target
default bazel.build_target ""

options bazel.run_bazel_fetch
default bazel.run_bazel_fetch yes

options bazel.post_build_cmd
default bazel.post_build_cmd ""

options bazel.max_idle_secs
default bazel.max_idle_secs 10

options bazel.max_cpu_fraction
default bazel.max_cpu_fraction 0.5

options bazel.max_ram_fraction
default bazel.max_ram_fraction 0.5

options bazel.limit_build_jobs
default bazel.limit_build_jobs yes

options bazel.extra_build_cmd_opts
default bazel.extra_build_cmd_opts ""

options bazel.extra_build_opts
default bazel.extra_build_opts ""

options bazel.configure_cmd
default bazel.configure_cmd ./configure

options bazel.configure_args
default bazel.configure_args ""

options bazel.configure_pre_args
default bazel.configure_pre_args ""

options bazel.cxx_standard
default bazel.cxx_standard 2014

options bazel.path
default bazel.path {}

options bazel.python_version
default bazel.python_version ""

options bazel.fix_wheel_deployment_target
default bazel.fix_wheel_deployment_target yes

proc bazel::add_to_envs { var } {
    foreach phase {configure build destroot} {
        ${phase}.env-append ${var}
    }
}

# Required java version
java.version         11+
# LTS JDK port to install if required java not found
java.fallback        openjdk11
# JDK only needed at build time, but java PG sets lib dependency so
# declare no conflict to allow redistribution of binaries.
license_noconflict   ${java.fallback}
# append to envs
bazel::add_to_envs   JAVA_HOME=${java.home}

# Always force the use of the un-versioned SDK
configure.sdk_version

# Require c++ standard
proc bazel::set_standards {} {
    global compiler.cxx_standard
    if { ${compiler.cxx_standard} < [option bazel.cxx_standard] } {
        compiler.cxx_standard [option bazel.cxx_standard]
    }
}
port::register_callback bazel::set_standards

proc bazel::use_mp_clang {} {
    global configure.compiler xcodeversion
    set is_mp_clang  [ expr { [ string match macports-clang-* ${configure.compiler} ] } ]
    set xcode_not_ok [ expr { ${xcodeversion} eq "none" || [ vercmp ${xcodeversion} [option bazel.min_xcode] ] < 0 } ]
    return [expr {${is_mp_clang} || ${xcode_not_ok}}]
}

# Xcode blacklist
if { [bazel::use_mp_clang] } {
    compiler.blacklist-append {clang}
}

proc bazel::get_bazel_name { } {
    if { [option bazel.version] eq "latest" } {
        return bazel
    } else {
        return bazel-[option bazel.version]
    }
}

proc bazel::get_bazel_executable { } {
    global prefix
    return ${prefix}/libexec/[bazel::get_bazel_name]/bin/bazel
}

proc bazel::get_bazel_build_area { } {
    global workpath
    return ${workpath}/bazel_build
}

proc bazel::set_dep { } {
    set bz_dep [bazel::get_bazel_name]
    ui_debug "Defining bazel dependency port:${bz_dep}"
    depends_build-append port:${bz_dep}
}
port::register_callback bazel::set_dep

variant native description {Build from source for best native platform support} {
    # Prevent precompiled binaries to let compilation optimise the library for the user processor
    archive_sites
}

proc bazel::get_base_arch {} {
    global configure.build_arch
    if { [variant_isset native] } {
        return "-march=native"
    } else {
        if { ${configure.build_arch} eq "x86_64" } {
            return "-march=x86-64"
        } elseif { ${configure.build_arch} eq "arm64" } {
            return "-march=armv8-a"
        }
    }
    return ""
}

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
    global prefix env
    ui_debug "Setting Bazel Env"
    # https://github.com/bazelbuild/bazel/issues/2852
    bazel::add_to_envs BAZEL_SH=/bin/bash
    # patch PATH
    bazel.path-append [option prefix]/libexec/[bazel::get_bazel_name]/bin
    bazel::add_to_envs PATH=[string map {" " ":"} [option bazel.path]]:$env(PATH)
     # ccache dir
    if { [option configure.ccache] } {
        bazel::add_to_envs CCACHE_DIR=[compwrap::get_ccache_dir]
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

post-extract {
    if { [option bazel.python_version] ne "" } {
        # Make sure selected python version is found via PATH as python and python3
        global workpath prefix
        set py_ver       [option bazel.python_version]
        set py_ver_nodot [string map {. {}} ${py_ver}]
        depends_build-append port:python${py_ver_nodot}
        xinstall -d ${workpath}/bin
        ln -s ${prefix}/bin/python${py_ver} ${workpath}/bin/python
        ln -s ${prefix}/bin/python${py_ver} ${workpath}/bin/python3
        bazel.path-append ${workpath}/bin
    }
}

# Patch configuration
pre-configure {
    # enforce correct build settings
    set cc  [compwrap::wrap_compiler cc]
    set cxx [compwrap::wrap_compiler cxx]
    # Patch the checked out source
    # note final / is because ${worksrcpath} is a sym-link
    foreach f [ exec find ${worksrcpath}/ -name ".bazelrc" -or -name "configure" -or -name "configure.py" \
                    -or -name "compile.sh" -or -name "*.tpl" -or -name "*.bzl" -or -name "CROSSTOOL" \
                    -or -name "configure.py" -or -name "MOCK_CROSSTOOL" ] {
        foreach cmd {ar nm strip libtool ld objdump} {
            reinplace -q "s|/usr/bin/${cmd}|${prefix}/bin/${cmd}|g"    ${f}
        }
        reinplace -q "s|/usr/bin/clang++|\"${cc}\"|g"                  ${f}
        reinplace -q "s|/usr/bin/clang|\"${cc}\"|g"                    ${f}
        reinplace -q "s|\"clang++\"|\"${cxx}\"|g"                      ${f}
        reinplace -q "s| clang++ | ${cxx} |g"                          ${f}
        reinplace -q "s|\"clang\"|\"${cc}\"|g"                         ${f}
        reinplace -q "s| clang | ${cc} |g"                             ${f}
        reinplace -q "s|/usr/local/include|${prefix}/include|g"        ${f}
        reinplace -q "s|std=c++0x|std=c++11|g"                         ${f}
        reinplace -q "s|std=c++1y|std=c++14|g"                         ${f}
        reinplace -q "s|std=c++1z|std=c++17|g"                         ${f}
        reinplace -q "s|define=PREFIX=/usr|define=PREFIX=${prefix}|g"  ${f}
    }
    # If not native build, make sure not used...
    if {![variant_isset native]} {
        set base_march [bazel::get_base_arch]
        foreach f [ exec find ${worksrcpath}/ -name "configure" -or -name "configure.py" \
                        -or -name "CMakeLists.txt" -or -name "Makefile" -or -name "*.sh" ] {
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
    if { [option bazel.run_bazel_fetch] && [option bazel.build_cmd] ne "" && [file exists ${worksrcpath}] } {
        set cc  [compwrap::wrap_compiler cc]
        set cxx [compwrap::wrap_compiler cxx]
        # Run fetch
        set addpath [string map {" " ":"} [option bazel.path]]
        system -W ${worksrcpath} "PATH=${addpath}:$env(PATH) [bazel::get_build_env] [option bazel.build_cmd] [option bazel.build_cmd_opts] fetch [option bazel.build_target]"
        # Patch the bazel clang wrapper script to use MacPorts compiler selection and support ccache
        foreach f [ exec find [bazel::get_bazel_build_area] -name "wrapped_clang.cc" ] {
            # Switch to selected compiler
            reinplace -q "s|\"clang++\"|\"${cxx}\"|g"  ${f}
            reinplace -q "s|\"clang\"|\"${cc}\"|g"     ${f}
            # Bazel **really** doesn't want you changing stuff ;)
            # https://stackoverflow.com/questions/47775668/bazel-how-to-skip-corrupt-installation-on-centos6
            system "touch -m -t 210012120101 ${f}"
        }
    }
}

post-build {
    # Post build command
    system -W ${worksrcpath} "[option bazel.post_build_cmd]"
}

pre-destroot {
    if { [option bazel.fix_wheel_deployment_target] } {
        # https://trac.macports.org/ticket/60834
        # bazel sets the deployment target to the SDK version, which then causes
        # issues on systems where the SDK version is newer than the OS version, as pip
        # then refuses to install the wheel with (e.g. on macOS 10.12 with a 10.13 SDK)
        # ERROR: tensorflow-2.5.0-cp39-cp39-macosx_10_13_x86_64.whl is not a supported wheel on this platform.
        # The following renames the whl file the OS requirement set to the correct deployment target
        foreach f [ exec find ${workpath}/ -name "*.whl" ] {
            if { [regexp {(1[0-9]_\d{1,2})} ${f} -> whlver]} {
                set newver [string map {. _} $macosx_deployment_target]
                set newf   [string map "$whlver $newver" ${f}]
                if { ${f} ne ${newf} } {
                    ui_debug "Renaming ${f} -> ${newf}"
                    file rename ${f} ${newf}
                }
            }
        }
    }
}

proc bazel::get_cmd_opts {} {
    global bazel.max_idle_secs
    # Generate the bazel build command
    set bazel_cmd_opts "--max_idle_secs=${bazel.max_idle_secs} --output_user_root=[bazel::get_bazel_build_area]"
    # Extra user defined options
    set bazel_cmd_opts "${bazel_cmd_opts} [option bazel.extra_build_cmd_opts]"
    ui_debug "Defined Bazel build command options ${bazel_cmd_opts}"
    return ${bazel_cmd_opts}
}

proc bazel::get_build_opts {} {
    global build.jobs configure.cc configure.cxx configure.cflags configure.cxxflags configure.ldflags
    global use_parallel_build bazel.limit_build_jobs workpath
    # Bazel build options
    # See https://docs.bazel.build/versions/master/memory-saving-mode.html 
    set bazel_build_opts "--compilation_mode=opt --verbose_failures --nouse_action_cache --discard_analysis_cache --notrack_incremental_state --nokeep_state_after_build "
    # For very (very) verbose logging
    set bazel_build_opts "--subcommands ${bazel_build_opts}"
    # Extra user defined build options
    set bazel_build_opts "${bazel_build_opts} [option bazel.extra_build_opts]"
    # Always disable as bazel sets build jobs differently
    set cache_n_jobs ${build.jobs}
    use_parallel_build no
    # Limit bazel resource utilisation
    if { [option bazel.limit_build_jobs] } {
        # Limit the number of parallel jobs to the number of physical, not logical, cpus.
        # First current setting to ensure we would be reducing the current setting.
        if { ![catch {sysctl hw.physicalcpu} physicalcpus] } {
            if { ${cache_n_jobs} > ${physicalcpus} } {
                set cache_n_jobs ${physicalcpus}
            }
        }
        set bazel_build_opts "${bazel_build_opts} --jobs ${cache_n_jobs}"
        if { [option bazel.max_ram_fraction] > 0 } {
            set bazel_build_opts "${bazel_build_opts} --local_ram_resources=HOST_RAM*[option bazel.max_ram_fraction]"
        }
        if { [option bazel.max_cpu_fraction] > 0 } {
            set bazel_build_opts "${bazel_build_opts} --local_cpu_resources=HOST_CPUS*[option bazel.max_cpu_fraction]"
        }
    }
    build.jobs ${cache_n_jobs}
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
    set bazel_build_opts "${bazel_build_opts} --copt=[bazel::get_base_arch]"
    if { [option configure.ccache] } {
        set bazel_build_opts "${bazel_build_opts} --action_env CCACHE_DIR=[compwrap::get_ccache_dir]"
    }
    ui_debug "Defined Bazel build options ${bazel_build_opts}"
    return ${bazel_build_opts}
}

proc bazel::get_build_env { } {
    set bazel_build_env "BAZEL_SH=/bin/bash CC_OPT_FLAGS=[bazel::get_base_arch]"
    if { [option configure.ccache] } {
        set bazel_build_env "CCACHE_DIR=[compwrap::get_ccache_dir] ${bazel_build_env}"
    }
    return ${bazel_build_env}
}

proc bazel::configure_build {} {
    if { [option bazel.build_cmd] ne "" } {

        global bazel.build_cmd bazel.build_opts bazel.build_target
        global build.jobs build.cmd build.args build.post_args

        set bazel_build_env [bazel::get_build_env]
        
        build.cmd       "${bazel_build_env} [option bazel.build_cmd] [option bazel.build_cmd_opts]"
        build.args      "[option bazel.build_opts]"
        build.post_args "[option bazel.build_target]"

        ui_debug "Bazel build environ  : ${bazel_build_env}"
        ui_debug "Bazel build command  : [option bazel.build_cmd]"
        ui_debug "Bazel build options  : [option bazel.build_cmd_opts] [option bazel.build_opts]"
        ui_debug "Bazel build target   : [option bazel.build_target]"
        ui_debug "Bazel post-build cmd : [option bazel.post_build_cmd]"

    }
}
port::register_callback bazel::configure_build
