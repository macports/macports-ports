# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# perl_variants 1.0
#
# Adapted from python_variants 1.0, after that file went through a long,
# real debugging cycle against an actual MacPorts build (see its own header
# and comments for the full history). This file inherits every fix from
# that process — but it has NOT itself been run against a real MacPorts
# build. Treat it as a well-informed first draft, not battle-tested code,
# until it's actually been exercised the way python_variants was.
#
# Unlike the stock `perl5` PortGroup (which builds subports for p5-*
# module ports), this group adds a set of mutually-exclusive perlX.Y
# variants to *any* port that includes it, so a plain application/library
# port can depend on "whichever Perl the user has selected" without being
# split into subports.
#
# Usage in a Portfile:
#   PortGroup           perl_variants 1.0
#   perl.variants       {5.34 5.38 5.40}
#
# This declares variants +perl5.34 +perl5.38 +perl5.40, each of which:
#   - appends depends_lib-append port:perlX.Y
#   - conflicts with the other perlX.Y variants in the list
#
# The active version (once resolved) is available to the rest of the
# Portfile as:
#   ${perl.variant}  the version code, e.g. "5.42"
#   ${perl.bin}       the Perl executable name, e.g. "perl5.42"
#   ${perl.major}    the major version only, e.g. "5"
# All three are real, registered options with lazy `default` resolvers —
# not just locals set inside variant bodies — so they're readable from
# anywhere in the Portfile (post-destroot, top-level code, etc.), the same
# way ${python.variant}/${python.branch} are in python_variants. That
# distinction mattered in practice: an earlier version of python_variants
# had ${python.branch} implemented ONLY as a variant-body local, silently
# unavailable everywhere else despite being documented as available
# everywhere, and that gap went unnoticed until it broke a real build.
#
# NAMING DIFFERENCE FROM python_variants, CONFIRMED, NOT ASSUMED: real
# MacPorts Perl ports use DOTTED version numbers directly in the port name
# (perl5.34, perl5.38, perl5.40, perl5.42) — unlike Python's undotted
# python312/python313. So the natural entry in perl.variants is already
# the dotted form, and realport = "perl${pyver}" works correctly for
# ordinary entries without needing the colon-override syntax below. Dots
# are legal in MacPorts variant names (matches the ^[A-Za-z0-9_.]+$ rule
# real Portfiles are validated against), so `variant perl5.34 { ... }` is
# valid syntax — but this specific claim, that MacPorts is actually happy
# generating and selecting a variant whose name contains a dot in
# practice, has not been tested against a real port build. Confirm this
# before trusting it, the same way every python_variants claim eventually
# had to be confirmed against a real build in this file's sibling.
#
# UPDATE: this section originally argued against inventing a
# ${perl.branch} equivalent to python_variants' ${python.branch}, on the
# grounds that its author (Claude) had no confirmed knowledge of Perl's
# real binary-naming convention and didn't want to guess at it the way an
# earlier, unverified assumption in python_variants caused a real bug.
# ${perl.bin} and ${perl.major} below were added after Vince gave the
# actual, confirmed mapping directly (perl.bin = "perl" + the version
# code, e.g. "perl5.42") — i.e. once the previously-missing information
# existed, the objection no longer applied. Left this note in place as a
# record of why those two options weren't there from the start, since the
# reasoning itself (don't encode an unconfirmed naming assumption into the
# PortGroup) is worth keeping visible even after it stopped blocking
# anything.
#
# Selection precedence (highest wins), same as any MacPorts variant:
#   1. explicit +/-perlX.Y on the command line
#   2. a +perlX.Y line in variants.conf
#   3. the FIRST version listed in perl.variants, if nothing above selects one
#
# IMPORTANT: list order in perl.variants is semantically significant, not
# just presentational — same caveat as python_variants, same reasoning:
# there is deliberately no separate "default version" variable, because
# that had a real, confirmed ordering bug in the Python file that this
# design avoids by construction rather than by convention.
#
# perl.variant_code: (optional) a literal Tcl code block, same shape as
# post-destroot { ... } or a variant body — NOT a proc name, no proc
# definition required. Evaluated once per generated variant, from inside
# that version's variant body, i.e. only when the user actually selects
# +perlX.Y. Inside the block, ${pyver} (e.g. "5.34") is available as an
# ordinary local variable. (Named ${pyver} rather than e.g. ${plver} to
# stay consistent with python_variants' own internal naming, since this
# file is a close sibling of it — reconsider if that reads as confusing
# rather than consistent once this file is actually used.)
options perl.variants perl.variant perl.bin perl.major perl.variant_code

option_proc perl.variants perl_variants_set
option_proc perl.variant_code perl_variants_set_code

proc perl_variants_set_code {option action args} {
    # Same fix as python_variants_set_code, same underlying cause: the
    # generic MacPorts option-setter (handle_option) stores a single
    # braced argument as a 1-element Tcl list, and Tcl's list-formatter
    # re-serializes a multi-line list element with an extra literal brace
    # pair around it. Confirmed for python.variant_code against real
    # macports-base source; inherited here on the reasonable assumption
    # that handle_option's behavior isn't option-name-specific — but that
    # inheritance itself hasn't been separately re-confirmed for this file.
    if {${action} ne "set"} {
        return
    }
    global perl.variant_code
    set perl.variant_code [lindex ${perl.variant_code} 0]
}

