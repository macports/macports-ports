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
default compwrap.compiler_pre_flags {{}}

options compwrap.compiler_post_flags
default compwrap.compiler_post_flags {{}}

options compwrap.compiler_args_forward
default compwrap.compiler_args_forward {{\$\{\@\}}}

proc compwrap::use_ccache {tag} {
    global prefix
    return [ expr [option configure.ccache] && \
                 [file exists ${prefix}/bin/ccache] && \
                 [lsearch -exact [compwrap::known_fortran_compiler_tags] ${tag}] < 0 ]
}

proc compwrap::get_ccache_dir {} {
    global portdbpath ccache_dir
    if {[info exists ccache_dir]} {
        return ${ccache_dir}
    } else {
        return [file join $portdbpath build .ccache]
    }
}

proc compwrap::known_compiler_tags {} {
    return [list cc objc cxx objcxx fc f77 f90]
}

proc compwrap::known_fortran_compiler_tags {} {
    return [list fc f77 f90]
}

proc compwrap::trim {c} {
    if { [string range [option $c] 0 0] eq "\{" } {
        return [string range [option $c] 1 end-1 ]
    } else {
        return [option $c]
    }
}

proc compwrap::create_wrapper {tag} {
    global prefix

    # Get the underlying compiler
    set comp [option configure.${tag}]
    # If not defined, or tag not in list of known compilers to wrap, just return
    if {${comp} eq "" || [lsearch -exact [compwrap::known_compiler_tags] ${tag}] < 0} {
        return ${comp}
    }
    
    set wrapdir [option workpath]/compwrap/${tag}[file dirname ${comp}]
    if {![file exists ${wrapdir}]} {
        xinstall -d ${wrapdir}
    }

    switch ${tag} {
        cc      { set ftag "c" }
        default { set ftag ${tag} }
    }
    
    # Wrapper name, based on original
    set fname ${wrapdir}/[file tail ${comp}]
    
    # Force recreate in case underlying compiler has changed
    file delete -force ${fname}

    # Basic option, to pass on all command line arguments
    set comp_opts "[trim compwrap.compiler_pre_flags] [trim compwrap.compiler_args_forward] [trim compwrap.compiler_post_flags]"
    # Add MacPorts compiler flags ?
    if { [option compwrap.add_compiler_flags] } {
        set comp_opts "[option configure.${ftag}flags] [get_canonical_archflags ${tag}] ${comp_opts}"
    }
    # Add legacy support env vars
    if { [option compwrap.add_legacysupport_flags] } {
        set comp_opts "\$\{MACPORTS_LEGACY_SUPPORT_CPPFLAGS\} ${comp_opts}"
    }
    # Append ccache if active
    if { [compwrap::use_ccache ${tag}] } {
        set comp "${prefix}/bin/ccache ${comp}"
    }
    ui_debug "Creating compiler wrapper ${fname}"
    set f [open ${fname} w 0755]
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
    
    return ${fname}
}

proc compwrap::get_compiler {tag} {
    set comp [option configure.${tag}]
    if {[option configure.ccache]} {
        set comp [compwrap::create_wrapper ${tag}]
    }
    return ${comp}
}

# Set various env vars
proc compwrap::configure_envs {} {
    global prefix
    # Set some cmake env vars incase build uses cmake
    foreach tag [compwrap::known_compiler_tags] {
        if {[compwrap::use_ccache ${tag}]} {
            switch ${tag} {
                fc {
                    set ctag Fortran
                }
                f77 {
                    set ctag Fortran
                }
                f90 {
                    set ctag Fortran
                }
                default {
                    set ctag [string toupper $tag]
                }
            }
            foreach phase [list configure build destroot] {
                ${phase}.env-append CMAKE_${ctag}_COMPILER_LAUNCHER=${prefix}/bin/ccache
            }
        }
    }
}
port::register_callback compwrap::configure_envs
