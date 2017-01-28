# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2014-2015 The MacPorts Project
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
# This PortGroup sets up default variants for projects that want MPI
#
# Usage:
#
#   PortGroup               mpi 1.0
#
# Available procedures:
# proc mpi_active_variant_name {depspec}
#   Returns the name of the active MPI variant of a dependency.
# proc mpi_variant_name {}
#   Returns the name of the active MPI variant of this port.
# proc mpi.enforce_variant {args}
#   Raise an error if the dependency does not have the same MPI variant
#   as this port. Also enforces that the dependency has the same C variant.
# proc mpi_variant_isset {}
#   Whether an MPI variant has been set.
# proc mpi.setup {args}
#   Creates MPI variants.
#   Available arguments: "require" means an MPI variant must be set.
#   All of the arguments for compilers.setup are available too and will be passed to that procedure.
#   "default" means an MPI variant (mpich) will be set as a default variant.
#   You can either list which MPI's can be used (e.g. mpich mpich-devel),
#   which cannot be used (e.g. -mpich -openmpi-devel).
#   There are four MPI variants: mpich, mpich-devel, openmpi, openmpi-devel.

PortGroup compilers 1.0

default mpi.variants {}
default mpi.require 0
default mpi.default 0
default mpi.required_variants {}

set mpi.cc   mpicc
set mpi.cxx  mpicxx
set mpi.f77  mpif77
set mpi.f90  mpif90
set mpi.fc   mpif90
set mpi.exec mpiexec
set mpi.name ""

set mpidb(mpich,variant)  mpich
set mpidb(mpich,descrip)  "MPICH"
set mpidb(mpich,name)     mpich
set mpidb(mpich,conflict) universal

set mpidb(mpich_devel,variant)  mpich_devel
set mpidb(mpich_devel,descrip)  "MPICH-devel"
set mpidb(mpich_devel,name)     mpich-devel
set mpidb(mpich_devel,conflict) universal

set mpidb(openmpi,variant)  openmpi
set mpidb(openmpi,descrip)  "OpenMPI"
set mpidb(openmpi,name)     openmpi
set mpidb(openmpi,conflict) universal

set mpidb(openmpi_devel,variant)  openmpi_devel
set mpidb(openmpi_devel,descrip)  "OpenMPI-devel"
set mpidb(openmpi_devel,name)     openmpi-devel
set mpidb(openmpi_devel,conflict) universal

foreach mpiname [array names mpidb *,variant] {
    lappend mpi.variants $mpidb($mpiname)
}

proc mpi.setup_variants {args} {
    global mpidb mpi.cc mpi.cxx mpi.f77 mpi.f90 mpi.fc

    foreach variant $args {
        if {[variant_exists $variant]} {
            ui_debug "$variant variant already exists, so not adding the default one"
        } else {
            set i [lsearch -exact $args $variant]
            set c [lreplace $args $i $i]

            # only add conflicts for variants that exist
            foreach j $mpidb($variant,conflict) {
                if {[variant_exists $j]} {
                    lappend c $j
                }
            }

            eval [subst {
                variant ${variant} description {Build using the $mpidb($variant,descrip) compiler} conflicts $c {

                    set c_name \[c_variant_name\]
                    set f_name \[fortran_variant_name\]
                    set p_name \$c_name
                    set d_name \$c_name
                    if {"\$c_name" eq ""} {
                        set p_name "mp"
                        set d_name "default"
                    }

                    set path "etc/select/mpi/$variant-\$p_name"

                    if {\$f_name ne ""} {
                        set path "\$path-fortran"
                    }

                    depends_lib-append path:\$path:$mpidb($variant,name)-\$d_name
                    set mpi.name $mpidb($variant,name)-\$d_name

                    foreach compiler {cc cxx f77 f90 exec} {
                        set mpi.\$compiler mpi\${compiler}-$mpidb($variant,name)-\$p_name
                    }
                    set mpi.fc mpif90-$mpidb($variant,name)-\$p_name

                    # there is no mpicpp or mpiobj
                    # if more compilers are added in compilers portgroup, need to be added here
                    foreach compiler \${compilers.list} {
                        if {\$compiler ne "fc" && \$compiler ne "cpp" && \$compiler ne "objc"} {
                            configure.\$compiler \${prefix}/bin/mpi\${compiler}-$mpidb($variant,name)-\$p_name
                        }
                    }
                    if {[lsearch -exact \${compilers.list} fc]} {
                        set configure.fc \${prefix}/bin/mpif90-$mpidb($variant,name)-\$p_name
                    }

                }
            }]
        }
    }
}

proc mpi_active_variant_name {depspec} {
    global mpi.variants

    foreach m ${mpi.variants} {
        if {![catch {set result [active_variants $depspec $m ""]}]} {
            if {$result} {
                return $m
            }
        } else {
            ui_warn "mpi_active_variant_name: \[active_variants $depspec $m \"\"\] fails."
        }
    }

    return ""
}

proc mpi_variant_name {} {
    global mpi.variants variations

    foreach mpiv ${mpi.variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($mpiv)] && $variations($mpiv) eq "+"} {
            return $mpiv
        }
    }

    return ""
}

proc mpi.enforce_variant {args} {
    global mpi.required_variants
    set mpi.required_variants $args
}

