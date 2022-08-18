# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

#===================================================================================================
#
# Portgroup to simplify declaration of stub ports/subports
#
#---------------------------------------------------------------------------------------------------
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
#   * license           - default: Permissive
#   * maintainers       - default: nomaintainer
#   * homepage          - default: empty
#
# PG Options:
#   * stub.subport_name - override subport name, for README location
#   * stub.noarch       - designate as noarch; default: false
#   * stub.libs         - whether subport, and/or deps, install libs; default: true
#
#===================================================================================================

namespace eval stub {}

options stub.subport_name
default stub.subport_name ${subport}

# Designate whether stub is noarch
options stub.noarch
default stub.noarch false

# Designate whether stub, and/or deps, install libs
options stub.libs
default stub.libs true

proc stub::destroot {} {
    global destroot prefix

    set subport_name [option stub.subport_name]
    set docdir ${destroot}${prefix}/share/doc/${subport_name}
    xinstall -d ${docdir}
    system "echo ${subport_name} is a stub port > ${docdir}/README"
}

proc stub::setup_stub {} {
    global PortInfo

    if { ![info exists PortInfo(maintainers)] } {
        maintainers     nomaintainer
    }

    if { ![info exists PortInfo(homepage)] } {
        homepage
    }

    if { ![info exists PortInfo(license)] || ${PortInfo(license)} eq "unknown" } {
        license         Permissive
    }

    set stub_noarch [option stub.noarch]
    ui_debug "stub.noarch: ${stub_noarch}"
    if { ${stub_noarch} } {
        supported_archs noarch
    }

    set stub_libs [option stub.libs]
    ui_debug "stub.libs: ${stub_libs}"
    installs_libs ${stub_libs}

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
