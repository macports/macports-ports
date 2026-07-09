# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# python_variants 1.0
#
# Unlike the stock `python 1.0` PortGroup (which builds pyXY-foo subports for
# py-foo module ports), this group adds a set of mutually-exclusive pythonXY
# variants to *any* port that includes it, so a plain application/library port
# can depend on "whichever Python the user has selected" without being split
# into subports.
#
# Usage in a Portfile:
#   PortGroup           python_variants 1.0
#   python.variants     {312 313 314}
#
# This declares variants +python312 +python313 +python314, each of which:
#   - appends depends_lib-append port:pythonXY
#   - conflicts with the other pythonXY variants in the list
#
# The active version (once resolved) is available to the rest of the Portfile
# as ${python.variant} (e.g. "314") and ${python.branch} (e.g. "3.14"), for use
# in configure.args / build.args / post-destroot, etc.
#
# Selection precedence (highest wins), same as any MacPorts variant:
#   1. explicit +/-pythonXY on the command line
#   2. a +pythonXY line in variants.conf
#   3. the FIRST version listed in python.variants, if nothing above selects one
#
# IMPORTANT: list order in python.variants is semantically significant, not
# just presentational. python.variants {313 312 314} and
# python.variants {312 313 314} generate the same three variants but pick a
# DIFFERENT default. There is no separate "python.default_version" variable —
# there used to be, and it was removed deliberately: it depended on being set
# before python.variants in the Portfile, silently did nothing if set after,
# and that ordering bug is exactly the kind of trap a PortGroup should not
# hand its users. Put whichever version you want as the default first in the
# list instead.
#
# NAMING NOTE: python.variants/python.variant deliberately reuse MacPorts'
# own "variant" vocabulary (variant_isset, default_variants, ${portvariants},
# etc.), which this file's own author (Claude) argued against on collision
# grounds. Kept anyway per Vince, pending team review; flagged here so the
# tradeoff is visible to whoever reads this next, not just relitigated.

# python.variant_code: (optional) a literal Tcl code block, same shape as
# post-destroot { ... } or a variant body — NOT a proc name, no proc
# definition required. Evaluated once per generated variant, from inside
# that version's variant body, i.e. only when the user actually selects
# +pythonXY. Inside the block, ${pyver} (e.g. "313") and ${branch}
# (e.g. "3.13") are available as ordinary local variables.
#
# Looked up dynamically (via `global` + `eval`) at variant-selection time,
# not baked into the variant body when python.variants is set — so it can
# be set before or after python.variants in the Portfile; order doesn't
# matter. Not verified: whether variant bodies execute in the same
# namespace as top-level Portfile variables — confirm with a real port
# build before relying on this.
options python.variants python.variant python.branch python.variant_code

option_proc python.variants python_variants_set
option_proc python.variant_code python_variants_set_code

proc python_variants_set_code {option action args} {
    # The real bug, confirmed from macports-base/src/port1.0/portutil.tcl:
    # handle_option (the generic setter every plain `options`-registered
    # variable goes through) does `set $option $args`, where $args is a
    # proc-collected Tcl list. Storing a list whose one element is a
    # multi-line string, then reading it back, makes Tcl's list-formatter
    # wrap that element in an extra literal { } pair. That corruption
    # happens in handle_option, BEFORE any option_proc trace ever fires —
    # option_proc/option_proc_trace only attach a variable trace that
    # notifies you AFTER handle_option has already run.
    #
    # A first attempt at fixing this unwrapped $args instead of the
    # variable itself: option_proc_trace's write case calls this proc as
    # `$p $optionName set [set $optionName]` — i.e. args here is a
    # 1-element list wrapping the variable's CURRENT (already-corrupted)
    # value. Unwrapping $args just hands back that same corrupted value
    # unchanged; it never touches handle_option's own corruption. Fixed by
    # unwrapping the variable's actual current value instead, and writing
    # that back — confirmed by direct simulation against the real
    # handle_option/option_proc/option_proc_trace source, including that
    # this does not recurse or double-corrupt on the resulting write.
    if {${action} ne "set"} {
        return
    }
    global python.variant_code
    set python.variant_code [lindex ${python.variant_code} 0]
}

# --- helpers -----------------------------------------------------------

proc python_variants_branch {pyver} {
    # 314 -> 3.14 ; 27 -> 2.7
    if {[string length ${pyver}] < 2} {
        return ${pyver}
    }
    set major [string index ${pyver} 0]
    set minor [string range ${pyver} 1 end]
    return "${major}.${minor}"
}

proc python_variants_get_variant {} {
    set vars [option python.variants]
    if {[llength ${vars}] == 0} {
        return -code error "python_variants: python.variants was never set — this PortGroup requires it"
    }
    foreach entry ${vars} {
        lassign [python_variants_parse_entry ${entry}] pyvar realport
        if {[variant_isset python${pyvar}]} {
            return ${pyvar}
        }
    }
    # nothing explicitly selected: first-listed version is the default.
    # (list order is semantically significant — see header comment.)
    lassign [python_variants_parse_entry [lindex ${vars} 0]] first_pyvar first_realport
    return ${first_pyvar}
}

