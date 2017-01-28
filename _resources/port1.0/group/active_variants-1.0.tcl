# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
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
# Usage:
# PortGroup       active_variants 1.0
# if {![catch {set result [active_variants $name $required $forbidden]}]} {
#   if {$result} {
#     # code to be executed if $name is active with at least all variants in
#     # $required and none from $forbidden
#   } else {
#     # code to be executed if $name is active, but either not with all
#     # variants in $required or any variant in $forbidden
#   }
# } else {
#   # code to be executed if $name isn't active
# }
#
# where
#  $name
#    is the name of the port you're trying to check (required)
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
# if {[active_variants $name $required $forbidden]} {
#   # code to be run if $name is active with all from $required and none from
#   # $forbidden
# } else {
#   # code to be run if $name is active, but either not with all variants in
#   # $required or any variant in $forbidden
# }
#
# If all you want to do is bail out when the condition isn't fulfilled, there's
# a convenience wrapper available. If the condition isn't met it will print an
# error message and exit. This will also error out, if the port $name isn't
# active, so you should probably not be using this before configure phase.
#
# require_active_variants $name $required $forbidden
#

proc active_variants {name required {forbidden {}}} {
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
	# $name, which comes from registry2.0/entry.c, line 387. I won't dig
	# deeper than that, since that's as far as we need to go to handle this
	# correctly.
	#
	# When looking at registry2.0/receipt_sqlite.tcl, line 53 and following,
	# we can see the structure returned by this call: it's a list of
	# registry entries (in the case of active, there can only be one, since
	# there can never be multiple versions of the same port active at the
	# same time). This explains the [lindex $active_list 0] in the following
	# block.

	# this will throw if $name isn't active
	set installed [lindex [registry_active $name] 0]

	# In $installed there are in order: name, version, revision, variants,
	# a boolean indicating whether the port is installed and the epoch. So,
	# we're interested in the field at offset 3.
	set variants [lindex $installed 3]
	ui_debug "$name is installed with the following variants: $variants"
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

proc require_active_variants {name required {forbidden {}}} {
	if {[catch {set result [active_variants $name $required $forbidden]}] != 0} {
		error "$name is required, but not active."
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
		if {$str_required != "" && $str_forbidden != ""} {
			set str_combine " and "
		}
		error "$name must be installed ${str_required}${str_combine}${str_forbidden}."
	}
}

proc _variant_in_variant_list {needle haystack} {
	foreach variant $haystack {
		if {$variant == $needle} {
			return 1
		}
	}
	return 0
}
