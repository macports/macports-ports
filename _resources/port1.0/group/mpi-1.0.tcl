# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
#
# Copyright (c) 2014 The MacPorts Project
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
# This PortGroup sets up default variants for projects that want m
#
# Usage:
#
#   PortGroup               mpi 1.0

PortGroup compilers 1.0

default mpi.variants {}
default mpi.require 0
default mpi.required_variants {}

set mpi.list {cc cxx f77 f90 fc}
set mpi.cc   mpicc
set mpi.cxx  mpicxx
set mpi.f77  mpif77
set mpi.f90  mpif90
set mpi.fc   mpif90
set mpi.exec mpiexec
set mpi.name ""

set mpidb(mpich,variant)  mpich
set mpidb(mpich,descrip)  "MPICH Compiler"
set mpidb(mpich,name)     mpich
set mpidb(mpich,conflict) universal

set mpidb(mpich_devel,variant)  mpich_devel
set mpidb(mpich_devel,descrip)  "MPICH-devel Compiler"
set mpidb(mpich_devel,name)     mpich-devel
set mpidb(mpich_devel,conflict) universal

set mpidb(openmpi,variant)  openmpi
set mpidb(openmpi,descrip)  "OpenMPI Compiler"
set mpidb(openmpi,name)     openmpi
set mpidb(openmpi,conflict) universal

set mpidb(openmpi_devel,variant)  openmpi_devel
set mpidb(openmpi_devel,descrip)  "OpenMPI-devel Compiler"
set mpidb(openmpi_devel,name)     openmpi-devel
set mpidb(openmpi_devel,conflict) universal

foreach name [array names mpidb *,variant] {
    lappend mpi.variants $mpidb($name)
}

proc mpi.setup_variants {args} {
    global mpidb mpi.cc mpi.cxx mpi.f77 mpi.f90 mpi.fc

    foreach variant $args {
        if {[variant_exists $variant]} {
            ui_debug "$variant variant already exists, so not adding the default one"
        } else {
            set i [lsearch -exact $args $variant]
            set c [lreplace $args $i $i]

            eval [subst {
                variant ${variant} description {Build using the $mpidb($variant,descrip) compiler} conflicts $c $mpidb($variant,conflict) {

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

                    foreach compiler \${mpi.list} {
                        if {\$compiler ne "fc"} {
                            configure.\$compiler mpi\${compiler}-$mpidb($variant,name)-\$p_name
                        }
                    }
                    if {[lsearch -exact \${mpi.list} fc]} {
                        set configure.fc mpif90-$mpidb($variant,name)-\$p_name
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
    foreach portname $args {
        if {![catch {set result [active_variants $portname "" ""]}]} {
            set otmpi  [mpi_active_variant_name $portname]
            set mympi  [mpi_variant_name]

            if {$otmpi ne "" && $mympi eq ""} {
                default_variants +$otmpi
            } elseif {$otmpi ne $mympi} {
                ui_error "Install $portname +$mympi"
                return -code error "$portname +$mympi not installed"
            }

            eval compilers.action_enforce_c $portname
        }
    }
}

# only run this if mpi is chosen
pre-fetch {
    if {${compilers.require_fortran} && [mpi_variant_isset]} {
        set mpif [fortran_active_variant_name ${mpi.name}]
        set myf  [fortran_variant_name]

        if {$myf eq "g95" && $myf ne $mpif} {
            ui_error "${mpi.name} has a different fortran variant ($mpif) than the selected $myf"
            return -code error "${mpi.name} needs the $myf variant"
        }
    }
}

proc mpi_variant_isset {} {
    return [expr {[mpi_variant_name] ne ""}]
}

proc mpi.choose {args} {
    global mpi.list

    # zero out the variable before and append args
    set mpi.list {}
    foreach v $args {
        lappend mpi.list $v
    }
}

proc mpi.setup {args} {
    global cdb mpidb mpi.variants mpi.require compilers.variants

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
            }
            require_fortan {
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

    set mpi.variants [lsort [concat $remove_list $add_list]]
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
}

pre-fetch {
    if {${mpi.require} && [mpi_variant_name] eq ""} {
        return -code error "must set at least one mpi variant"
    }
    eval mpi.action_enforce_variants ${mpi.required_variants}
}
