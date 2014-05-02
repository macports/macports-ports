# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
# $Id$
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
# This PortGroup sets up default variants for projects that want m
#
# Usage:
#
#   PortGroup               compilers 1.0

PortGroup active_variants 1.1

options compilers.variants compilers.gcc_variants
default compilers.variants {}
default compilers.fortran_variants {}
default compilers.gcc_variants {}
default compilers.clang_variants {}
default compilers.dragonegg_variants {}
default compilers.require_fortran 0
default compilers.setup_done 0
default compilers.required_c {}
default compilers.required_f {}

set compilers.list {cc cxx cpp objc fc f77 f90}

# build database of gcc 4{4..9} compiler attributes
set gcc_versions {4 5 6 7 8 9}
foreach v ${gcc_versions} {
    lappend compilers.gcc_variants gcc4$v
    set cdb(gcc4$v,variant)  gcc4$v
    set cdb(gcc4$v,compiler) macports-gcc-4.$v
    set cdb(gcc4$v,descrip)  "MacPorts gcc 4.$v"
    set cdb(gcc4$v,depends)  port:gcc4$v
    set cdb(gcc4$v,dependsl) path:lib/libgcc/libgcc_s.1.dylib:libgcc
    set cdb(gcc4$v,dependsd) port:g95
    set cdb(gcc4$v,dependsa) gcc4$v
    set cdb(gcc4$v,conflict) "gfortran g95"
    set cdb(gcc4$v,cc)       ${prefix}/bin/gcc-mp-4.$v
    set cdb(gcc4$v,cxx)      ${prefix}/bin/g++-mp-4.$v
    set cdb(gcc4$v,cpp)      ${prefix}/bin/cpp-mp-4.$v
    set cdb(gcc4$v,objc)     ${prefix}/bin/gcc-mp-4.$v
    set cdb(gcc4$v,fc)       ${prefix}/bin/gfortran-mp-4.$v
    set cdb(gcc4$v,f77)      ${prefix}/bin/gfortran-mp-4.$v
    set cdb(gcc4$v,f90)      ${prefix}/bin/gfortran-mp-4.$v
}

set clang_versions {0 1 2 3 4 5}
foreach v ${clang_versions} {
    lappend compilers.clang_variants clang3$v
    set cdb(clang3$v,variant)  clang3$v
    set cdb(clang3$v,compiler) macports-clang-3.$v
    set cdb(clang3$v,descrip)  "MacPorts clang 3.$v"
    set cdb(clang3$v,depends)  port:clang-3.$v
    set cdb(clang3$v,dependsl) ""
    set cdb(clang3$v,dependsd) ""
    set cdb(clang3$v,dependsa) clang-3.$v
    set cdb(clang3$v,conflict) ""
    set cdb(clang3$v,cc)       ${prefix}/bin/clang-mp-3.$v
    set cdb(clang3$v,cxx)      ${prefix}/bin/clang++-mp-3.$v
    set cdb(clang3$v,cpp)      "${prefix}/bin/clang-mp-3.$v -E"
    set cdb(clang3$v,objc)     ""
    set cdb(clang3$v,fc)       ""
    set cdb(clang3$v,f77)      ""
    set cdb(clang3$v,f90)      ""
}

# dragonegg versions match the corresponding clang version until 3.5
set dragonegg_versions {0 1 2 3 4}
foreach v ${dragonegg_versions} {
    lappend compilers.dragonegg_variants dragonegg3$v
    set cdb(dragonegg3$v,variant)  dragonegg3$v
    set cdb(dragonegg3$v,compiler) macports-dragonegg-3.$v
    set cdb(dragonegg3$v,descrip)  "MacPorts dragonegg 3.$v"
    set cdb(dragonegg3$v,depends)  path:bin/dragonegg-3.$v-gcc:dragonegg-3.$v
    set cdb(dragonegg3$v,dependsl) path:lib/libgcc/libgcc_s.1.dylib:libgcc
    set cdb(dragonegg3$v,dependsd) port:g95
    set cdb(dragonegg3$v,dependsa) dragonegg-3.$v
    set cdb(dragonegg3$v,conflict) "gfortran g95"
    set cdb(dragonegg3$v,cc)       ${prefix}/bin/dragonegg-3.$v-gcc
    set cdb(dragonegg3$v,cxx)      ${prefix}/bin/dragonegg-3.$v-g++
    set cdb(dragonegg3$v,cpp)      ${prefix}/bin/dragonegg-3.$v-cpp
    set cdb(dragonegg3$v,objc)     ""
    set cdb(dragonegg3$v,fc)       ${prefix}/bin/dragonegg-3.$v-gfortran
    set cdb(dragonegg3$v,f77)      ${prefix}/bin/dragonegg-3.$v-gfortran
    set cdb(dragonegg3$v,f90)      ${prefix}/bin/dragonegg-3.$v-gfortran
}

