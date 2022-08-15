# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

#==============================================================================
#
# Portgroup to simplify declaration of stub ports/subports
#
#------------------------------------------------------------------------------
#
# Usage:
#   PortGroup           stub 1.0
#
#   name                my_name
#   version             my_version
#   revision            my_revision
#   categories          my_category
#   description         my_description
#   long_description    my_long_description
#
# Optional Declarations:
#   * license     - default: Permissive
#   * maintainers - default: nomaintainer
#   * homepage    - default: empty
#
# Options:
#   * stub.subport_name - override subport name, for README location
#   * stub.lib_dep      - allow subport to be used as lib dep; default: true
#
#------------------------------------------------------------------------------
#
# If there's a desire to install another port by default, include a lib
# dependency for that:
#
#   depends_lib-append  port:default_port_to_install
#
#==============================================================================

namespace eval stub {}

options stub.subport_name
default stub.subport_name ${subport}

# Designate whether stub is intended to be used as a lib dep.
# If not, set 'supported_archs noarch' and 'installs_libs no'.
options stub.lib_dep
default stub.lib_dep true

proc stub::destroot {} {
    global destroot prefix

    set subport_name [option stub.subport_name]
    set docdir ${destroot}${prefix}/share/doc/${subport_name}
    xinstall -d ${docdir}
    system "echo ${subport_name} is a stub port > ${docdir}/README"
}

proc stub::setup_stub {} {
    global PortInfo

    if {![info exists PortInfo(maintainers)]} {
        maintainers     nomaintainer
    }

    if {![info exists PortInfo(homepage)]} {
        homepage
    }

    if {![info exists PortInfo(license)] || ${PortInfo(license)} eq "unknown"} {
        license         Permissive
    }

    if {[option stub.lib_dep]} {
        ui_debug "stub::setup_stub: lib_dep: yes"
    } else {
        ui_debug "stub::setup_stub: lib_dep: no; mark noarch; set installs_libs no"
        supported_archs noarch
        installs_libs   no
    }

    distfiles
    patchfiles
    use_configure       no
    build {}
}

destroot {
    stub::destroot
}

# callback after port is parsed
port::register_callback stub::setup_stub
