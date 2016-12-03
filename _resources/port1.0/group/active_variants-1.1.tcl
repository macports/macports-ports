# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2012-2015 The MacPorts Project
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
# Usage:
# PortGroup       active_variants 1.1
# if {![catch {set result [active_variants $depspec $required $forbidden]}]} {
#   if {$result} {
#     # code to be executed if $depspec is active with at least all variants in
#     # $required and none from $forbidden
#   } else {
#     # code to be executed if $depspec is active, but either not with all
#     # variants in $required or any variant in $forbidden
#   }
# } else {
#   # code to be executed if $depspec isn't active
# }
#
# where
#  $depspec
#    is the name of the port you're trying to check (required), which can be
#    specified as either just the port, or via "(bin|lib|path):FOO:port"
#    as accepted by the dependency parser.
#  $required
#    is a list of variants that must be enabled for the test to succeed
#    (required; remember this can also be a space-separated string or just
#    a string for a single value. It's interpreted as list, though.)
#  $forbidden
#    is a list of variants that may not be enabled for the test to succeed
#    (default is empty list, see description of $required for values that can be
#    interpreted as list by Tcl)
#
#
# In situations where you know that a version of the port is active (e.g., when
# checking in pre-configure of a port and the checked port is a dependency),
# this can be simplified to:
# if {[active_variants $depspec $required $forbidden]} {
#   # code to be run if $depspec is active with all from $required and none from
#   # $forbidden
# } else {
#   # code to be run if $depspec is active, but either not with all variants in
#   # $required or any variant in $forbidden
# }
#
# If all you want to do is bail out when the condition isn't fulfilled, there's
# a convenience wrapper available. If the condition isn't met it will print an
# error message and exit in a pre-configure phase. This can't be run any
# earlier, because not all dependency types are installed before configure
# phase. Previous versions of this PortGroup required you to manually put
# require_active_variants in a pre-configure block. This is now done
# automatically.
#
# require_active_variants $depspec $required $forbidden
#
# ChangeLog:
#  v1.1:
#   - require_active_variants no longer needs to be used in a pre-configure
#     phase manually, because it automatically wraps itself in pre-configure.
#   - the active_variants portgroup can now also deal with depspec-style
#     dependencies, e.g., require_active_variants path:foo/bar:standardport
#     variant

proc active_variants {depspec required {forbidden {}}} {
	# get the port which will provide $depspec; this allows us to support e.g.,
	# path-style dependencies. This comes from port1.0/portutil.tcl and should
	# probably not be considered public API.
	set port [_get_dep_port $depspec]
	if {$port eq ""} {
	    ui_error "active_variants: Error: invalid port depspec '${depspec}'"
	    ui_error "  expecting either: port or (bin|lib|path):foo:port"
	    return 0
	}
	if {$depspec ne $port} {
	    ui_debug "Checking $port for active variants for depspec '$depspec'"
	}

	# registry_active comes from a list of aliased procedures in
	# macports1.0/macports.tcl, line 1238 - 1303.
	#
	# It actually calls registry::active, which is defined in
	# registry2.0/registry.tcl, line 173 and does some error handling plus
	# passing the call to the appropriate registry backend (flat file or
	# sqlite).
	#
	# In the SQLite case the call goes to registry2.0/receipt_sqlite.tcl,
	# line 45, proc active, which in turn calls registry::entry installed
	# $port, which comes from registry2.0/entry.c, line 387. I won't dig
	# deeper than that, since that's as far as we need to go to handle this
	# correctly.
	#
	# When looking at registry2.0/receipt_sqlite.tcl, line 53 and following,
	# we can see the structure returned by this call: it's a list of
	# registry entries (in the case of active, there can only be one, since
	# there can never be multiple versions of the same port active at the
	# same time). This explains the [lindex $active_list 0] in the following
	# block.

	# this will throw if $port isn't active
	set installed [lindex [registry_active $port] 0]

	# In $installed there are in order: name, version, revision, variants,
	# a boolean indicating whether the port is installed and the epoch. So,
	# we're interested in the field at offset 3.
	set variants [lindex $installed 3]
	ui_debug "$port is installed with the following variants: $variants"
	ui_debug "  required: $required, forbidden: $forbidden"

	# split by "+" into the separate variant names
	set variant_list [split $variants +]

	# check that each required variant is there
	foreach required_variant $required {
		if {![_variant_in_variant_list $required_variant $variant_list]} {
			ui_debug "  rejected, because required variant $required_variant is missing"
			return 0
		}
	}

	# check that no forbidden variant is there
	foreach forbidden_variant $forbidden {
		if {[_variant_in_variant_list $forbidden_variant $variant_list]} {
			ui_debug "  rejected, because forbidden variant $forbidden_variant is present"
			return 0
		}
	}

	ui_debug "  accepted"
	return 1
}

