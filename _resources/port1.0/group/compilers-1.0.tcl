# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
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
# This PortGroup sets up default variants for projects that want multiple
# compilers for providing options for, example, different optimizations. More
# importantly, this port group provides the ability to interact with packages
# that need MPI since MPI is just a wrapper around a compiler.
#
# Usage:
#
#   PortGroup               compilers 1.0
#
# Available procedures:
# compilers.choose {args}
#   Possible arguments: cc cxx cpp objc fc f77 f90
#   A list of which of these compilers you want to be set by the variants (e.g. ${configure.cc}).
#   The default is all of them. Must come before compilers.setup in the Portfile to have an effect.
# compilers.set_variants_conflict {args}
#   Add specified variants to the conflicts list of all variants created by this PortGroup.
#   Useful if another compiler variant is created explicitly in the Portfile. Must come before compilers.setup.
# compilers.setup {args}
#   Possible arguments: any compiler variant name with a minus removes it from the list of variants, e.g. -llvm.
#   -gcc, -dragonegg, -clang remove all compilers of that category. -fortran removes gfortran and g95.
#   Blacklisted compilers are automatically removed, as are ones that do not support the compilers in compilers.choose:
#   e.g. if choose is just f90, clang variants will not be added.
#   List "default_fortran" to make a Fortran variant be selected by default.
#   This procedure must be in the Portfile to create all the compiler variants and set the default.
#   Appropriate conflicts, dependencies, etc. are created too.
#   If a variant is declared already in the Portfile before this line, it will not be redefined.
# c_active_variant_name {depspec}: which C variant a dependency has set
# c_variant_name {}: which C variant is set
# c_variant_isset {}: is a C variant set
# fortran_active_variant_name {depspec}: which Fortran variant a dependency has set
# fortran_variant_name {}: which Fortran variant is set
# fortran_compiler_name {arg}:  converts gfortran into the actual Fortran compiler name; otherwise returns arg
# clang_variant_isset {}: is a clang variant set
# clang_variant_name {}: which clang variant is set
# gcc_variant_isset {}: is a GCC variant set
# gcc_variant_name {}: which GCC variant is set
# avx_compiler_isset {}: is a C compiler supporting AVX set
# fortran_variant_isset {}: is a Fortran variant set
# compilers.enforce_c {args}: enforce that a dependency has the same C variant as is set here
# compilers.enforce_fortran {args}: enforce that a dependency has the same Fortran variant as is set here
# compilers.enforce_some_fortran {args}: enforce that a dependency has some Fortran variant set
#
# Options:
# compilers.clear_archflags: disable archflags ("-arch x86_64", -m64, etc.)
#
# The compilers.gcc_default variable may be useful for setting a default compiler variant
# even in ports that do not use this PortGroup's automatic creation of variants.
# compilers.libfortran is for use in linking Fortran code with the C or C++ compiler

PortGroup active_variants 1.1

options compilers.variants compilers.gcc_variants compilers.clear_archflags
default compilers.variants {}
default compilers.fortran_variants {}
default compilers.gcc_variants {}
default compilers.clang_variants {}
default compilers.dragonegg_variants {}
default compilers.require_fortran 0
default compilers.default_fortran 0
default compilers.setup_done 0
default compilers.required_c {}
default compilers.required_f {}
default compilers.required_some_f {}
default compilers.variants_conflict {}
default compilers.libfortran {}
default compilers.clear_archflags yes

# also set a default gcc version
if {${os.arch} eq "powerpc"} {
    # see https://trac.macports.org/ticket/54215#comment:36
    set compilers.gcc_default gcc6
} else {
    set compilers.gcc_default gcc7
}

set compilers.list {cc cxx cpp objc fc f77 f90}

