# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

#==============================================================================
#
# Portgroup to simplify declaration of stub ports/subports
#
#------------------------------------------------------------------------------
#
# Usage:
#   PortGroup stub 1.0
#
#   name                my_name
#   version             my_version
#   revision            my_revision
#   categories          my_category
#   description         my_description
#   long_description    my_long_description
#
# Optional Declarations:
#   * maintainers - defaults to 'none'
#
#------------------------------------------------------------------------------
#
# If there's a desire to install another port by default, include a lib
# dependency for that:
#
#   depends_lib-append  port:default_port_to_install
# 
# Similarly, the homepage can also be specified, if desired:
#
#   homepage            https://my-homepage-here
#
#------------------------------------------------------------------------------
#
# Options:
#   * stub.subport_name - override subport name, for README location
#
#==============================================================================

namespace eval stub {}

options stub.subport_name
default stub.subport_name ${subport}

platforms           darwin
license             none

# For maintainers and homepage, don't overwrite if already set

if {![info exists PortInfo(maintainers)]} {
    maintainers     nomaintainer
}

if {![info exists PortInfo(homepage)]} {
    homepage
}

distfiles
patchfiles
supported_archs     noarch
use_configure       no

build {}

proc stub::destroot {} {
    global destroot prefix

    set subport_name [option stub.subport_name]
    set docdir ${destroot}${prefix}/share/doc/${subport_name}
    xinstall -d ${docdir}
    system "echo ${subport_name} is a stub port > ${docdir}/README"
}

destroot {
    stub::destroot
}

