# $Id$
# 
# Copyright (c) 2009 The MacPorts Project
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
# This PortGroup checks that the architecture(s) of the given files match
# the architecture(s) we are trying to install this port as now. This is
# a crutch to get us by until a proper solution is implemented in base.
# See #20728.
# 
# Usage:
# 
#   PortGroup               archcheck 1.0
#   archcheck.files         file1 file2 ...
#
# Files can (and probably usually should) be specified relative to ${prefix}.

options archcheck.files
default archcheck.files {}

pre-configure {
    if {[variant_exists universal] && [variant_isset universal]} {
        set requested_archs ${configure.universal_archs}
    } else {
        set requested_archs ${configure.build_arch}
    }
    foreach file ${archcheck.files} {
        # Prepend prefix if necessary.
        if {"/" != [string index ${file} 0]} {
            set file [file join ${prefix} ${file}]
        }
        
        # Make sure the file exists -- there have been cases where dylibs are
        # inexplicably absent (e.g. #23057).
        if {![file exists ${file}]} {
            ui_error "The file ${file} does not exist, though it was"
            ui_error "expected to have been provided by one of ${name}'s dependencies. Try"
            ui_error "rebuilding the port that should have provided that file by running"
            ui_error ""
            ui_error "    sudo port -n upgrade --force <portname>"
            ui_error ""
            return -code error "missing required file"
        }
        
        set file_archs [string trim [strsed [exec lipo -info ${file}] {s/.*://}]]
        set file_archs [string map {ppc7400 ppc ppc7450 ppc} ${file_archs}]

        foreach requested_arch ${requested_archs} {
            if {-1 == [string first " ${requested_arch} " " ${file_archs} "]} {
                set dependency [strsed [exec ${prefix}/bin/port provides ${file} 2>/dev/null] {s/.*: //}]
                ui_error "You cannot install ${name} for the architecture(s) ${requested_archs} because"
                ui_error "its dependency ${dependency} only contains the architecture(s) ${file_archs}."
                # Dependency is not universal?
                if {1 == [llength ${file_archs}]} {
                    # Trying to install this port either universal or for non-default arch?
                    if {([variant_exists universal] && [variant_isset universal]) || (${build_arch} != ${configure.build_arch})} {
                        ui_error ""
                        ui_error "Try rebuilding ${dependency} (and all its dependencies) with"
                        ui_error "the +universal variant by running"
                        ui_error ""
                        ui_error "    sudo port upgrade --enforce-variants ${dependency} +universal"
                        ui_error ""
                    # Dependency's arch is not the default arch? User has likely upgraded
                    # from Leopard to Snow Leopard and has not reinstalled all ports.
                    } elseif {${file_archs} != ${build_arch}} {
                        ui_error ""
                        ui_error "Did you upgrade to a new version of Mac OS X? If so, please see"
                        ui_error ""
                        ui_error "    http://trac.macports.org/wiki/Migration"
                        ui_error ""
                    }
                }
                return -code error "incompatible architectures in dependencies"
            }
        }
    }
}