# build database of gcc compiler attributes
set gcc_versions {44 45 46 47 48 49 5 6 7}
foreach v ${gcc_versions} {
    # if the string is more than one character insert a '.' into it: e.g 49 -> 4.9
    set version $v
    if {[string length $v] > 1} {
        set version [string index $v 0].[string index $v 1]
    }
    lappend compilers.gcc_variants gcc$v
    set cdb(gcc$v,variant)  gcc$v
    set cdb(gcc$v,compiler) macports-gcc-$version
    set cdb(gcc$v,descrip)  "MacPorts gcc $version"
    set cdb(gcc$v,depends)  port:gcc$v
    if {[vercmp ${version} 4.6] < 0} {
        set cdb(gcc$v,dependsl) "path:lib/libgcc/libgcc_s.1.dylib:libgcc port:libgcc6 port:libgcc45"
    } elseif {[vercmp ${version} 7] < 0} {
        set cdb(gcc$v,dependsl) "path:lib/libgcc/libgcc_s.1.dylib:libgcc port:libgcc6"
    } else {
        set cdb(gcc$v,dependsl) "path:lib/libgcc/libgcc_s.1.dylib:libgcc"
    }
    set cdb(gcc$v,libfortran) ${prefix}/lib/gcc$v/libgfortran.dylib
    # note: above is ultimately a symlink to ${prefix}/lib/libgcc/libgfortran.3.dylib
    set cdb(gcc$v,dependsd) port:g95
    set cdb(gcc$v,dependsa) gcc$v
    set cdb(gcc$v,conflict) "gfortran g95"
    set cdb(gcc$v,cc)       ${prefix}/bin/gcc-mp-$version
    set cdb(gcc$v,cxx)      ${prefix}/bin/g++-mp-$version
    set cdb(gcc$v,cpp)      ${prefix}/bin/cpp-mp-$version
    set cdb(gcc$v,objc)     ${prefix}/bin/gcc-mp-$version
    set cdb(gcc$v,fc)       ${prefix}/bin/gfortran-mp-$version
    set cdb(gcc$v,f77)      ${prefix}/bin/gfortran-mp-$version
    set cdb(gcc$v,f90)      ${prefix}/bin/gfortran-mp-$version
}

set clang_versions {33 34 35 36 37 38 39 40 50}
foreach v ${clang_versions} {
    # if the string is more than one character insert a '.' into it: e.g 33 -> 3.3
    set version $v
    if {[string length $v] > 1} {
        set version [string index $v 0].[string index $v 1]
    }
    lappend compilers.clang_variants clang$v
    set cdb(clang$v,variant)  clang$v
    set cdb(clang$v,compiler) macports-clang-$version
    set cdb(clang$v,descrip)  "MacPorts clang $version"
    set cdb(clang$v,depends)  port:clang-$version
    set cdb(clang$v,dependsl) ""
    set cdb(clang$v,libfortran) ""
    set cdb(clang$v,dependsd) ""
    set cdb(clang$v,dependsa) clang-$version
    set cdb(clang$v,conflict) ""
    set cdb(clang$v,cc)       ${prefix}/bin/clang-mp-$version
    set cdb(clang$v,cxx)      ${prefix}/bin/clang++-mp-$version
    set cdb(clang$v,cpp)      "${prefix}/bin/clang-mp-$version -E"
    set cdb(clang$v,objc)     ""
    set cdb(clang$v,fc)       ""
    set cdb(clang$v,f77)      ""
    set cdb(clang$v,f90)      ""
}

