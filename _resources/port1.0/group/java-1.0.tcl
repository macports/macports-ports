# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2012 The MacPorts Project,
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

# Search for a good value for JAVA_HOME
proc find_java_home {} {
    set home_value ""

    # Default to any valid value that made it through the environment
    if { [info exists ::env(JAVA_HOME)] } {
        set val $::env(JAVA_HOME)
        if { [file isdirectory $val] } {
            set home_value $val
            ui_debug "Discovered JAVA_HOME via env: $home_value"
        }
    }

    # First, ask the system where java home is
    if { ![file isdirectory $home_value] && ![catch {set val [exec "/usr/libexec/java_home"]}] } {
        set home_value $val
        ui_debug "Discovered JAVA_HOME via /usr/libexec/java_home: $home_value"
    }

    # Fall back to more conventional way to find java home
    if { ![file isdirectory $home_value] } {
        foreach loc { "/System/Library/Frameworks/JavaVM.framework/Home" } {
            if { [file isdirectory $loc] } {
                set home_value $loc
                ui_debug "Discovered JAVA_HOME via search path: $home_value"
                break
            }
        }
    }

    # Warn user if we couldn't find a likely JAVA_HOME
    if { ![file isdirectory $home_value]} {
        ui_warn "No value for java JAVA_HOME was automatically discovered"
    }

    return $home_value
}

# Set the best value we can find for JAVA_HOME
set java_home [find_java_home]
configure.env-append   JAVA_HOME=${java_home}
build.env-append       JAVA_HOME=${java_home}
destroot.env-append    JAVA_HOME=${java_home}
