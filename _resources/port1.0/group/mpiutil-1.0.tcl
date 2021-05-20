# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

#==============================================================================
# This PortGroup provides shared logic, and helpers, for our MPI ports.
#==============================================================================

proc mpiutil_add_subports {name subport clist clist_unsupported clist_obsolete} {
    foreach key [dict keys ${clist}] {
        mpiutil_add_subport \
            ${name} ${subport} ${key}
    }

    foreach key ${clist_unsupported} {
        mpiutil_add_subport \
            ${name} ${subport} ${key}
    }

    foreach key ${clist_obsolete} {
        mpiutil_add_subport \
            ${name} ${subport} ${key}
    }
}

proc mpiutil_add_subport {name subport key} {
    subport ${name}-${key} {}
    # TODO: Remove all traces of -devel on or after Janurary 2022
    subport ${name}-devel-${key} {
        PortGroup       obsolete 1.0

        known_fail      yes
        distfiles
        pre-fetch {
            error "${subport} is currently broken"
        }
        replaced_by ${name}-${key}
    }
}

proc mpiutil_validate_subport {name subport cname clist clist_unsupported clist_obsolete} {
    global os.platform os.major
    global configure.compiler compiler.command_line_tools_version

    set subport_enabled no
    if {${cname} in ${clist_unsupported}} {
        known_fail  yes
        pre-fetch {
            error "${subport} is not supported on ${os.platform} ${os.major}"
        }
        append long_description " Note: ${subport} not supported on ${os.platform} ${os.major}."
    } elseif {${cname} in ${clist_obsolete}} {
        PortGroup   obsolete 1.0

        known_fail  yes
        pre-fetch {
            error "${subport} is obsolete"
        }

        if {[string match "clang*" ${cname}]} {
            replaced_by ${name}-clang90
        } else {
            replaced_by ${name}-gcc7
        }

        append long_description " Note: ${subport} is obsolete."
    } elseif {${subport} ne ${name}} {
        set subport_enabled yes

        if {${cname} eq "default"} {
            if {${configure.compiler} eq "clang"} {
                set compiler_version [compiler.command_line_tools_version ${configure.compiler}]
                if {[vercmp 421.11.66 ${compiler_version}] <= 0 && [vercmp ${compiler_version} 425.0.24] < 0} {
                    # Linker for Apple clang version 421.11.66 segfaults
                    # See https://trac.macports.org/ticket/36654#comment:9
                    known_fail yes
                    pre-fetch {
                        ui_error "${subport} fails on OS ${os.major} with compiler\
                            ${configure.compiler}, version ${compiler_version}"
                        return -code error "incompatible macOS version"
                    }

                    set subport_enabled no
                }
            }
        }
    }

    return ${subport_enabled}
}

proc mpiutil_add_depends_build {subport cname} {
    global os.major

    if {${os.major} <= 12} {
        # For gcc builds on MacOS 10.8 and earlier, add clang-90 as a build
        # dependency. This provides a modern version of 'as', allowing the port
        # to build successfully.
        if {[string match "gcc*" ${cname}]} {
            ui_debug "mpiutil_add_depends_build: adding clang90 build dependency for gcc build"
            depends_build-append \
                port:clang-9.0
        }
    }
}

proc mpiutil_add_compiler_depends_lib {subport cname} {
    set cport_name ""

    # As we are making wrappers, we depend on the compilers to exist.
    # Add them to depends_lib, not just depends_build.
    if {[regexp {clang[3-9]\d} ${cname}] == 1} {
        # Ports for Clang versions < 10 are named: clang-<major>.<minor>
        set cport_name          [regsub {(\d)(\d)} ${cname} {-\1.\2}]
    } elseif {[regexp {clang\d\d} ${cname}] == 1} {
        # Ports for Clang version >= 10 are named: clang-<major><minor>
        set cport_name          [regsub {(\d)(\d)} ${cname} {-\1\2}]
    } elseif {([regexp {gcc\d} ${cname}] == 1) || ([regexp {gcc\d\d} ${cname}] == 1)} {
        # Ports for GCC have names exactly matching our subports, so use as-is
        set cport_name          ${cname}
    }

    if {${cport_name} ne ""} {
        ui_debug "mpiutil_add_compiler_depends_lib: Adding compiler to depends_lib: ${cport_name}"
        depends_lib-append      port:${cport_name}
    } else {
        ui_debug "mpiutil_add_compiler_depends_lib: Not adding compiler to depends_lib; cname: ${cname}"
    }

    return 0
}

proc mpiutil_set_binary_eligibility {subport cname} {
    if {[lsearch -exact {mp llvm clang} ${cname}] != -1} {
        # Force local builds with Xcode-provided compilers (avoid issues with
        # different Xcode versions on buildbot and user machines)
        ui_debug "mpiutil_set_binary_eligibility: Disabling binary use for subport: ${subport}"
        archive_sites
    } else {
        ui_debug "mpiutil_set_binary_eligibility: Not disabling binary use for subport: ${subport}"
    }

    return 0
}

