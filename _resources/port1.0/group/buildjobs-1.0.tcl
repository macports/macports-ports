# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4

#===================================================================================================
# buildjobs 1.0
#---------------------------------------------------------------------------------------------------
# This PortGroup provides support for easily limiting parallel build jobs, based on hints from
# a given port. This centralizes calculation logic, eliminating copy-pasta across ports.
#---------------------------------------------------------------------------------------------------
# The most common usage involves using a multiplier based on total system memory:
#
# PortGroup buildjobs 1.0
#
# buildjobs.limit_build_jobs yes
# buildjobs.max_ram_fraction 0.5
#===================================================================================================

namespace eval buildjobs { }

#---------------------------------------------------------------------------------------------------

# Available CPUs; not intended to be set in portfiles
options buildjobs.max_cpus
default buildjobs.max_cpus [expr {[exec sysctl -n hw.logicalcpu]}]

# Available RAM in GB; not intended to be set in portfiles
options buildjobs.max_ram_gb
default buildjobs.max_ram_gb [expr {round([exec sysctl -n hw.memsize] / pow(1024,3))}]

# Amount of RAM to reserve for the OS; not intended to be set in portfiles
options buildjobs.reserve_ram_gb
default buildjobs.reserve_ram_gb 2

#---------------------------------------------------------------------------------------------------

options buildjobs.limit_build_jobs
default buildjobs.limit_build_jobs no

options buildjobs.max_ram_fraction
default buildjobs.max_ram_fraction 1.0

options buildjobs.max_cpu_fraction
default buildjobs.max_cpu_fraction 1.0

#---------------------------------------------------------------------------------------------------

proc buildjobs::verify_options {} {
    global name subport
    ui_info "buildjobs::verify_options: called for port/subport: ${name}/${subport}"

    set limit_build_jobs [option buildjobs.limit_build_jobs]
    set max_cpus         [option buildjobs.max_cpus]
    set max_ram_gb       [option buildjobs.max_ram_gb]
    set reserve_ram_gb   [option buildjobs.reserve_ram_gb]
    set max_ram_fraction [option buildjobs.max_ram_fraction]
    set max_cpu_fraction [option buildjobs.max_cpu_fraction]

    ui_info "buildjobs.limit_build_jobs: ${limit_build_jobs}"
    ui_info "buildjobs.max_cpus: ${max_cpus}"
    ui_info "buildjobs.max_ram_gb: ${max_ram_gb}"
    ui_info "buildjobs.reserve_ram_gb: ${reserve_ram_gb}"
    ui_info "buildjobs.max_ram_fraction: ${max_ram_fraction}"
    ui_info "buildjobs.max_cpu_fraction: ${max_cpu_fraction}"

    if { ![string is boolean -strict ${limit_build_jobs}] } {
        error "buildjobs::verify_options: option 'buildjobs.limit_build_jobs' must be a boolean"
    }

    if { ![string is integer -strict ${max_cpus}] } {
        error "buildjobs::verify_options: 'buildjobs.max_cpus' must be an integer"
    } elseif { ${max_cpus} < 1 } {
        error "buildjobs::verify_options: 'buildjobs.max_cpus' must be a positive integer"
    }

    if { ![string is integer -strict ${max_ram_gb}] } {
        error "buildjobs::verify_options: 'buildjobs.max_ram_gb' must be an integer"
    } elseif { ${max_ram_gb} < 1 } {
        error "buildjobs::verify_options: 'buildjobs.max_ram_gb' must be a positive integer"
    }

    if { ![string is integer -strict ${reserve_ram_gb}] } {
        error "buildjobs::verify_options: 'buildjobs.reserve_ram_gb' must be an integer"
    } elseif { ${reserve_ram_gb} < 0 } {
        error "buildjobs::verify_options: 'buildjobs.reserve_ram_gb' must be an integer >= zero"
    }

    if { ![string is double -strict ${max_ram_fraction}] } {
        error "buildjobs::verify_options: 'buildjobs.max_ram_fraction' must be a decimal number"
    } elseif { ${max_ram_fraction} <= 0.0 } {
        error "buildjobs::verify_options: 'buildjobs.max_ram_fraction' must be a positive decimal"
    }

    if { ![string is double -strict ${max_cpu_fraction}] } {
        error "buildjobs::verify_options: 'buildjobs.max_cpu_fraction' must be a decimal number"
    } elseif { ${max_cpu_fraction} <= 0.0 } {
        error "buildjobs::verify_options: 'buildjobs.max_cpu_fraction' must be a positive decimal"
    }
}

#---------------------------------------------------------------------------------------------------

proc buildjobs::set_build_jobs {} {
    global name subport
    ui_info "buildjobs::set_build_jobs: called for port/subport: ${name}/${subport}"

    global build.jobs
    set limit_build_jobs [option buildjobs.limit_build_jobs]
    set max_cpus         [option buildjobs.max_cpus]
    set max_ram_gb       [option buildjobs.max_ram_gb]
    set reserve_ram_gb   [option buildjobs.reserve_ram_gb]
    set max_ram_fraction [option buildjobs.max_ram_fraction]
    set max_cpu_fraction [option buildjobs.max_cpu_fraction]

    if { ${limit_build_jobs} } {
        ui_info "buildjobs::set_build_jobs: limiting enabled, calculating"

        set avail_ram_gb [expr { ${max_ram_gb} - ${reserve_ram_gb} }]
        ui_info "buildjobs::set_build_jobs: avail_ram_gb: ${avail_ram_gb}"
        if { ${avail_ram_gb} < 1 } {
            error "buildjobs::set_build_jobs: available RAM less than one GB"
        }

        set avail_cpus [expr { round( ${max_cpus} * ${max_cpu_fraction} ) }]
        ui_info "buildjobs::set_build_jobs: avail_cpus: ${avail_cpus}"
        if { ${avail_cpus} < 1 } {
            error "buildjobs::set_build_jobs: available CPUs less than one"
        }

        set net_mem_gb [expr { round( ${avail_ram_gb} * ${max_ram_fraction} ) }]
        ui_info "buildjobs::set_build_jobs: net_mem_gb: ${net_mem_gb}"
        if { ${net_mem_gb} < 1 } {
            error "buildjobs::set_build_jobs: net RAM less than one GB"
        }

        set net_cpus [expr { min( ${avail_cpus}, ${net_mem_gb} ) }]
        ui_info "buildjobs::set_build_jobs: net_cpus: ${net_cpus}"
        if { ${net_cpus} < 1 } {
            error "buildjobs::set_build_jobs: net CPUs less than one"
        }

        ui_info "buildjobs::set_build_jobs: setting 'build.jobs' to ${net_cpus}"
        build.jobs ${net_cpus}
    } else {
        ui_info "buildjobs:set_build_jobs: limiting disabled"
    }
}

#---------------------------------------------------------------------------------------------------

proc buildjobs::pg_callback {} {
    global name subport
    ui_info "buildjobs::pg_callback: called for port/subport: ${name}/${subport}"

    buildjobs::verify_options
    buildjobs::set_build_jobs
}

#---------------------------------------------------------------------------------------------------

# Don't run until pre-fetch, to avoid any potential port parse issues
pre-fetch {
    buildjobs::pg_callback
}

