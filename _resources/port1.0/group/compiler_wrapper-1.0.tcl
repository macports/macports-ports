# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Used to create wrapper compiler scripts on-demand
# Useful to enforce settings such as MacPorts compiler flags, legacysupport settings
# and ccache support for ports / portgroups / build systems for which the standard
# compiler flags do not work.

namespace eval compwrap { }

options compwrap.add_compiler_flags
default compwrap.add_compiler_flags yes

options compwrap.add_legacysupport_flags
default compwrap.add_legacysupport_flags yes

options compwrap.print_compiler_command
default compwrap.print_compiler_command no

options compwrap.compiler_pre_flags
default compwrap.compiler_pre_flags [list]

options compwrap.compiler_post_flags
default compwrap.compiler_post_flags [list]

options compwrap.compiler_args_forward
default compwrap.compiler_args_forward [list {\${@}}]

options compwrap.compilers_to_wrap
default compwrap.compilers_to_wrap [list cc objc cxx objcxx fc f77 f90]

options compwrap.ccache_supported_compilers
default compwrap.ccache_supported_compilers [list cc objc cxx objcxx]

# please remove when a86f95c has been in a released MacPorts version for at least two weeks
# see https://github.com/macports/macports-base/commit/a86f95c5ab86ee52c8fec2271e005591179731de
if {![info exists compiler.limit_flags]} {
    options compiler.limit_flags
    default compiler.limit_flags        no
}

proc compwrap::use_ccache {tag} {
    global prefix
    return [ expr [option configure.ccache] && \
                 [file exists ${prefix}/bin/ccache] && \
                 [lsearch -exact [option compwrap.ccache_supported_compilers] ${tag}] >= 0 ]
}

proc compwrap::get_ccache_dir {} {
    global portdbpath ccache_dir
    if {[info exists ccache_dir]} {
        return ${ccache_dir}
    } else {
        return [file join $portdbpath build .ccache]
    }
}

proc compwrap::comp_flags {tag} {
    switch ${tag} {
        cc      { set ftag "c" }
        f77     { set ftag "f" }
        default { set ftag ${tag} }
    }
    set flags "[get_canonical_archflags ${tag}]"
    if { [info exists configure.${ftag}flags] } {
        set flags "[option configure.${ftag}flags] ${flags}"
    } 
    return ${flags}
}

proc compwrap::wrapper_path {tag} {
    global prefix
    # Get the underlying compiler
    set comp [option configure.${tag}]
    # If not defined, or tag not in list of known compilers to wrap, just return
    if {${comp} eq "" || [lsearch -exact [option compwrap.compilers_to_wrap] ${tag}] < 0} {
        return ${comp}
    }
    # Return the path to the wrapper. Format is :-
    # <port workpath>/<compiler tag>/<path to underlying compiler>
    set comp [option workpath]/compwrap/${tag}${comp}
}

proc compwrap::create_wrapper {tag} {
    global prefix env

    # Get the underlying compiler
    set comp [option configure.${tag}]

    # Get the wrapper
    set wrapcomp [compwrap::wrapper_path ${tag}]
    if { ${wrapcomp} eq ${comp} } {
        return ${comp}
    }

    # Create the directory for the wrapper.
    set wrapdir [file dirname ${wrapcomp}]
    if {![file exists ${wrapdir}]} {
        xinstall -d ${wrapdir}
    }

    # Force recreate in case underlying compiler has changed
    file delete -force ${wrapcomp}

    # Basic option, to pass on all command line arguments
    set comp_opts [join [option compwrap.compiler_pre_flags]]
    append comp_opts " [join [option compwrap.compiler_args_forward]]"
    append comp_opts " [join [option compwrap.compiler_post_flags]]"

    # Add MP compiler flags ?
    if { [option compwrap.add_compiler_flags] } {
        # standard options
        set comp_opts "[compwrap::comp_flags ${tag}] ${comp_opts}"
        # isysroot
        if {[option configure.sdkroot] ne "" && \
                ![option compiler.limit_flags] && \
                [lsearch -exact [option compwrap.ccache_supported_compilers] ${tag}] >= 0 } {
            set comp_opts "-isysroot[option configure.sdkroot] ${comp_opts}"
        }
        # pipe
        if { [option configure.pipe] } {
            set comp_opts "-pipe ${comp_opts}"
        }
    }

    # Add legacy support env vars
    if { [option compwrap.add_legacysupport_flags] } {
        set comp_opts "\$\{MACPORTS_LEGACY_SUPPORT_CPPFLAGS\} ${comp_opts}"
    }

    # Prepend ccache launcher if active
    if { [compwrap::use_ccache ${tag}] } {
        set comp "${prefix}/bin/ccache ${comp}"
    }

    # Finally create the wrapper script
    ui_debug "Creating compiler wrapper ${wrapcomp}"
    set f [open ${wrapcomp} w 0755]
    puts ${f} "#!/bin/bash"
    # If ccache active make sure correct CCACHE_DIR is used as not all build systems
    # (looking at you Bazel) propagate this flag.
    if { [compwrap::use_ccache ${tag}] } {
        puts ${f} "export CCACHE_DIR=[compwrap::get_ccache_dir]"
    }
    puts ${f} "CMD=\"${comp} ${comp_opts}\""
    if {[option compwrap.print_compiler_command]} {
        puts ${f} "echo \${CMD}"
    }
    puts  ${f} "exec \${CMD}"
    close ${f}
    
    return ${wrapcomp}
}

# Set various env vars
proc compwrap::configure_envs {} {
    global prefix
    # Set some cmake env vars incase build uses cmake
    foreach tag [option compwrap.compilers_to_wrap] {
        # Check for compilers supported by ccache
        if {[compwrap::use_ccache ${tag}]} {
            foreach phase [list configure build destroot] {
                ${phase}.env-append CMAKE_[string toupper $tag]_COMPILER_LAUNCHER=${prefix}/bin/ccache
            }
        }
    }
}
port::register_callback compwrap::configure_envs