set cdb(llvm,variant)  llvm
set cdb(llvm,compiler) llvm-gcc-4.2
set cdb(llvm,descrip)  "Apple native llvm-gcc 4.2"
set cdb(llvm,depends)  bin:llvm-gcc-4.2:llvm-gcc42
set cdb(llvm,dependsl) ""
set cdb(llvm,dependsd) ""
set cdb(llvm,dependsa) ""
set cdb(llvm,conflict) ""
set cdb(llvm,cc)       llvm-gcc-4.2
set cdb(llvm,cxx)      llvm-g++-4.2
set cdb(llvm,cpp)      llvm-cpp-4.2
set cdb(llvm,objc)     llvm-gcc-4.2
set cdb(llvm,fc)       ""
set cdb(llvm,f77)      ""
set cdb(llvm,f90)      ""

# and lastly we add a gfortran and g95 variant for use with clang*; note that
# we don't need gfortran when we are in an "only-fortran" mode
set cdb(gfortran,variant)  gfortran
set cdb(gfortran,compiler) gfortran
set cdb(gfortran,descrip)  "Fortran compiler from gcc48"
set cdb(gfortran,depends)  port:gcc48
set cdb(gfortran,dependsl) path:lib/libgcc/libgcc_s.1.dylib:libgcc
set cdb(gfortran,dependsd) ""
set cdb(gfortran,dependsa) ""
set cdb(gfortran,conflict) ""
set cdb(gfortran,cc)       ""
set cdb(gfortran,cxx)      ""
set cdb(gfortran,cpp)      ""
set cdb(gfortran,objc)     ""
set cdb(gfortran,fc)       ${prefix}/bin/gfortran-mp-4.8
set cdb(gfortran,f77)      ${prefix}/bin/gfortran-mp-4.8
set cdb(gfortran,f90)      ${prefix}/bin/gfortran-mp-4.8

set cdb(g95,variant)  g95
set cdb(g95,compiler) g95
set cdb(g95,descrip)  "Fortran compiler from g95"
set cdb(g95,depends)  port:g95
set cdb(g95,dependsl) ""
set cdb(g95,dependsd) ""
set cdb(g95,dependsa) g95
set cdb(g95,conflict) ""
set cdb(g95,cc)       ""
set cdb(g95,cxx)      ""
set cdb(g95,cpp)      ""
set cdb(g95,objc)     ""
set cdb(g95,fc)       ${prefix}/bin/g95
set cdb(g95,f77)      ${prefix}/bin/g95
set cdb(g95,f90)      ${prefix}/bin/g95

foreach name [array names cdb *,variant] {
    lappend compilers.variants $cdb($name)
}

foreach variant ${compilers.variants} {
    if {$cdb($variant,f77) ne ""} {
        lappend compilers.fortran_variants $variant
    }
}

