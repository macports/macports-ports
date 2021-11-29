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

options compwrap.append_arch_flags
default compwrap.append_arch_flags no

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
    if { ![option compwrap.append_arch_flags] ||
         [catch {get_canonical_archflags ${tag}} flags] } {
        set flags [join ""]
    }
    global configure.${ftag}flags
    if { [info exists configure.${ftag}flags] } {
        append flags " [join [option configure.${ftag}flags]]"
    }
    return ${flags}
}

proc compwrap::wrapped_command_path {tag origpath} {
    # Some ports append compiler flags to the compiler 'commands'
    # Remove this here to only use the first argument, the compiler path
    set csplit [split ${origpath} { }]
    set strippath [lindex ${csplit} 0]
    # Return the path to the wrapper. Format is :-
    # <port workpath>/<compiler tag>/<path to underlying compiler>
    return [option workpath]/compwrap/${tag}${strippath}
}

proc compwrap::wrapped_compiler_path {tag} {
    # Get the underlying compiler
    set comp [option configure.${tag}]
    # If not defined, or tag not in list of known compilers to wrap, just return
    if {${comp} eq "" || [lsearch -exact [option compwrap.compilers_to_wrap] ${tag}] < 0} {
        return ${comp}
    }
    return [compwrap::wrapped_command_path ${tag} ${comp}]
}

proc compwrap::wrap_compiler {tag} {
    global prefix env

    # Get the underlying compiler
    set comp [option configure.${tag}]

    # Get the wrapper path
    set wrapcomp [compwrap::wrapped_compiler_path ${tag}]
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
    ui_debug "compiler_wrapper: Creating ${wrapcomp}"

    # The list of compiler flags to construct
    set comp_opts [list]

    # Add MP compiler flags ?
    if { [option compwrap.add_compiler_flags] } {
        # standard options
        set flag [compwrap::comp_flags ${tag}]
        ui_debug "compiler_wrapper:  -> Comp Flags: Will embed '${flag}' in ${tag} wrapper script"
        append comp_opts " ${flag}"
        # isysroot
        if {[option configure.sdkroot] ne "" && \
                ![option compiler.limit_flags] && \
                [lsearch -exact [option compwrap.ccache_supported_compilers] ${tag}] >= 0 } {
            set sdk -isysroot[option configure.sdkroot]
            ui_debug "compiler_wrapper:  -> SDK: Will embed '${sdk}' in ${tag} wrapper script"
            append comp_opts " ${sdk}"
        }
        # pipe
        if { [option configure.pipe] } {
            ui_debug "compiler_wrapper:  -> Will embed -pipe in ${tag} wrapper script"
            append comp_opts " -pipe"
        }
    }

    # Add legacy support env vars
    if { [option compwrap.add_legacysupport_flags] } {
        ui_debug "compiler_wrapper:  -> Will embed legacysupport flags in ${tag} wrapper script"
        append comp_opts " \$\{MACPORTS_LEGACY_SUPPORT_CPPFLAGS\}"
    }

    # Basic option, to pass on all command line arguments
    if { [llength [option compwrap.compiler_pre_flags]] > 0 } {
        ui_debug "compiler_wrapper:  -> Pre Flags: Will embed '[option compwrap.compiler_pre_flags]' in ${tag} wrapper script"
        append comp_opts " [join [option compwrap.compiler_pre_flags]]"
    }
    append comp_opts " \"[join [option compwrap.compiler_args_forward]]\""
    if { [llength [option compwrap.compiler_post_flags]] > 0 } {
        ui_debug "compiler_wrapper:  -> Post Flags: Will embed '[option compwrap.compiler_post_flags]' in ${tag} wrapper script"
        append comp_opts " [join [option compwrap.compiler_post_flags]]"
    }

    # Prepend ccache launcher if active
    if { [compwrap::use_ccache ${tag}] } {
        ui_debug "compiler_wrapper:  -> Will use ccache compiler launcher in ${tag} wrapper script"
        set comp "${prefix}/bin/ccache ${comp}"
    }

    # Finally create the wrapper script
    set f [open ${wrapcomp} w 0755]
    puts ${f} "#!/bin/bash"
    # If ccache active make sure correct CCACHE_DIR is used as not all build systems
    # (looking at you Bazel) propagate this flag.
    if { [compwrap::use_ccache ${tag}] } {
        puts ${f} "export CCACHE_DIR=[compwrap::get_ccache_dir]"
    }
    if {[option compwrap.print_compiler_command]} {
        puts ${f} "echo ${comp} ${comp_opts}"
    }
    puts ${f} "exec ${comp} ${comp_opts}"
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