default python.variant {[python_variants_get_variant]}

# python.branch is read-only/derived, not user-settable
proc python_variants_branch_current {} {
    # Bug fixed here: this used to call [python_variants_branch [option
    # python.variants]] — passing the WHOLE LIST (e.g. "312 313 314") to a
    # proc that expects a single resolved version string. That doesn't
    # error, it just silently produces garbage (string index/range applied
    # to a multi-element list string). Must resolve to the single active
    # version first via python_variants_get_variant, matching what
    # default python.variant already does above.
    return [python_variants_branch [python_variants_get_variant]]
}

default python.branch {[python_variants_branch_current]}

# --- variant generation --------------------------------------------------

# python_variants_parse_entry: an entry in python.variants is normally just
# a version code (e.g. "315"), which is assumed to also be the real port
# name suffix (port:python315). That assumption breaks for ports that don't
# follow the plain pythonXY naming pattern — e.g. free-threaded builds,
# where the version code you want as the variant name (e.g. "315t") and the
# actual MacPorts port providing it (e.g. python315-freethreading-devel)
# are unrelated strings. An entry may therefore optionally be written as
# "pyver:realportname" to split the two apart; without a colon, realport
# defaults to "python${pyver}" as before.
proc python_variants_parse_entry {entry} {
    if {[string first ":" ${entry}] >= 0} {
        set parts [split ${entry} ":"]
        return [list [lindex ${parts} 0] [lindex ${parts} 1]]
    }
    return [list ${entry} "python${entry}"]
}

proc python_variants_set {option action args} {
    # $option is unused: this proc is only ever registered for python.variants
    # via option_proc, so it's always the literal string "python.variants".
    # Kept in the signature because MacPorts' option_proc dispatcher calls
    # back with exactly 3 positional args regardless of whether the callback
    # needs all of them — Tcl requires the proc to accept that many (or use
    # "args" for the tail), it won't let you just drop a middle parameter.

    if {${action} ne "set"} {
        return
    }

    # Portfiles may write either:
    #   python.variants {315 314 313}   (one arg: a pre-formed list)
    #   python.variants 315 314 313     (three bareword args)
    # Handle both without assuming which shape MacPorts' option_proc
    # dispatcher forwards args in — that's not verified in this file.
    if {[llength ${args}] == 1} {
        set variants [lindex ${args} 0]
    } else {
        set variants ${args}
    }

    if {[llength ${variants}] == 0} {
        return -code error "python.variants must not be empty"
    }

    # pre-parse every entry once, so the fallback-default and conflict
    # checks below operate on plain pyver codes (e.g. "315t"), never on a
    # raw "pyver:realport" entry that would otherwise leak into a variant
    # name or a +flag and be silently wrong rather than erroring loudly.
    set pyvers {}
    foreach entry ${variants} {
        lassign [python_variants_parse_entry ${entry}] pyver realport
        lappend pyvers ${pyver}
    }

    foreach entry ${variants} {
        lassign [python_variants_parse_entry ${entry}] pyver realport
        set branch [python_variants_branch ${pyver}]

        # collect the sibling variant names this one conflicts with
        set others {}
        foreach other_pyver ${pyvers} {
            if {${other_pyver} ne ${pyver}} {
                lappend others "python${other_pyver}"
            }
        }

        set conflicts_clause ""
        if {[llength ${others}] > 0} {
            set conflicts_clause "conflicts ${others}"
        }

        eval [subst -nocommands {
            variant python${pyver} ${conflicts_clause} description "Use Python ${branch} for this port" {
                depends_lib-append port:${realport}
                set pyver "${pyver}"
                set branch "${branch}"
                global python.variant
                global python.variant_code
                if {[info exists python.variant_code] && \${python.variant_code} ne ""} {
                    eval \${python.variant_code}
                }
            }
        }]
    }

    # Only force a fallback version if the user hasn't already selected one
    # of the variants declared above, via the command line or variants.conf.
    # This guard exists because of a confirmed real bug: calling
    # default_variants-append unconditionally, without checking first,
    # broke boost181 with "Variant python310 conflicts with python314" —
    # MacPorts merges a Portfile's default_variants and variants.conf
    # additively rather than letting one suppress the other, so forcing a
    # default that conflicts with an already-active variants.conf entry is
    # a hard error, not a harmless no-op.
    #
    # The fallback value itself is simply the first entry in ${pyvers} —
    # that list is already fully resolved right here, as this proc's own
    # local variable, so there is nothing left that could be set "too late"
    # by a later Portfile line. An earlier version of this file fell back
    # to a separate python.default_version variable instead; that had its
    # own, different confirmed bug — setting it after python.variants in
    # the Portfile was silently ignored, because this fallback fires and
    # calls default_variants-append synchronously (and irreversibly) the
    # instant python.variants is set. Deleting the separate variable
    # removes that bug rather than working around it.
    set any_selected 0
    foreach pyver ${pyvers} {
        if {[variant_isset python${pyver}]} {
            set any_selected 1
            break
        }
    }
    if {!${any_selected}} {
        default_variants-append " +python[lindex ${pyvers} 0]"
    }
}