proc _variant_in_variant_list {needle haystack} {
	foreach variant $haystack {
		if {$variant eq $needle} {
			return 1
		}
	}
	return 0
}

# global list holding all items should be checked for and cause an error if
# not present
set _require_active_variants_list [list]

proc require_active_variants {depspec required {forbidden {}}} {
	global _require_active_variants_list
	lappend _require_active_variants_list [list $depspec $required $forbidden]
}

# function to be called in pre-configure to check for all items added using
# require_active_variants
proc _check_require_active_variants {method} {
	global _require_active_variants_list PortInfo

	# build a list of all dependencies to be checked in this pass
	set depends {}
	set deptypes {}

	# determine the type of dependencies we need to consider
	switch $method {
		source {
			set deptypes "depends_fetch depends_extract depends_lib depends_build depends_run"
		}
	        activate -
	        archivefetch {
			set deptypes "depends_lib depends_run"
		}
		default {
			error "active_variants 1.1: internal error: _check_require_active_variants called with unsupported \$method"
		}
	}

	# for each type we're considering
	foreach deptype $deptypes {
		# check whether there are any dependencies of that type
		if {[info exists PortInfo($deptype)]} {
			# and for each dependency
			foreach depspec $PortInfo($deptype) {
				# resolve names to actual ports
				set depname [_get_dep_port $depspec]

				# if depname is empty the dependency is already satisfied (e.g.
				# with bin: dependencies)
				if {$depname ne ""} {
					# if the dependency isn't already in the list
					if {[lsearch -exact $depends $depname] == -1} {
						# append it
						lappend depends $depname
					}
				}
			}
		}
	}

	ui_debug "Active variants check for ${method}-type install considers ${deptypes}: ${depends}"

	foreach _require_active_variant $_require_active_variants_list {
		set depspec [lindex $_require_active_variant 0]
		set port [_get_dep_port $depspec]
		set required [lindex $_require_active_variant 1]
		set forbidden [lindex $_require_active_variant 2]

		if {[lsearch -exact $depends $port] == -1} {
			ui_debug "Ignoring active_variants requirement for ${port} because ${method}-type install only considers ${deptypes} and those do not contain ${port}"
			continue
		}

		if {[catch {set result [active_variants $depspec $required $forbidden]}] != 0} {
		    set message "${port} is required, but not active."
		    if {$method eq "activate"} {
			ui_msg "Warning: $message"
		    } else {
			error "$message"
		    }
		}
		if {!$result} {
			set str_required ""
			if {[llength $required] > 0} {
				set str_required "with +[join $required +]"
			}
			set str_forbidden ""
			if {[llength $forbidden] > 0} {
				set str_forbidden "without +[join $forbidden +]"
			}
			set str_combine ""
			if {$str_required ne "" && $str_forbidden ne ""} {
				set str_combine " and "
			}
		        set message "${port} must be installed ${str_required}${str_combine}${str_forbidden}."
		        if {$method eq "activate"} {
			    ui_msg "Warning: $message"
			} else {
			    error "$message"
			}
		}
	}
}

# register pre-configure handler that checks for all requested variants
pre-configure {
	_check_require_active_variants source
}

# register pre-archivefetch handler that checks for all requested variants
# this is required when downloading binary archives for a package, because
# pre-configure is never run for those
pre-archivefetch {
	_check_require_active_variants archivefetch
}

# be sure that a required variant was not changed since this port was built or fetched
pre-activate {
        _check_require_active_variants activate
}
