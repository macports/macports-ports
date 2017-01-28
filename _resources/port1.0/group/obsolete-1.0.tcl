# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2012 Markus Weissmann <mww@macports.org>
# Copyright (c) 2012-2013, 2015-2016 The MacPorts Project
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
# 3. Neither the name of Apple Computer, Inc. nor the names of its
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
# Usage:
#
#   replaced_by         name-of-port-that-deprecated-this-port
#   PortGroup           obsolete 1.0

# set a number of reasonable defaults for a port that is only there to
# inform users that they should uninstall it and install something else
# instead; you might want to override some of the defaults though.

platforms       darwin
maintainers     nomaintainer
supported_archs noarch

if {[info exists replaced_by]} {
    description     Obsolete port, replaced by ${replaced_by}
    default long_description "This port has been replaced by ${replaced_by}."
} else {
    description     Obsolete port
    default long_description "This port is obsolete."
}

homepage        https://www.macports.org/

archive_sites
patchfiles
distfiles
depends_build
depends_extract
depends_fetch
depends_lib
depends_run
#depends_test

pre-configure {
    if {[info exists replaced_by]} {
        ui_error "${subport} has been replaced by ${replaced_by};\
                please install that instead."
    } else {
        ui_error "${subport} is obsolete; please uninstall it."
    }
    return -code error "obsolete port"
}

livecheck.type  none