# dragonegg versions match the corresponding clang version until 3.5
set dragonegg_versions {3 4}
foreach v ${dragonegg_versions} {
    lappend compilers.dragonegg_variants dragonegg3$v
    set cdb(dragonegg3$v,variant)  dragonegg3$v
    set cdb(dragonegg3$v,compiler) macports-dragonegg-3.$v
    set cdb(dragonegg3$v,descrip)  "MacPorts dragonegg 3.$v"
    set cdb(dragonegg3$v,depends)  path:bin/dragonegg-3.$v-gcc:dragonegg-3.$v
    set cdb(dragonegg3$v,dependsl) path:lib/libgcc/libgcc_s.1.dylib:libgcc
    set cdb(dragonegg3$v,libfortran) ${prefix}/lib/gcc46/libgfortran.dylib
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
set cdb(llvm,libfortran) ""
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

# and lastly we add a gfortran and g95 variant for use with clang* and llvm; note that
# we don't need gfortran when we are in an "only-fortran" mode
set cdb(gfortran,variant)  gfortran
set cdb(gfortran,compiler) gfortran
set cdb(gfortran,descrip)  "$cdb(${compilers.gcc_default},descrip) Fortran"
set cdb(gfortran,depends)  $cdb(${compilers.gcc_default},depends)
set cdb(gfortran,dependsl) $cdb(${compilers.gcc_default},dependsl)
set cdb(gfortran,libfortran) $cdb(${compilers.gcc_default},libfortran)
set cdb(gfortran,dependsd) $cdb(${compilers.gcc_default},dependsd)
set cdb(gfortran,dependsa) $cdb(${compilers.gcc_default},dependsa)
set cdb(gfortran,conflict) $cdb(${compilers.gcc_default},conflict)
set cdb(gfortran,cc)       ""
set cdb(gfortran,cxx)      ""
set cdb(gfortran,cpp)      ""
set cdb(gfortran,objc)     ""
set cdb(gfortran,fc)       $cdb(${compilers.gcc_default},fc)
set cdb(gfortran,f77)      $cdb(${compilers.gcc_default},f77)
set cdb(gfortran,f90)      $cdb(${compilers.gcc_default},f90)

set cdb(g95,variant)  g95
set cdb(g95,compiler) g95
set cdb(g95,descrip)  "g95 Fortran"
set cdb(g95,depends)  port:g95
set cdb(g95,dependsl) ""
set cdb(g95,libfortran) ${prefix}/lib/g95/x86_64-apple-darwin14/4.2.4/libf95.a
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

foreach cname [array names cdb *,variant] {
    lappend compilers.variants $cdb($cname)
}

foreach variant ${compilers.variants} {
    if {$cdb($variant,f77) ne ""} {
        lappend compilers.fortran_variants $variant
    }
}

proc compilers.set_variants_conflict {args} {
    global compilers.variants_conflict

    lappend compilers.variants_conflict $args
}

proc compilers.setup_variants {args} {
    global cdb compilers.variants compilers.clang_variants compilers.gcc_variants
    global compilers.dragonegg_variants compilers.fortran_variants compilers.list
    global compilers.variants_conflict
    global compilers.clear_archflags

    foreach variant [split $args] {
        if {$cdb($variant,f77) ne ""} {
            lappend compilers.fortran_variants $variant
        }

        if {[variant_exists $variant]} {
            ui_debug "$variant variant already exists, so not adding the default one"
        } else {
            set i [lsearch -exact ${compilers.variants} $variant]
            set c [lreplace ${compilers.variants} $i $i]

            # Fortran compilers do not conflict with C compilers.
            # thus, llvm and clang do not conflict with g95 and gfortran
            if {$variant eq "gfortran" || $variant eq "g95"} {
                foreach clangcomp [concat ${compilers.clang_variants} {llvm}] {
                    set i [lsearch -exact $c $clangcomp]
                    set c [lreplace $c $i $i]
                }
            } elseif {[string match clang* $variant] || $variant == "llvm"} {
                set i [lsearch -exact $c gfortran]
                set c [lreplace $c $i $i]
                set i [lsearch -exact $c g95]
                set c [lreplace $c $i $i]
            }

            # only add conflicts from the compiler database (set above) if we
            # actually have the compiler in the list of allowed variants
            foreach j $cdb($variant,conflict) {
                if {[lsearch -exact $j ${compilers.variants}] > -1} {
                    lappend c $j
                }
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
                        if {${compilers.clear_archflags} && "[info command configure.${compiler}_archflags]" ne ""} {
                            configure.${compiler}_archflags
                            configure.ld_archflags
                        }
                    }]
                }
            }

            eval [subst {
                variant ${variant} description \
                    {Build using the $cdb($variant,descrip) compiler} \
                    conflicts $c ${compilers.variants_conflict} {

                    depends_build-append   $cdb($variant,depends)
                    depends_lib-append     $cdb($variant,dependsl)
                    depends_lib-delete     $cdb($variant,dependsd)
                    depends_skip_archcheck $cdb($variant,dependsa)

                    set compilers.libfortran $cdb($variant,libfortran)
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
        } else {
            ui_warn "c_active_variant_name: \[active_variants $depspec $fc \"\"\] fails."
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

proc c_variant_isset {} {
    return [expr {[c_variant_name] ne ""}]
}

proc fortran_active_variant_name {depspec} {
    global compilers.fortran_variants

    foreach fc ${compilers.fortran_variants} {
        if {![catch {set result [active_variants $depspec $fc ""]}]} {
            if {$result} {
                return $fc
            }
        } else {
            ui_warn "fortran_active_variant_name: \[active_variants $depspec $fc \"\"\] fails."
        }
    }

    return ""
}

proc fortran_compiler_name {variant} {
    global compilers.gcc_default

    if {$variant eq "gfortran"} {
        return ${compilers.gcc_default}
    } else {
        return $variant
    }
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
    global compilers.list compilers.setup_done

    if {${compilers.setup_done}} {
        ui_warn "compilers.choose has an effect only before compilers.setup."
    }

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

proc compilers.enforce_c {args} {
    global compilers.required_c
    foreach portname $args {
        lappend compilers.required_c $portname
    }
}

proc compilers.action_enforce_c {args} {
    ui_debug "compilers.enforce_c list: ${args}"
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
        } else {
            ui_error "Internal error: compilers.enforce_c: '$portname' is not an installed port."
            return -code error "Internal error: compilers.enforce_c: '$portname' is not an installed port."
        }
    }
}

proc compilers.enforce_fortran {args} {
    global compilers.required_f
    foreach portname $args {
        lappend compilers.required_f $portname
    }
}

proc compilers.enforce_some_fortran {args} {
    global compilers.required_some_f
    foreach portname $args {
        lappend compilers.required_some_f $portname
    }
}

proc compilers.action_enforce_f {args} {
    ui_debug "compilers.enforce_fortran list: ${args}"
    foreach portname $args {
        if {![catch {set result [active_variants $portname "" ""]}]} {
            set otf  [fortran_active_variant_name $portname]
            set myf  [fortran_variant_name]

            if {$otf ne "" && $myf eq ""} {
                default_variants +$otf
            } elseif {[fortran_compiler_name $otf] ne [fortran_compiler_name $myf]} {
                # what if $portname does not have that variant? e.g. maybe it has only gcc5 and we are asking for gfortran.
                ui_error "Install $portname +$myf"
                return -code error "$portname +$myf not installed"
            }
        } else {
            ui_error "Internal error: compilers.enforce_fortran: '$portname' is not an installed port."
            return -code error "Internal error: compilers.enforce_fortran: '$portname' is not an installed port."
        }
    }
}

proc compilers.action_enforce_some_f {args} {
    ui_debug "compilers.enforce_some_fortran list: ${args}"
    foreach portname $args {
        if {![catch {set result [active_variants $portname "" ""]}]} {
            if {[fortran_active_variant_name $portname] eq ""} {
                ui_error "Install $portname with a Fortran variant (e.g. +gfortran, +gccX, +g95)"
                return -code error "$portname not installed with a Fortran variant"
            }
        } else {
            ui_error "Internal error: compilers.enforce_some_fortran: '$portname' is not an installed port."
            return -code error "Internal error: compilers.enforce_some_fortran: '$portname' is not an installed port."
        }
    }
}

proc compilers.setup {args} {
    global cdb compilers.variants compilers.clang_variants compilers.gcc_variants
    global compilers.dragonegg_variants compilers.fortran_variants
    global compilers.require_fortran compilers.default_fortran compilers.setup_done compilers.list
    global compilers.gcc_default
    global compiler.blacklist

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
                    set compilers.default_fortran 1
                }
                default_fortran {
                    set compilers.default_fortran 1
                }
                default {
                    if {[info exists cdb($v,variant)] == 0} {
                        return -code error "no such compiler: $v"
                    }
                    set ${mode}_list [${mode}_from_list [expr $${mode}_list] $cdb($v,variant)]
                }
            }
        }

        # also remove compilers blacklisted
        foreach compiler ${compiler.blacklist} {
            set matched no
            foreach variant ${compilers.variants} {
                if {[string match $compiler $cdb($variant,compiler)]} {
                    set matched yes
                    set remove_list [remove_from_list $remove_list $cdb($variant,variant)]
                }
            }

            if {!$matched} {
                ui_debug "Unmatched blacklisted compiler: $compiler"
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

        # reverse the gcc list so that the higher numbered ones are default
        set ordered_variants {gfortran}
        set seen 0
        for {set i [llength ${compilers.gcc_variants}]} {[incr i -1] >= 0} {} {
            # only add entries after the default gcc (the ones before are
            # considered beta)
            set v [lindex ${compilers.gcc_variants} $i]
            if {${compilers.gcc_default} eq $v} {
                set seen 1
            }

            if {$seen} {
                lappend ordered_variants $v
            }
        }
        lappend ordered_variants {g95}

        if {${compilers.default_fortran} && ![fortran_variant_isset]} {
            foreach fv $ordered_variants {
                # if the variant exists, then make it default
                if {[lsearch -exact ${compilers.variants} $fv] > -1} {
                    default_variants-append +$fv
                    break
                }
            }
        }

        set compilers.setup_done 1
    }
}

# this might also need to be in pre-archivefetch
pre-fetch {
    if {${compilers.require_fortran} && [fortran_variant_name] eq ""} {
        return -code error "must set at least one Fortran variant (e.g. +gfortran, +gccX, +g95)"
    }
    eval compilers.action_enforce_c ${compilers.required_c}
    eval compilers.action_enforce_f ${compilers.required_f}
    eval compilers.action_enforce_some_f ${compilers.required_some_f}
}