# --- helpers -----------------------------------------------------------

# perl_variants_parse_entry: an entry in perl.variants is normally already
# the real port-name suffix (e.g. "5.34" -> port:perl5.34), since Perl's
# MacPorts naming is dotted throughout. Kept anyway, for the same reason
# python_variants kept it after the free-threaded-Python case: some future
# Perl variant may not follow the plain perlX.Y pattern, and "pyver:realport"
# lets a Portfile author override the derived port name without needing a
# PortGroup change, the same escape hatch that mattered in practice for
# python_variants.
proc perl_variants_parse_entry {entry} {
    if {[string first ":" ${entry}] >= 0} {
        set parts [split ${entry} ":"]
        return [list [lindex ${parts} 0] [lindex ${parts} 1]]
    }
    return [list ${entry} "perl${entry}"]
}

proc perl_variants_get_variant {} {
    set vars [option perl.variants]
    if {[llength ${vars}] == 0} {
        return -code error "perl_variants: perl.variants was never set — this PortGroup requires it"
    }
    foreach entry ${vars} {
        lassign [perl_variants_parse_entry ${entry}] pyvar realport
        if {[variant_isset perl${pyvar}]} {
            return ${pyvar}
        }
    }
    # nothing explicitly selected: first-listed version is the default.
    # (list order is semantically significant — see header comment.)
    lassign [perl_variants_parse_entry [lindex ${vars} 0]] first_pyvar first_realport
    return ${first_pyvar}
}

default perl.variant {[perl_variants_get_variant]}

# perl.bin: the actual Perl executable name for the active version, e.g.
# "perl5.42" for perl.variant "5.42". Naively "perl" + the version code —
# matches the real MacPorts perl5.X port-naming convention directly.
#
# NOT confirmed: whether this holds if a future perl.variants entry uses
# the colon-override syntax (pyver:realport) for some oddball Perl variant
# whose real port name doesn't follow the plain perlX.Y pattern. This is
# exactly the class of assumption that broke for python_variants —
# ${python.branch} was computed one way, but Boost's own library naming
# needed a differently-derived value, and the mismatch wasn't caught until
# a real build hit it. If a future perl.variants entry ever needs an
# override here too, this formula (perl + the bare version code, ignoring
# any realport override) is the first place to revisit.
proc perl_variants_bin_current {} {
    return "perl[perl_variants_get_variant]"
}

default perl.bin {[perl_variants_bin_current]}

# perl.major: the major version number only, e.g. "5" for perl.variant
# "5.42". Computed by splitting on the first dot — correct for Perl's
# actual version scheme (perl has been "5.x" for its entire modern
# history; there is no confirmed handling here for anything else, because
# there is currently nothing else to handle).
proc perl_variants_major_current {} {
    set v [perl_variants_get_variant]
    return [lindex [split ${v} "."] 0]
}

default perl.major {[perl_variants_major_current]}

# --- variant generation --------------------------------------------------

proc perl_variants_set {option action args} {
    # $option is unused — see python_variants_set's identical comment for
    # why it stays in the signature anyway (MacPorts' option_proc
    # dispatcher always calls back with 3 positional args).
    if {${action} ne "set"} {
        return
    }

    # Handle both single-braced-list and multi-bareword-arg call styles,
    # same unresolved uncertainty as python_variants_set about which shape
    # MacPorts' option_proc dispatcher actually forwards — defensive
    # either way, cost is negligible.
    if {[llength ${args}] == 1} {
        set variants [lindex ${args} 0]
    } else {
        set variants ${args}
    }

    if {[llength ${variants}] == 0} {
        return -code error "perl.variants must not be empty"
    }

    set pyvers {}
    foreach entry ${variants} {
        lassign [perl_variants_parse_entry ${entry}] pyver realport
        lappend pyvers ${pyver}
    }

    foreach entry ${variants} {
        lassign [perl_variants_parse_entry ${entry}] pyver realport

        set others {}
        foreach other_pyver ${pyvers} {
            if {${other_pyver} ne ${pyver}} {
                lappend others "perl${other_pyver}"
            }
        }

        set conflicts_clause ""
        if {[llength ${others}] > 0} {
            set conflicts_clause "conflicts ${others}"
        }

        eval [subst -nocommands {
            variant perl${pyver} ${conflicts_clause} description "Use Perl ${pyver} for this port" {
                depends_lib-append port:${realport}
                set pyver "${pyver}"
                global perl.variant
                global perl.variant_code
                if {[info exists perl.variant_code] && \${perl.variant_code} ne ""} {
                    eval \${perl.variant_code}
                }
            }
        }]
    }

    # Same boost181-derived guard as python_variants_set: only force a
    # fallback if nothing already selected one, because MacPorts merges
    # default_variants and variants.conf additively rather than letting
    # one suppress the other — forcing a default that conflicts with an
    # already-active variants.conf entry is a hard error, confirmed in
    # practice for python_variants, assumed to apply identically here
    # since it's a property of MacPorts' variant resolution, not of
    # anything Python-specific.
    set any_selected 0
    foreach pyver ${pyvers} {
        if {[variant_isset perl${pyver}]} {
            set any_selected 1
            break
        }
    }
    if {!${any_selected}} {
        default_variants-append " +perl[lindex ${pyvers} 0]"
    }
}