proc compilers.setup_variants {args} {
    global cdb compilers.variants compilers.clang_variants compilers.gcc_variants
    global compilers.dragonegg_variants compilers.fortran_variants compilers.list

    foreach variant [split $args] {
        if {$cdb($variant,f77) ne ""} {
            lappend compilers.fortran_variants $variant
        }

        if {[variant_exists $variant]} {
            ui_debug "$variant variant already exists, so not adding the default one"
        } else {
            set i [lsearch -exact ${compilers.variants} $variant]
            set c [lreplace ${compilers.variants} $i $i]

            # fortran doesn't conflict with clang
            if {$variant eq "gfortran" || $variant eq "g95"} {
                foreach clangcomp ${compilers.clang_variants} {
                    set i [lsearch -exact $c $clangcomp]
                    set c [lreplace $c $i $i]
                }
            } elseif {[string match clang* $variant]} {
                set i [lsearch -exact $c gfortran]
                set c [lreplace $c $i $i]
                set i [lsearch -exact $c g95]
                set c [lreplace $c $i $i]
            }

            # for each compiler, set the value if not empty; we can't use
            # configure.compiler because of dragonegg and possibly other new
            # compilers that aren't in macports portconfigure.tcl
            set comp ""
            foreach compiler ${compilers.list} {
                if {$cdb($variant,$compiler) ne ""} {
                    append comp [subst {
                        configure.$compiler $cdb($variant,$compiler)

                        # disable archflags
                        if {"[info command configure.${compiler}_archflags]" ne ""} {
                            configure.${compiler}_archflags
                            configure.ld_archflags
                        }
                    }]
                }
            }

            eval [subst {
                variant ${variant} description \
                    {Build using the $cdb($variant,descrip) compiler} \
                    conflicts $c $cdb($variant,conflict) {

                    depends_build-append   $cdb($variant,depends)
                    depends_lib-append     $cdb($variant,dependsl)
                    depends_lib-delete     $cdb($variant,dependsd)
                    depends_skip_archcheck $cdb($variant,dependsa)

                    $comp
                }
            }]
        }
    }
}

foreach variant ${compilers.gcc_variants} {
    # we need to check the default_variants so we can't use variant_isset
    if {[info exists variations($variant)] && $variations($variant) eq "+"} {
        depends_lib-delete      port:g95
        break
    }
}

proc c_active_variant_name {depspec} {
    global compilers.variants compilers.fortran_variants
    set c_list [remove_from_list ${compilers.variants} {gfortran g95}]

    foreach c $c_list {
        if {![catch {set result [active_variants $depspec $c ""]}]} {
            if {$result} {
                return $c
            }
        }
    }

    return ""
}

proc c_variant_name {} {
    global compilers.variants compilers.fortran_variants
    set c_list [remove_from_list ${compilers.variants} {gfortran g95}]

    foreach cc $c_list {
        if {[variant_isset $cc]} {
            return $cc
        }
    }

    return ""
}

proc fortran_active_variant_name {depspec} {
    global compilers.fortran_variants

    foreach fc ${compilers.fortran_variants} {
        if {![catch {set result [active_variants $depspec $fc ""]}]} {
            if {$result} {
                return $fc
            }
        }
    }

    return ""
}

proc fortran_variant_name {} {
    global compilers.fortran_variants variations

    foreach fc ${compilers.fortran_variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($fc)] && $variations($fc) eq "+"} {
            return $fc
        }
    }

    return ""
}

proc clang_variant_name {} {
    global compilers.clang_variants compilers.dragonegg_variants variations

    foreach c ${compilers.clang_variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($c)] && $variations($c) eq "+"} {
            return $c
        }
    }

    foreach c ${compilers.dragonegg_variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($c)] && $variations($c) eq "+"} {
            return $c
        }
    }

    return ""
}

proc clang_variant_isset {} {
    return [expr {[clang_variant_name] ne ""}]
}

proc gcc_variant_name {} {
    global compilers.gcc_variants variations

    foreach c ${compilers.gcc_variants} {
        # we need to check the default_variants so we can't use variant_isset
        if {[info exists variations($c)] && $variations($c) eq "+"} {
            return $c
        }
    }

    return ""
}

proc gcc_variant_isset {} {
    return [expr {[gcc_variant_name] ne ""}]
}

proc avx_compiler_isset {} {
    global configure.cc

    set cc ${configure.cc}

    # check for mpi
    if {[string match *mpi* $cc]} {
        set cc [exec ${configure.cc} -show]
    }

    if {[string match *clang* $cc]} {
        return 1
    }

    return 0
}

proc fortran_variant_isset {} {
    return [expr {[fortran_variant_name] ne ""}]
}

# remove all elements in R from L
proc remove_from_list {L R} {
    foreach e $R {
        set idx [lsearch $L $e]
        set L [lreplace $L $idx $idx]
    }
    return $L
}

# add all elements in R from L
proc add_from_list {L A} {
    return [concat $L $A]
}

proc compilers.choose {args} {
    global compilers.list

    # zero out the variable before and append args
    set compilers.list {}
    foreach v $args {
        lappend compilers.list $v
    }
}

proc compilers.is_fortran_only {} {
    global compilers.list

    foreach c {cc cxx cpp objc} {
        if {[lsearch -exact ${compilers.list} $c] >= 0} {
            return 0
        }
    }

    return 1
}

