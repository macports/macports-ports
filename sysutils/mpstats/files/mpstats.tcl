#! @PREFIX@/bin/port-tclsh
# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2011,2013 The MacPorts Project
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

set prefix "@PREFIX@"

package require json::write
package require macports
if {[catch {mportinit} result]} {
    puts stderr "Error: $result"
    exit 1
}

proc usage {} {
    ui_msg "Usage: $::argv0 \[submit|show\]"
}

##
# Reads the configuration from the statistics config file at $prefix/etc/macports/stats.conf and the
# UUID file $prefix/var/macports/stats-uiud. Stores the configured values in global variables.
# Currently, the following configuration variables are supported:
#  - stats_url The URL that will be used for POST submission of the statistics
#  - stats_id  The UUID of this MacPorts installation; to be read from the UUID file
# Prints an error message (but doesn't abort) if the UUID is empty.
proc read_config {} {
    global prefix stats_url stats_id
    set conf_path "${prefix}/etc/macports/@CONFNAME@.conf"
    if {[file isfile $conf_path]} {
        set fd [open $conf_path r]
        while {[gets $fd line] >= 0} {
            set optname [lindex $line 0]
            if {$optname eq "stats_url"} {
                set stats_url [lindex $line 1]
            }
        }
        close $fd
    }

    set uuid_path "${prefix}/var/macports/stats-uuid"
    if {[file isfile $uuid_path]} {
        set fd [open $uuid_path r]
        gets $fd stats_id
        close $fd
        if {[string length $stats_id] == 0} {
            ui_error "UUID file ${uuid_path} seems to be empty."
        }
    } else {
        ui_error "UUID file ${uuid_path} missing."
    }
}

# extraction of gcc version
proc getgccinfo {} {
    # Find gcc in path
    if {[catch {set gccpath [macports::binaryInPath "gcc"]}] != 0} {
        # Failed
        ui_msg "$::errorInfo"
        return none
    }

    # Call gcc -v - Note that output will be on stderr not stdout
    # This succeeds if catch returns nonzero
    if { [catch { exec $gccpath -v } gccinfo] == 0} {
        # Failed
        ui_msg "$::errorInfo"
        return none
    }

    # Extract version
    if {[regexp {gcc version ([0-9.]+)} $gccinfo - gcc_v] == 1} {
        # Set gcc version
        return $gcc_v
    } else {
        # ui_warn "gcc exists but could not read version information"
        # Don't warn since that's the default now that gcc -> clang
        return none
    }
}

# extraction of CommandLineTools version
proc getcltinfo {} {
    if {[file exists /usr/lib/libxcselect.dylib] || ${macports::os_major} >= 20} {
        set pkgname "CLTools_Executables"
    } else {
        # Mountain Lion (10.8) and below. Note that we prefer Xcode over CLT for <= 10.8
        set pkgname "DeveloperToolsCLI"
    }

    if {![catch {exec pkgutil --pkg-info=com.apple.pkg.${pkgname}} results]} {
        return [lindex $results 3]
    }

    return none
}

###### JSON Encoding helper procs ######

##
# Encode a port (from a portlist entry) as a JSON object
#
# @param port_info
#        the portinfo dict for the port to be encoded
# @returns
#        the given port, represented as JSON object with the keys name, version and variants, if
#        present
proc json_encode_port {port_info} {
    set port_info [dict filter $port_info script {key val} {
        expr {$val ne ""}
    }]
    return [json::write object-strings {*}$port_info]
}

##
# Encode portlist as a JSON array of port objects
#
# @param data
#        the list of ports to be encoded in JSON
# @returns
#        the given list of ports, encoded as JSON array of return values of json_encode_port
proc json_encode_portlist {portlist} {
    set portlist [lmap i $portlist {json_encode_port $i}]
    return [json::write array {*}$portlist]
}

##
# Encodes the collected statistics as JSON
#
# @param id
#        the statistics UUID for this installation
# @param os
#        dict holding statistics about the OS
# @param ports
#        dict holding statistics about the installed ports
# @returns
#        a JSON-encoded string in the format required by the statistics server ready for submission
proc json_encode_stats {id os ports} {
    return [json::write object \
            id [json::write string $id] \
            os [json::write object-strings {*}$os] \
            active_ports [json_encode_portlist [dict get $ports active]]]
}

##
# Helper proc to build a list of all installed ports
#
# @param active
#        "yes", if the proc should collect all active ports, any other string to cause the
#        collection of inactive ports
# @returns
#        a list of installed ports chosen according to the \a active parameter, where each entry is
#        the list representation of a Tcl array with the keys name, version, requested and variants.
#        The variants value is encoded using \c _variants_to_variations, the version entry has the form
#        "$version_$revision".
proc get_installed_ports {active} {
    if {$active} {
        set ilist [registry::entry installed]
    } else {
        set ilist [registry::entry search state imaged]
    }

    return [lmap i $ilist {
        list name [$i name] \
            version [$i version]_[$i revision] \
            requested [expr {[$i requested] ? "true" : ""}] \
            variants [macports::_variants_to_variations [$i variants]]
    }]
}

##
# The main entry point of mpstats.tcl. Collects and prints or submits statistics.
#
# @param subcommands
#        The list of commands to be executed by this proc. This list can either be empty, which will
#        cause printing a usage message, ["show"], which will diplay the JSON-encoded data to be
#        submitted, or ["submit"] to send the data to the configured statistics server.
# @returns
#        0 on success and a non-zero value on error
proc action_stats {subcommands} {
    # If no subcommand is given (subcommands is empty), or multiple
    # subcommands are given, print out usage message.
    set subcommands_len [llength $subcommands]
    if {$subcommands_len != 1} {
        if {$subcommands_len > 1} {
            ui_error "Please select only one subcommand."
        }
        usage
        return 1
    }

    global stats_url stats_id
    if {![info exists stats_url]} {
        ui_error "Configuration variable stats_url is not set"
        return 1
    }
    if {![info exists stats_id]} {
        ui_error "Configuration variable stats_id is not set"
        return 1
    }

    # Build dictionary of os information
    dict set os macports_version [macports::version]
    dict set os osx_version ${macports::macos_version_major}
    dict set os os_arch ${macports::os_arch}
    dict set os os_platform ${macports::os_platform}
    dict set os build_arch ${macports::build_arch}
    dict set os cxx_stdlib ${macports::cxx_stdlib}
    dict set os gcc_version [getgccinfo]
    dict set os xcode_version ${macports::xcodeversion}
    dict set os clt_version [getcltinfo]

    # Build dictionary of port information
    dict set ports active [get_installed_ports yes]

    # Get the subcommand
    set cmd [lindex $subcommands 0]
    # Use compact form for submission.
    if {$cmd eq "submit"} {
        json::write indented 0
    }

    set json [json_encode_stats $stats_id $os $ports]

    switch $cmd {
        submit {
            ui_notice "Submitting data to $stats_url ..."

            if {[catch {curl post "submission\[data\]=$json" $stats_url} value]} {
                ui_error "$::errorInfo"
                return 1
            }

            ui_notice "Success."
        }
        show {
            ui_notice "Would submit the following data to $stats_url:"
            ui_msg "$json"
        }
        default {
            puts "Unknown subcommand."
            usage
            return 1
        }
    }

   return 0
}

read_config
exit [action_stats $argv]