proc mpi.action_enforce_variants {args} {
    global name
    ui_debug "mpi.enforce_variant list: ${args}"
    foreach portname $args {
        if {![catch {set result [active_variants $portname "" ""]}]} {
            set otmpi  [mpi_active_variant_name $portname]
            set mympi  [mpi_variant_name]

            if {$otmpi ne "" && $mympi eq ""} {
                # instead of trying to append to a default variant (which fails
                # silently for some cases), we should be explicit and tell the
                # user about the error
                ui_error "Need to select variant +$otmpi"
                return -code error "$portname +$otmpi is installed, so +$otmpi needs to be selected for $name"
            } elseif {$otmpi ne $mympi} {
                ui_error "Install $portname +$mympi"
                return -code error "$portname +$mympi not installed"
            }

            eval compilers.action_enforce_c $portname
        } else {
            ui_error "Internal error: '$portname' is not an installed port."
        }
    }
}

# only run this if mpi is chosen
pre-fetch {
    if {[fortran_variant_isset] && [mpi_variant_isset]} {
        set gcc_name ""
        regexp (gcc\[0-9\]*) ${mpi.name} gcc_name 
        if {$gcc_name eq ""} {
            regexp (dragonegg\[0-9\]*) ${mpi.name} gcc_name
        }
        if {$gcc_name ne ""} {
            if {[active_variants ${mpi.name} "fortran" ""]} {
                set mpif $gcc_name
            } else {
                set mpif ""
            }
        } else {
            # this is a default, clang, or llvm subport
            set mpif [fortran_active_variant_name ${mpi.name}]
            
        }
        # mpif will definitely have a real compiler name, not gfortran.
        set myf [fortran_compiler_name [fortran_variant_name]]

        if {$myf ne $mpif} {
            if {$mpif eq "" && $gcc_name ne ""} {
                ui_error "${mpi.name} was built without Fortran support."
                set need "fortran"
            } else {
                if {[fortran_variant_name] eq "gfortran"} {
                    set selectedf " (via +gfortran)"
                } else {
                    set selectedf ""
                }
                ui_error "${mpi.name} has a different Fortran variant ($mpif) than the one selected, $myf$selectedf."
                set need $myf
            }
            return -code error "Install ${mpi.name} +$need"
        }
    }
}

proc mpi_variant_isset {} {
    return [expr {[mpi_variant_name] ne ""}]
}

proc mpi.setup {args} {
    global cdb mpidb mpi.variants mpi.require mpi.default compilers.variants name

    set add_list {}
    set remove_list ${mpi.variants}
    set cl {}

    foreach variant $args {
        # keep original commandname
        set v $variant

        # if any negated mpi (e.g. -mpich) is specified then we are
        # removing from the default, complete list
        set mode add
        if {[string first - $v] == 0} {
            set mode remove

            #strip the beginning '-' character
            set v [string range $v 1 end]
        }

        # handle special cases, such as 'require' -> makes mpi required
        switch -exact $v {
            require {
                set mpi.require 1
                set mpi.default 1
            }
            "default" {
                set mpi.default 1
            }
            require_fortran {
                set cl [add_from_list $cl "require_fortran"]
            }
            default {
                if {[info exists mpidb($v,variant)] == 0} {
                    if {$v eq "gcc" ||
                        $v eq "dragonegg" ||
                        $v eq "fortran" ||
                        $v eq "clang" ||
                        $v eq "require_fortran" ||
                        [info exists cdb($v,variant)]} {
                        set cl [add_from_list $cl $variant]
                    } else {
                        return -code error "no such mpi package: $v"
                    }
                } else {
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] $mpidb($v,variant)]
                }
            }
        }
    }

    # here we add all compiler variants since we can't dynamically look up
    # which variants are enabled for the mpi ports; instead we'll use active
    # variants to detect an incompatibility
    eval compilers.setup $cl

    # we need to check for a removed variant early so we can exit before
    # the wrong variant is passed up the dependency chain
    set badvariant [mpi_variant_name]
    set origvariants ${mpi.variants}
    set mpi.variants [lsort [concat $remove_list $add_list]]
    set removedvariants [remove_from_list $origvariants ${mpi.variants}]
    if {[lsearch -exact $removedvariants $badvariant] > -1} {
        ui_error "$name has disallowed +$badvariant! Please choose another mpi variant"
        return -code error "$name +$badvariant not allowed"
    }

    eval mpi.setup_variants ${mpi.variants}

    set mpi [ mpi_variant_name ]
    if {$mpi ne ""} {
        set fv [fortran_variant_name]
        set cv "[c_variant_name] $fv"
        set cl [remove_from_list ${compilers.variants} [c_variant_name]]

        # if no fortran variant is set, then we need to remove the fortran
        # variants from the list of variants that shouldn't be blacklisted
        if {$fv eq ""} {
            set cl [remove_from_list $cl {gfortran g95}]
            set cv [c_variant_name]
        }

        require_active_variants $mpi $cv $cl
    }

    if {${mpi.default} && ![mpi_variant_isset]} {
        default_variants-append +mpich
    }
}

pre-fetch {
    if {${mpi.require} && [mpi_variant_name] eq ""} {
        return -code error "must set at least one mpi variant"
    }
    eval mpi.action_enforce_variants ${mpi.required_variants}
}
