# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup implements the "conflicts_build" option, which lets ports
# specify that they would fail to build properly if certain other ports are
# installed at configure, build and/or destroot time. This is in contrast to
# the MacPorts built-in "conflicts" option, which is for indicating activation-
# time conflicts (i.e. ports that install files in the same locations).
#
# Ideally the conflicts_build option should be integrated into MacPorts base
# instead of being a PortGroup.


# conflicts_build: the list of ports with which this port conflicts at
# configure, build and/or destroot time.
options conflicts_build
default conflicts_build {}


proc conflicts_build._check_for_conflicting_ports {} {
    global conflicts_build subport
    foreach badport ${conflicts_build} {
        if {![catch "registry_active ${badport}"]} {
            if {${subport} eq ${badport}} {
                ui_error "${subport} cannot be built while another version of ${badport} is active."
                ui_error "Please forcibly deactivate the existing copy of ${badport}, e.g. by running:"
                ui_error ""
                ui_error "    sudo port -f deactivate ${badport}"
                ui_error ""
                ui_error "Then try again."
            } else {
                ui_error "${subport} cannot be built while ${badport} is active."
                ui_error "Please forcibly deactivate ${badport}, e.g. by running:"
                ui_error ""
                ui_error "    sudo port -f deactivate ${badport}"
                ui_error ""
                ui_error "Then try again. You can reactivate ${badport} again later."
            }
            return -code error "${badport} is active"
        }
    }
}

pre-configure {
    conflicts_build._check_for_conflicting_ports
}

pre-build {
    conflicts_build._check_for_conflicting_ports
}

pre-destroot {
    conflicts_build._check_for_conflicting_ports
}
