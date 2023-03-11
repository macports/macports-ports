# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Group code for Makefile based ports
# Usage:
#
#   PortGroup        makefile 1.0
#
# This PortGroup attempts to set the variables used by the Makefiles.
# A variables can be set (in order of precedence):
#     * by an explicit override assignment in the Makefile,
#     * with a command argument,
#     * by an explicit assignment in the Makefile, or
#     * from an environment variable.
# See https://www.gnu.org/software/make/manual/make.html#Values for details.
#
# makefile.override:
#     variable names to be set as command arguments (if configure.variable exists)
#
# makefile.has_destdir:
#     Makefile supports DESTDIR=... (yes/no)
#
# makefile.prefix_name:
#     variable name used to set the prefix
#
# muniversal.arch_tools
#     extra compiler tools whose values (e.g., MPICXX) must have
#     -arch flags set by the muniversal PG
#

PortGroup compiler_wrapper      1.0
# By default (for this PG), do not embedded compiler flags in wrappers
default compwrap.add_compiler_flags     no

options makefile.override
default makefile.override       {CC CXX OBJC OBJCXX FC F77 F90 JAVAC PERL PYTHON RUBY INSTALL AWK BISON PKG_CONFIG}

options makefile.has_destdir
default makefile.has_destdir    yes

options makefile.prefix_name
default makefile.prefix_name    PREFIX

options muniversal.arch_tools
default muniversal.arch_tools   {}

default use_configure           no
default universal_variant       yes

namespace eval makefile_pg      {}

# utility procedure to map tool name to appropriate variable name
proc makefile_pg::map_tool_to_environment_variable {tool} {
    switch -- ${tool} {
        cc {
            return CFLAGS
        }
        f77 {
            return FFLAGS
        }
        default {
            return [string toupper $tool]FLAGS
        }
    }
}

