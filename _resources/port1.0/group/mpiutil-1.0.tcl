# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

#==============================================================================
# This PortGroup provides shared logic, and helpers, for our MPI ports.
#==============================================================================

proc mpiutil_add_compiler_depends_lib {cname} {
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

