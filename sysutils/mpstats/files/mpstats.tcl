#!/bin/sh
# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# \
if type -fp port-tclsh >/dev/null; then exec port-tclsh "$0" "$@"; else exec /usr/bin/tclsh "$0" "$@"; fi
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

if {[file exists ${prefix}/share/macports/Tcl/macports1.0/macports_fastload.tcl]} {
    if {[catch {source ${prefix}/share/macports/Tcl/macports1.0/macports_fastload.tcl} result]} {
        puts stderr "Error: $result"
        exit 1
    }
}

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
    set conf_path "${prefix}/etc/macports/stats.conf"
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

###### JSON Encoding helper procs ######

##
# Return JSON encoding of a flat "key":"value" dictionary
#
# @param data
#        the variable name of the dict to encode
# @param indent
#        an optional indentation string that will be printed at the start of each new line
# @returns
#        the given dict, as JSON-formatted string
proc json_encode_dict {data {indent ""}} {
    upvar 1 $data db

    set size [dict size $db]
    set i 1

    # Initialize the JSON string string
    set json "\{"

    dict for {key values} $db {
        set line "\n${indent}  \"$key\": \"[dict get $db $key]\""

        # Check if there are any subsequent items
        if {$i < $size} {
            append line ","
        }

        # Add line to the JSON string
        append json $line

        incr i
    }

    if {$size > 0} {
        append json "\n${indent}"
    }
    append json "\}"

    return $json
}

##
# Encodes a list of strings as a JSON array
#
# @param data
#        the list to be encoded in JSON
# @param indent
#        an optional indentation string that will be printed at the start of each new line
# @returns
#        the given list, as JSON-formatted string
proc json_encode_list {data {indent ""}} {
    set size [llength $data]
    set i 1

    set json "\["

    foreach item $data {
        append json "\n  "
        append json $data

        # Check if there are any subsequent items
        if {$i < $size} {
            append json ","
        }

        incr i
    }

    if {$size > 0} {
        append json "\n${indent}"
    }
    append json "\]"

    return $json
}

##
# Encode a port (from a portlist entry) as a JSON object
#
# @param data
#        the name of the portinfo variable for the port to be encoded
# @param indent
#        an optional indentation string that will be printed at the start of each new line
# @returns
#        the given port, represented as JSON object with the keys name, version and variants, if
#        present
proc json_encode_port {port_info {indent ""}} {
    upvar 1 $port_info port

    set first true

    set json "\{"
    foreach name {name version variants} {
        # Skip empty strings
        if {$port($name) eq ""} {
            continue
        }

        # Prepend a comma if this isn't the first item that has been processed
        if {!$first} {
            # Add a comma
            append json ", "
        } else {
            set first false
        }

        # Format the entry as "name_string":"value"
        append json "\"$name\": \"$port($name)\""
    }

    append json "\}"

    return $json
}

##
# Encode portlist as a JSON array of port objects
#
# @param data
#        the list of ports to be encoded in JSON
# @param indent
#        an optional indentation string that will be printed at the start of each new line
# @returns
#        the given list of ports, encoded as JSON array of return values of json_encode_port
proc json_encode_portlist {portlist {indent ""}} {
    set json "\["
    set first true

    foreach i $portlist {
        array set port $i

        set encoded [json_encode_port port "${indent}  "]

        # Prepend a comma if this isn't the first item that has been processed
        if {!$first} {
            # Add a comma
            append json ","
        } else {
            set first false
        }

        # Append encoded json object
        append json "\n${indent}  ${encoded}"
    }

    if {!$first} {
        append json "\n${indent}"
    }
    append json "\]"

    return $json
}

##
# Encodes the collected statistics as JSON
#
# @param id
#        the statistics UUID for this installation
# @param os_dict
#        the variable name of the dict holding statistics about the OS
# @param ports_dict
#        the variable name of the dict holding statistics about the installed ports
# @returns
#        a JSON-encoded string in the format required by the statistics server ready for submission
proc json_encode_stats {id os_dict ports_dict} {
    upvar 1 $os_dict os
    upvar 1 $ports_dict ports

    set os_json [json_encode_dict os]
    set active_ports_json [json_encode_portlist [dict get $ports "active"]]
    set inactive_ports_json [json_encode_portlist [dict get $ports "inactive"]]

    set json "\{"
    append json "\n  \"id\": \"$id\","
    append json "\n  \"os\": [json_encode_dict os "  "],"
    append json "\n  \"active_ports\": [json_encode_portlist [dict get $ports "active"] "  "],"
    append json "\n  \"inactive_ports\": [json_encode_portlist [dict get $ports "inactive"] "  "]"
    append json "\n\}"

    return $json
}

##
# Helper proc to encode the variants list in a canonical way
#
# @param variants
#        the string of all variants for any given port
# @returns
#        a Tcl array object converted to a list where the keys are variant names and the values
#        are either + or -, depending on whether the variant was selected, or not.
proc split_variants {variants} {
    set result {}
    set l [regexp -all -inline -- {([-+])([[:alpha:]_]+[\w\.]*)} $variants]
    foreach {match sign variant} $l {
        lappend result $variant $sign
    }
    return $result
}

##
# Helper proc to build a list of all installed ports
#
# @param active
#        "yes", if the proc should collect all active ports, any other string to cause the
#        collection of inactive ports
# @returns
#        a list of installed ports chosen according to the \a active parameter, where each entry is
#        the list representation of a Tcl array with the keys name, version and variants. The
#        variants value is encoded using \c split_variants, the version entry has the form
#        "$version_$revision".
proc get_installed_ports {active} {
    set ilist {}
    if {[catch {set ilist [registry::installed]} result]} {
        if {$result ne "Registry error: No ports registered as installed."} {
            ui_debug "$::errorInfo"
            return -code error "registry::installed failed: $result"
        }
    }

    set results {}
    foreach i $ilist {
        set iactive [lindex $i 4]

        if {(${active} eq "yes") == (${iactive} != 0)} {
            set iname [lindex $i 0]
            set iversion [lindex $i 1]
            set irevision [lindex $i 2]
            set ivariants [split_variants [lindex $i 3]]
            lappend results [list name $iname version "${iversion}_${irevision}" variants $ivariants]
        }
    }

    return $results
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
    global stats_url stats_id

    # If no subcommands are given (subcommands is empty) print out usage message
    if {[llength $subcommands] == 0} {
        usage
        return 1
    }

    # Build dictionary of os information
    dict set os macports_version [macports::version]
    dict set os osx_version ${macports::macosx_version}
    dict set os os_arch ${macports::os_arch}
    dict set os os_platform ${macports::os_platform}
    dict set os build_arch ${macports::build_arch}
    dict set os gcc_version [getgccinfo]
    dict set os xcode_version ${macports::xcodeversion}

    # Build dictionary of port information
    dict set ports active   [get_installed_ports yes]
    dict set ports inactive [get_installed_ports no]

    # Make sure there aren't too many subcommands
    if {[llength $subcommands] > 1} {
        ui_error "Please select only one subcommand."
        usage
        return 1
    }

    if {![info exists stats_url]} {
        ui_error "Configuration variable stats_url is not set"
        return 1
    }
    if {![info exists stats_id]} {
        ui_error "Configuration variable stats_id is not set"
        return 1
    }

    set json [json_encode_stats $stats_id os ports]

    # Get the subcommand
    set cmd [lindex $subcommands 0]

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