proc makefile_pg::setup_phase {phase} {
    global makefile.override os.platform os.major prefix destroot
    #########################################################################################
    # in base code, variables are set in the procedure command_exec in portutil.tcl
    # see https://github.com/macports/macports-base/blob/master/src/port1.0/portutil.tcl
    #########################################################################################
    if {[lsearch -exact ${makefile.override} MACOSX_DEPLOYMENT_TARGET] != -1 && [option macosx_deployment_target] ne ""} {
        ${phase}.args-append        MACOSX_DEPLOYMENT_TARGET=[option macosx_deployment_target]
    }
    if {[option compiler.log_verbose_output]} {
        if {[lsearch -exact ${makefile.override} CC_PRINT_OPTIONS] != -1} {
            ${phase}.args-append    CC_PRINT_OPTIONS=YES
        }
        if {[lsearch -exact ${makefile.override} CC_PRINT_OPTIONS_FILE] != -1} {
            ${phase}.args-append    CC_PRINT_OPTIONS_FILE=[file join [option workpath] ".CC_PRINT_OPTIONS"]
        }
    }
    if {[lsearch -exact ${makefile.override} CPATH] != -1 && [option compiler.cpath] ne ""} {
        ${phase}.args-append        CPATH=[join [option compiler.cpath] :]
    }
    if {[lsearch -exact ${makefile.override} LIBRARY_PATH] != -1 && [option compiler.library_path] ne ""} {
        ${phase}.args-append        LIBRARY_PATH=[join [option compiler.library_path] :]
    }
    if {[lsearch -exact ${makefile.override} DEVELOPER_DIR] != -1 && [option configure.developer_dir] ne ""} {
        ${phase}.args-append        DEVELOPER_DIR=[option configure.developer_dir]
    }
    if {[lsearch -exact ${makefile.override} SDKROOT] != -1 && [option configure.sdkroot] ne ""} {
        ${phase}.args-append        SDKROOT=[option configure.sdkroot]
    }

    #########################################################################################
    # attempt to set PREFIX variable
    #########################################################################################
    if {${phase} ne "destroot" || [option makefile.has_destdir]} {
        set makefile_prefix         ${prefix}
    } else {
        # use \$(DESTDIR) instead of ${destroot} in case muniversal PG is being used
        set makefile_prefix         \$(DESTDIR)${prefix}
    }
    if {[lsearch -exact ${makefile.override} PREFIX] != -1} {
        ${phase}.args-append        [option makefile.prefix_name]=[shellescape ${makefile_prefix}]
    }
    ${phase}.env-append             [option makefile.prefix_name]=${makefile_prefix}

    #########################################################################################
    # replicate behavior in procedure portconfigure::configure_main
    # see https://github.com/macports/macports-base/blob/master/src/port1.0/portconfigure.tcl
    # see  https://lists.macports.org/pipermail/macports-dev/2018-November/thread.html#39694
    #########################################################################################
    if {[option configure.sdkroot] ne "" && ![option compiler.limit_flags]} {
        foreach env_var {CPPFLAGS CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS} {
            configure.[string tolower ${env_var}]-append "-isysroot[option configure.sdkroot]"
        }
        configure.ldflags-append "-Wl,-syslibroot,[option configure.sdkroot]"
    }

    if {[exists muniversal.architectures]} {
        # muniversal 1.1 PG is being used
        foreach arch [option muniversal.architectures] {
            foreach tool {cc cxx objc objcxx ld} {
                set env_var [makefile_pg::map_tool_to_environment_variable $tool]
                if {[lsearch -exact ${makefile.override} ${env_var}] == -1} {
                    # Portfile requests that variable be set in the environment
                    # append arch flag to compiler name instead
                    set env_var [string toupper ${tool}]
                }
                ${phase}.args.${arch}-append    ${env_var}+="[muniversal::get_archflag ${tool} ${arch}]"
            }
            foreach tool {f77 f90 fc} {
                set env_var [makefile_pg::map_tool_to_environment_variable $tool]
                if {[lsearch -exact ${makefile.override} ${env_var}] == -1} {
                    # Portfile requests that variable be set in the environment
                    # append arch flag to compiler name instead
                    set env_var [string toupper ${tool}]
                }
                ${phase}.args.${arch}-append    ${env_var}+="[muniversal::get_archflag ${tool} ${arch}]"
            }
            foreach tool [option muniversal.arch_tools] {
                if {[regexp {f90|F90|f77|F77|fort|FORT} ${tool}]} {
                    set arch_tool   fc
                } else {
                    set arch_tool   cc
                }
                ${phase}.args.${arch}-append    ${tool}+="[muniversal::get_archflag ${arch_tool} ${arch}]"
            }
            foreach tool {cc f77 cxx objc objcxx cpp f90 fc ld} {
                set env_var  [makefile_pg::map_tool_to_environment_variable $tool]
                set lenv_var [string tolower ${env_var}]
                if {[lsearch -exact ${makefile.override} ${env_var}] == -1} {
                    # Portfile requests that variable be set in the environment
                    # append flag to compiler name instead
                    set env_var [string toupper ${tool}]
                }
                if {[option configure.${lenv_var}.${arch}] ne ""} {
                    ${phase}.args.${arch}-append    ${env_var}+="[option configure.${lenv_var}.${arch}]"
                }
            }
        }
    } elseif {![exists universal_archs_supported] || ![variant_exists universal] || ![variant_isset universal]} {
        # muniversal PG 1.x is *not* being used
        foreach tool {cc f77 cxx objc objcxx cpp f90 fc ld} {
            if {[catch {get_canonical_archflags $tool} flags]} {
                continue
            }
            set env_var [makefile_pg::map_tool_to_environment_variable $tool]
            configure.[string tolower ${env_var}]-append {*}${flags}
        }
    } else {
        # muniversal PG 1.0 is being used
        global merger_${phase}_args
        foreach arch [option configure.universal_archs] {
            foreach tool {cc cxx objc objcxx ld} {
                set env_var [makefile_pg::map_tool_to_environment_variable $tool]
                if {[lsearch -exact ${makefile.override} ${env_var}] == -1} {
                    # Portfile requests that variable be set in the environment
                    # append arch flag to compiler name instead
                    set env_var [string toupper ${tool}]
                }
                lappend merger_${phase}_args(${arch}) ${env_var}+="[muniversal_get_arch_flag ${arch}]"
            }
            foreach tool {f77 f90 fc} {
                set env_var [makefile_pg::map_tool_to_environment_variable $tool]
                if {[lsearch -exact ${makefile.override} ${env_var}] == -1} {
                    # Portfile requests that variable be set in the environment
                    # append arch flag to compiler name instead
                    set env_var [string toupper ${tool}]
                }
                lappend merger_${phase}_args(${arch}) ${env_var}+="[muniversal_get_arch_flag ${arch} 'fortran']"
            }
            foreach tool [option muniversal.arch_tools] {
                if {[regexp {f90|F90|f77|F77|fort|FORT} ${tool}]} {
                    set is_fortran "fortran"
                } else {
                    set is_fortran ""
                }
                lappend merger_${phase}_args(${arch}) ${tool}+="[muniversal_get_arch_flag ${arch} ${is_fortran}]"
            }
            foreach tool {cc f77 cxx objc objcxx cpp f90 fc ld} {
                set env_var  [makefile_pg::map_tool_to_environment_variable $tool]
                set lenv_var [string tolower ${env_var}]
                if {[lsearch -exact ${makefile.override} ${env_var}] == -1} {
                    # Portfile requests that variable be set in the environment
                    # append arch flag to compiler name instead
                    set env_var [string toupper ${tool}]
                }
                global merger_configure_${lenv_var}
                if {[info exists  merger_configure_${lenv_var}(${arch})]} {
                    lappend merger_${phase}_args(${arch}) ${env_var}+="[set merger_configure_${lenv_var}(${arch})]"
                }
            }
        }
    }

    if {![variant_exists universal] || ![variant_isset universal]} {
        foreach env_var {CFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS FFLAGS F90FLAGS FCFLAGS LDFLAGS} {
            if {[option configure.march] ne ""} {
                configure.[string tolower ${env_var}]-append -march=[option configure.march]
            }
            if {[option configure.mtune] ne ""} {
                configure.[string tolower ${env_var}]-append -mtune=[option configure.mtune]
            }
        }
    }

    foreach env_var { \
                          CC CXX OBJC OBJCXX FC F77 F90 JAVAC \
                          CFLAGS CPPFLAGS CXXFLAGS OBJCFLAGS OBJCXXFLAGS \
                          FFLAGS F90FLAGS FCFLAGS LDFLAGS LIBS CLASSPATH \
                          PERL PYTHON RUBY INSTALL AWK BISON PKG_CONFIG \
                      } {
        set value [compwrap::wrap_compiler [string tolower $env_var]]
        if {$value ne ""} {
            ${phase}.env-append         "$env_var=$value"
            if {[lsearch -exact ${makefile.override} ${env_var}] != -1} {
                ${phase}.args-append    $env_var="$value"
            }
        }
    }

    foreach env_var { \
                          PKG_CONFIG_PATH \
                      } {
        set value [option configure.[string tolower $env_var]]
        if {$value ne ""} {
            ${phase}.env-append         "$env_var=[join $value :]"
            if {[lsearch -exact ${makefile.override} ${env_var}] != -1} {
                ${phase}.args-append    $env_var="[join $value :]"
            }
        }
    }

    if {${os.platform} eq "darwin" && ${os.major} == 12} {
        ${phase}.env-append         __CFPREFERENCES_AVOID_DAEMON=1
        if {[lsearch -exact ${makefile.override} __CFPREFERENCES_AVOID_DAEMON] != -1} {
            ${phase}.args-append    __CFPREFERENCES_AVOID_DAEMON=1
        }
    }
}

proc makefile_pg::makefile_setup {} {
    # `makefile_pg::setup_phase configure` intentionally not run.
    # makefile_pg::setup_phase essentially duplicates base code run during the configure phase.
    # Therefore, there is no reason to run it during the configure phase.
    # The duplicate code can even corrupt the environment variable PKG_CONFIG_PATH.
    pre-build {
        makefile_pg::setup_phase build
    }
    pre-destroot {
        makefile_pg::setup_phase destroot
    }
    pre-test {
        makefile_pg::setup_phase test
    }
}
port::register_callback makefile_pg::makefile_setup