proc compilers.is_c_only {} {
    global compilers.list

    foreach c {f77 f90 fc} {
        if {[lsearch -exact ${compilers.list} $c] >= 0} {
            return 0
        }
    }

    return 1
}

# for the c compiler
proc compilers.enforce_c {args} {
    global compilers.required_c
    set compilers.required_c $args
}

proc compilers.action_enforce_c {args} {
    foreach portname $args {
        if {![catch {set result [active_variants $portname "" ""]}]} {
            set otcomp  [c_active_variant_name $portname]
            set mycomp  [c_variant_name]

            if {$otcomp ne "" && $mycomp eq ""} {
                default_variants +$otcomp
            } elseif {$otcomp ne $mycomp} {
                ui_error "Install $portname +$mycomp"
                return -code error "$portname +$mycomp not installed"
            }
        }
    }
}

proc compilers.enforce_fortran {args} {
    global compilers.required_f
    set compilers.required_f $args
}

proc compilers.action_enforce_f {args} {
    foreach portname $args {
        if {![catch {set result [active_variants $portname "" ""]}]} {
            set otf  [fortran_active_variant_name $portname]
            set myf  [fortran_variant_name]

            # gfortran is nothing more than the fortran compiler from gcc48
            set equiv 0
            if {($otf eq "gcc48" || $otf eq "gfortran") && ($myf eq "gcc48" || $myf eq "gfortran")} {
                set equiv 1
            }

            if {$otf ne "" && $myf eq ""} {
                default_variants +$otf
            } elseif {$otf ne $myf && !$equiv} {
                ui_error "Install $portname +$myf"
                return -code error "$portname +$myf not installed"
            }
        }
    }
}

proc compilers.setup {args} {
    global cdb compilers.variants compilers.clang_variants compilers.gcc_variants
    global compilers.dragonegg_variants compilers.fortran_variants
    global compilers.require_fortran compilers.setup_done compilers.list

    if {!${compilers.setup_done}} {
        set add_list {}
        set remove_list ${compilers.variants}

        # if we are only setting fortran compilers, then we are in "only fortran
        # mode", i.e. we just need +gccXY and +dragoneggXY for the fortran
        # compilers so we remove +clangXY and +llvm
        if {[compilers.is_fortran_only]} {
            # remove gfortran since that only exists to "complete" clang/llvm
            set remove_list [remove_from_list ${compilers.fortran_variants} gfortran]
        } elseif {[compilers.is_c_only]} {
            # remove gfortran and g95 since those are purely for fortran
            set remove_list [remove_from_list ${compilers.variants} {gfortran g95}]
        }

        foreach v $args {
            # if any negated compiler (e.g. -gcc47) is specified then we are
            # removing from the default, complete list
            set mode add
            if {[string first - $v] == 0} {
                set mode remove

                #strip the beginning '-' character
                set v [string range $v 1 end]
            }

            # handle special cases, such as 'gcc' -> all gcc variants
            switch -exact $v {
                gcc {
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] ${compilers.gcc_variants}]
                }
                dragonegg {
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] ${compilers.dragonegg_variants}]
                }
                fortran {
                    # here we just check gfortran and g95, not every fortran
                    # compatible variant since it makes more sense to specify
                    # 'fortran' to mean add just the +gfortran and +g95 variants
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] {gfortran g95}]

                }
                clang {
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] ${compilers.clang_variants}]
                }
                require_fortran {
                    # this signals that fortran is required and not optional
                    set compilers.require_fortran 1
                }
                default {
                    if {[info exists cdb($v,variant)] == 0} {
                        return -code error "no such compiler: $v"
                    }
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] $cdb($v,variant)]
                }
            }
        }

        # remove duplicates
        set duplicates {}
        foreach foo $remove_list {
            if {[lsearch $add_list $foo] != -1} {
                lappend duplicates $foo
            }
        }

        set compilers.variants [lsort [concat [remove_from_list $remove_list $duplicates] $add_list]]
        eval compilers.setup_variants ${compilers.variants}

        set compilers.setup_done 1
    }
}

# this might also need to be in pre-archivefetch
pre-fetch {
    if {${compilers.require_fortran} && [fortran_variant_name] eq ""} {
        return -code error "must set at least one fortran variant"
    }
    eval compilers.action_enforce_c ${compilers.required_c}
    eval compilers.action_enforce_f ${compilers.required_f}
}
