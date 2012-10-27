# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2012 The MacPorts Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of The MacPorts Project nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
# This PortGroup implements the "conflicts_build" option, which lets ports
# specify that they would fail to build properly if certain other ports are
# installed at configuration or build time. This is in contrast to the
# MacPorts built-in "conflicts" option, which is for indicating activation-
# time conflicts (i.e. ports that install files in the same locations).
#
# Ideally the conflicts_build option should be integrated into MacPorts base
# instead of being a PortGroup.


# conflicts_build: the list of ports with which this port conflicts at
# configuration or build time.
options conflicts_build
default conflicts_build {}


proc conflicts_build._check_for_conflicting_ports {} {
    global conflicts_build subport
    foreach badport ${conflicts_build} {
        if {![catch "registry_active ${badport}"]} {
            if {${subport} == ${badport}} {
                ui_error "${subport} cannot be built while another version of ${badport} is active."
                ui_error "Please deactivate the existing copy of ${badport} and try again."
            } else {
                ui_error "${subport} cannot be built while ${badport} is active."
                ui_error "Please deactivate ${badport} and try again."
                ui_error "You can reactivate ${badport} again later."
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
