# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Usage:
#
#   PortGroup           obsolete 1.0
#   replaced_by         name-of-port-that-deprecated-this-port

# set a number of reasonable defaults for a port that is only there to
# inform users that they should uninstall it and install something else
# instead; you might want to override some of the defaults though.

proc obsolete.set_descriptions {replaced_by} {
    if {${replaced_by} eq ""} {
        description         Obsolete port
        long_description    This port is obsolete.
    } else {
        description         Obsolete port, replaced by ${replaced_by}
        long_description    This port has been replaced by ${replaced_by}.
    }

    default platforms       darwin
    default maintainers     nomaintainer
    default homepage        https://www.macports.org

    archive_sites
    patchfiles
    distfiles
    depends_build
    depends_extract
    depends_fetch
    depends_lib
    depends_patch
    depends_run
    depends_test

    supported_archs         noarch
    livecheck.type          none
}

# Handle replaced_by set after portgroup inclusion.
option_proc replaced_by obsolete.replaced_by_proc
proc obsolete.replaced_by_proc {option action args} {
    switch ${action} {
        set -
        delete {
            obsolete.set_descriptions ${args}
        }
    }
}

# Handle replaced_by set before portgroup inclusion.
if {[info exists replaced_by]} {
    obsolete.set_descriptions ${replaced_by}
} else {
    obsolete.set_descriptions ""
}

pre-configure {
    if {[info exists replaced_by]} {
        ui_error "${subport} has been replaced by ${replaced_by};\
                please install that instead."
    } else {
        ui_error "${subport} is obsolete; please uninstall it."
    }
    return -code error "obsolete port"
}
