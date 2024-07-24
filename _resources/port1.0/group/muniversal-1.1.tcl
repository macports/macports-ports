# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

##########################################################################################
# change defaults from
# https://github.com/macports/macports-base/blob/master/src/port1.0/portconfigure.tcl
##########################################################################################

# disabling dependency tracking is only required when building for multiple architectures simultaneously
default configure.universal_args {}

# adding arch flags are handled elsewhere in the PortGroup
foreach tool {cc objc cxx objcxx fc f90 f77 ld} {
    default configure.${tool}_archflags {}
}
foreach lang {c objc cxx objcxx cpp ld} {
    default configure.universal_${lang}flags {}
}
unset lang tool

##########################################################################################
# means of reducing possible architectures
##########################################################################################

# if yes, build platform must be able to run binaries for supported architectures
options muniversal.run_binaries
default muniversal.run_binaries {no}

# if yes, merger will not work correctly if there are three supported architectures
options muniversal.no_3_archs
default muniversal.no_3_archs {no}

##########################################################################################
# for merging
##########################################################################################

# list of file names for which diff will not work
options muniversal.dont_diff
default muniversal.dont_diff {}

# list of file name whose contents just need to be interlaced
options muniversal.combine
default muniversal.combine  {}

# list of file names whose contents are equivalent but not byte by byte the same
options muniversal.equivalent
default muniversal.equivalent {}

##########################################################################################
# utilites
##########################################################################################

# allow `foreach arch ${muniversal.architectures} { ... }` to be used regardless of whether +universal set or not
options muniversal.architectures
default muniversal.architectures {[expr {[option universal_possible] && [variant_isset universal] ? ${configure.universal_archs} : ${configure.build_arch}}]}

# procedures (pre-configure, configure, post-configure, etc.) will be run for each architecture
# muniversal.build_arch will be set to the current architecture
options muniversal.build_arch
default muniversal.build_arch {[expr {[option universal_possible] && [variant_isset universal] ? "" : [expr {$supported_archs ne "noarch" ? ${configure.build_arch} : ${build_arch}}]}]}

# if yes, system can run 64-bit binaries
options os.cpu64bit_capable
default os.cpu64bit_capable {[muniversal::cpu64bit_capable]}

##########################################################################################
# how to set architecture flag
##########################################################################################

# if yes, set architecture in compiler flags
options muniversal.arch_flag
default muniversal.arch_flag {yes}

# if yes, append architecture flag to compiler name
options muniversal.arch_compiler
default muniversal.arch_compiler {no}

# if yes, append architecture flag to build compiler name
options muniversal.arch_build_compiler
default muniversal.arch_build_compiler  {${muniversal.arch_compiler}}

##########################################################################################
# MacPorts options for different architectures
##########################################################################################
foreach phase {configure build test destroot} {
    foreach command {pre_args args post_args env} {
        foreach arch {arm64 x86_64 i386 ppc ppc64} {
            options ${phase}.${command}.${arch}
            if {"${phase}.${command}" eq "configure.pre_args"} {
                default ${phase}.${command}.${arch} "\[muniversal::get_triplets ${arch}\]"
            } else {
                default ${phase}.${command}.${arch} {}
            }
        }
    }
}
unset phase command arch

foreach arch {arm64 x86_64 i386 ppc ppc64} {
    options patchfiles.${arch}
}
unset arch

foreach arch {arm64 x86_64 i386 ppc ppc64} {
    foreach flags {cppflags cflags cxxflags objcflags objcxxflags ldflags fflags f90flags fcflags} {
        options configure.${flags}.${arch}
        default configure.${flags}.${arch} {}
    }
}
unset flags arch

foreach arch {arm64 x86_64 i386 ppc ppc64} {
    foreach tool {cc objc cxx objcxx fc f90 f77 ld} {
        options configure.${tool}_archflags.${arch}
        default configure.${tool}_archflags.${arch} "\[muniversal::get_archflag ${tool} ${arch}\]"
    }
}
unset tool arch

##########################################################################################
# determine which architectures are different and which ones can be run via Rosetta
##########################################################################################
foreach arch {arm64 x86_64 i386 ppc ppc64} {
    options muniversal.can_run.${arch}
    options muniversal.is_cross.${arch}
}
unset arch

default muniversal.can_run.arm64    {[expr { ${os.arch} eq "arm"}]}
default muniversal.can_run.x86_64   {[expr { (${os.arch} eq "i386" && ${os.cpu64bit_capable}) || (${os.arch} eq "arm" && ${os.major} < 2147483647) }]}
default muniversal.can_run.i386     {[expr { ${os.arch} eq "i386" && ${os.major} < 19 }]}
default muniversal.can_run.ppc      {[expr { ${os.arch} eq "powerpc" || (${os.arch} eq "i386" && ${os.major} < 11) }]}
default muniversal.can_run.ppc64    {[expr { ${os.arch} eq "powerpc" && ${os.cpu64bit_capable} }]}

default muniversal.is_cross.arm64   {[expr { ${os.arch} ne "arm" }]}
default muniversal.is_cross.x86_64  {[expr { ${os.arch} ne "i386" || !${os.cpu64bit_capable} }]}
default muniversal.is_cross.i386    {[expr { ${os.arch} ne "i386" || ${os.major} >= 19 }]}
default muniversal.is_cross.ppc     {[expr { ${os.arch} ne "powerpc" }]}
default muniversal.is_cross.ppc64   {[expr { ${os.arch} ne "powerpc" || !${os.cpu64bit_capable} }]}

##########################################################################################
# triplet information
# see https://wiki.osdev.org/Target_Triplet
##########################################################################################
options triplet.vendor
default triplet.vendor      {[expr {${os.platform} eq "darwin" ? "apple" : "unknown"}]}

options triplet.os
default triplet.os          {${os.platform}${os.major}}

options triplet.host_cmd
default triplet.host_cmd    {--host=}

options triplet.build_cmd
default triplet.build_cmd   {--build=}

# possible values: none, all, cross, or a list of architectures
options triplet.add_host
default triplet.add_host    {cross}

# possible values: none, all, cross, or a list of architectures
options triplet.add_build
default triplet.add_build   {none}

foreach arch {arm64 x86_64 i386 ppc ppc64} {
    options triplet.cpu.${arch}
}
unset arch

default triplet.cpu.arm64  {aarch64}
default triplet.cpu.x86_64 {x86_64}
default triplet.cpu.i386   {i686}
default triplet.cpu.ppc    {powerpc}
default triplet.cpu.ppc64  {powerpc64}

foreach arch {arm64 x86_64 i386 ppc ppc64} {
    options triplet.${arch}
    default triplet.${arch} "\${triplet.cpu.${arch}}-\${triplet.vendor}-\${triplet.os}"
}
unset arch

##########################################################################################
# for cross-compiling, some configure scripts recognize
#     CPPFLAGS_FOR_BUILD
#     CFLAGS_FOR_BUILD
#     CXXFLAGS_FOR_BUILD
#     LDFLAGS_FOR_BUILD
##########################################################################################
options configure.cppflags_for_build
default configure.cppflags_for_build                {${configure.cppflags}}

options configure.cflags_for_build
default configure.cflags_for_build                  {${configure.cflags}}

options configure.cxxflags_for_build
default configure.cxxflags_for_build                {${configure.cxxflags}}

options configure.ldflags_for_build
default configure.ldflags_for_build                 {${configure.ldflags}}

# this is a seldom needed feature where XFLAGS_FOR_BUILD are appended to the X compiler
options configure.append_build_flags_to_compiler
default configure.append_build_flags_to_compiler    {no}

namespace eval muniversal {}

####################################################################################################################################
# internal procedures
####################################################################################################################################

# the diff utility in macOS Ventura does not have the same functionality as previous versions
# see https://trac.macports.org/ticket/66103
# see https://trac.macports.org/ticket/66163
proc muniversal::muniversal_get_diff_to_use {} {
    global prefix
    if { [option os.platform] eq "darwin" && [option os.major] >= 22 } {
        return "${prefix}/libexec/diffutils/bin/diff"
    } else {
        return "/usr/bin/diff"
    }
}

# a version of `sysctl hw.cpu64bit_capable` that works on older systems
# see https://trac.macports.org/ticket/25873
proc muniversal::cpu64bit_capable {} {
    if {[option os.platform] ne "darwin"} {
        # Doesn't really matter what we return here.
        return 1
    }
    if {[option os.major] >= 11} {
        # 10.7 and later only support 64-bit hardware
        return 1
    } elseif {[option os.major] >= 9 && ![catch {sysctl hw.cpu64bit_capable} result]} {
        return $result
    } elseif {(![catch {sysctl hw.optional.x86_64} is_x86_64] && ${is_x86_64})
              || (![catch {sysctl hw.optional.64bitops} is_ppc64] && ${is_ppc64})} {
        return 1
    } else {
        return 0
    }
}

# assemble `--build=...` and `--host=...` list based on triplet.* options
proc muniversal::get_triplets {arch} {
    global triplet.add_host triplet.add_build os.arch os.cpu64bit_capable

    if { [file tail [option configure.cmd]] in [list cmake meson printenv] }  { return [list] }

    set ret [list]

    if { ${triplet.add_host} eq "all"
         || ${arch} in ${triplet.add_host}
         || ("cross" in ${triplet.add_host} && [option muniversal.is_cross.${arch}])
     } {
        lappend ret "[option triplet.host_cmd][option triplet.${arch}]"
    }

    if { ${triplet.add_build} eq "all"
         || ${arch} in ${triplet.add_build}
         || ("cross" in ${triplet.add_build} && [option muniversal.is_cross.${arch}])
     } {
        if { [option muniversal.is_cross.${arch}] } {
            set cpu_arch [option configure.build_arch]
        } else {
            set cpu_arch ${arch}
        }
        lappend ret "[option triplet.build_cmd][option triplet.${cpu_arch}]"
    }

    return ${ret}
}

# get current architecture in a way that tries to detect invalid states
proc muniversal::get_build_arch {} {
    global muniversal.build_arch
    if { ${muniversal.build_arch} eq "" } {
        ui_error "universal: merge: architecture is not set"
        return -code error "unknown architecture (empty)"
    } else {
        return ${muniversal.build_arch}
    }
}

# map directory to name to architecture-dependent version
proc muniversal::get_arch_dir {dir arch} {
    global worksrcpath configure.dir

    if { [string match "${worksrcpath}/*" ${dir}] } {
        # the directory is inside the source directory, so put in the new source directory name
        return [string map "${worksrcpath} ${worksrcpath}-${arch}" ${dir}]
    } elseif { [string match "${configure.dir}/*" ${dir}] } {
        # the directory is outside the source directory but is a subdirectory of ${configure.dir}, so
        #    append ${arch} to the ${configure.dir} part
        return [string map "${configure.dir} ${configure.dir}-${arch}" ${dir}]
    } else {
        # the directory is outside the source directory and ${configure.dir}, so
        #    give it a new name by appending ${arch}
        return ${dir}-${arch}
    }
}

# map `${worksrcpath}` to architecture-dependent version in phase command
# for example, `configure.cmd ${worksrcpath}/configure` --> `configure.cmd ${worksrcpath}-${arch}/configure`
proc muniversal::map_phase {dir_save dir phase_cmd} {
    return [string map "${dir_save} ${dir}" ${phase_cmd}]
}

# get architecture flag for a given tool
# prefer `-arch ${arch}` for C-type languages and linker (if possible)
# prefer `-m32` or `-m64` for Fortran language
#
# see `portconfigure::configure_get_archflags` and `portconfigure::configure_get_ld_archflags` in
#     https://github.com/macports/macports-base/blob/master/src/port1.0/portconfigure.tcl
#
proc muniversal::get_archflag {tool arch} {
    global configure.compiler

    if { [portconfigure::arch_flag_supported ${configure.compiler}] && ${tool} in {cc cxx objc objcxx ld} } {
        return "-arch ${arch}"
    } elseif { ${arch} in {arm64 ppc64 x86_64} } {
        return "-m64"
    } elseif {${configure.compiler} ne "gcc-3.3"} {
        return "-m32"
    } else {
        return ""
    }
}

# [muniversal::file_or_symlink_exists ${f}] tells you if ${f} exists
# uunlike [file exists ${f}], if used on a symlink, [muniversal::file_or_symlink_exists ${f}]
# tells you about the symlink, not what it points to
proc muniversal::file_or_symlink_exists {f} {
    # if [file type ${f}] throws an error, ${f} doesn't existx
    if {[catch {file type ${f}}]} {
        return no
    }
    # otherwise, it does
    return yes
}

# merge two files (${dir1}/${fl} and ${dir2}/${fl}) to ${dir}/${fl}
# by stripping out -arch XXXX, -m32, and -m64
proc muniversal::strip_arch_flags {dir1 dir2 dir fl} {
    set tempdir [mkdtemp "/tmp/muniversal.XXXXXXXX"]
    set tempfile1 "${tempdir}/1-${fl}"
    set tempfile2 "${tempdir}/2-${fl}"

    copy ${dir1}/${fl} ${tempfile1}
    copy ${dir2}/${fl} ${tempfile2}

    set re {(-m32|-m64|-arch +[0-9a-zA-Z_]+|(--host|host_alias)=[0-9a-zA-Z_.-]+)}
    reinplace -q -E "s: *(${re}|'${re}'|\"${re}\")::g" ${tempfile1} ${tempfile2}

    if { ! [catch {system "/usr/bin/cmp -s \"${tempfile1}\" \"${tempfile2}\""}] } {
        # modified files are identical
        ui_debug "universal: merge: ${fl} differs in ${dir1} and ${dir2} but are the same when stripping out -m32, -m64, -arch *, --host=*, and host_alias=*"
        copy ${tempfile1} ${dir}/${fl}
        delete ${tempfile1} ${tempfile2} ${tempdir}
    } else {
        delete ${tempfile1} ${tempfile2} ${tempdir}
        return -code error "${fl} differs in ${dir1} and ${dir2} and cannot be merged"
    }
}

# merge two files (${dir1}/${fl} and ${dir2}/${fl}) to ${dir}/${fl}
# by stripping out -${arch} (e.g. from a directory name)
proc muniversal::strip_dir_arch {arch1 arch2 dir1 dir2 dir fl} {
    set tempdir [mkdtemp "/tmp/muniversal.XXXXXXXX"]
    set tempfile1 "${tempdir}/1-${fl}"
    set tempfile2 "${tempdir}/2-${fl}"

    copy ${dir1}/${fl} ${tempfile1}
    copy ${dir2}/${fl} ${tempfile2}

    reinplace -q -E "s:-${arch1}::g" ${tempfile1}
    reinplace -q -E "s:-${arch2}::g" ${tempfile2}

    if { ! [catch {system "/usr/bin/cmp -s \"${tempfile1}\" \"${tempfile2}\""}] } {
        # modified files are identical
        ui_debug "universal: merge: ${fl} differs in ${dir1} and ${dir2} but are the same when stripping out -${arch1} and ${arch2}"
        copy ${tempfile1} ${dir}/${fl}
        delete ${tempfile1} ${tempfile2} ${tempdir}
    } else {
        delete ${tempfile1} ${tempfile2} ${tempdir}
        return -code error "${fl} differs in ${dir1} and ${dir2} and cannot be merged"
    }
}

# merge ${base1}/${prefixDir} and ${base2}/${prefixDir} into dir ${base}/${prefixDir}
#        arch1, arch2: names to prepend to files if a diff merge of two files is forbidden by merger_dont_diff
#    merger_dont_diff: list of files for which diff ${diffFormat} will not merge correctly
#      merger_combine: list of files whose different contents just need to be interlaced
#          diffFormat: format used by diff to merge two text files
proc muniversal::merge {base1 base2 base prefixDir arch1 arch2 merger_dont_diff merger_combine merger_equivalent diffFormat} {
    set dir1  ${base1}/${prefixDir}
    set dir2  ${base2}/${prefixDir}
    set dir   ${base}/${prefixDir}

    xinstall -d -m 0755 ${dir}

    foreach fl [glob -directory ${dir2} -tails -nocomplain * .*] {
        if {${fl} in [list . ..]} {
            continue
        }
        if { ![muniversal::file_or_symlink_exists ${dir1}/${fl}] } {
            # File only exists in ${dir1}.
            ui_debug "universal: merge: ${prefixDir}/${fl} only exists in ${base2}"
            copy ${dir2}/${fl} ${dir}
        }
    }
    foreach fl [glob -directory ${dir1} -tails -nocomplain * .*] {
        if {${fl} in [list . ..]} { continue }
        if { ![muniversal::file_or_symlink_exists ${dir2}/${fl}] } {
            # file only exists in ${dir2}
            ui_debug "universal: merge: ${prefixDir}/${fl} only exists in ${base1}"
            copy ${dir1}/${fl} ${dir}
        } else {
            # file exists in ${dir1} and ${dir2}
            ui_debug "universal: merge: merging ${prefixDir}/${fl} from ${base1} and ${base2}"

            # ensure files are of same type
            if {[file type ${dir1}/${fl}] ne [file type ${dir2}/${fl}]} {
                error "${dir1}/${fl} and ${dir2}/${fl} are of different types"
            }

            if {[file type ${dir1}/${fl}] eq "link"} {
                # files are links
                ui_debug "universal: merge: ${prefixDir}/${fl} is a link"

                # ensure links don't point to different things
                if {[file readlink ${dir1}/${fl}] eq [file readlink ${dir2}/${fl}]} {
                    copy ${dir1}/${fl} ${dir}
                } else {
                    error "${dir1}/${fl} and ${dir2}/${fl} point to different targets (can't merge them)"
                }
            } elseif { [file isdirectory ${dir1}/${fl}] } {
                # files are directories (but not links), so recursively call function
                muniversal::merge ${base1} ${base2} ${base} ${prefixDir}/${fl} ${arch1} ${arch2} ${merger_dont_diff} ${merger_combine} ${merger_equivalent} ${diffFormat}
            } else {
                # files are neither directories nor links
                if { ! [catch {system "/usr/bin/cmp -s \"${dir1}/${fl}\" \"${dir2}/${fl}\" && /bin/cp -v \"${dir1}/${fl}\" \"${dir}\""}] } {
                    # files are byte by byte the same
                    ui_debug "universal: merge: ${prefixDir}/${fl} is identical in ${base1} and ${base2}"
                } else {
                    # actually try to merge the files
                    # first try lipo, then libtool
                    if { ! [catch {system "/usr/bin/lipo -create \"${dir1}/${fl}\" \"${dir2}/${fl}\" -output \"${dir}/${fl}\""}] } {
                        # lipo worked
                        ui_debug "universal: merge: lipo created ${prefixDir}/${fl}"
                    } elseif { ! [catch {system "/usr/bin/libtool \"${dir1}/${fl}\" \"${dir2}/${fl}\" -o \"${dir}/${fl}\""}] } {
                        # libtool worked
                        ui_debug "universal: merge: libtool created ${prefixDir}/${fl}"
                    } else {
                        # lipo and libtool have failed, so assume they are text files to be merged
                        if {"${prefixDir}/${fl}" in ${merger_dont_diff}} {
                            # user has specified that diff does not work
                            # attempt to give each file a unique name and create a new file which includes one of the original depending on the arch

                            set fh [open ${dir}/${arch1}-${fl} w 0644]
                            puts ${fh} "#include \"${arch1}-${fl}\""
                            close ${fh}

                            set fh [open ${dir}/${arch2}-${fl} w 0644]
                            puts ${fh} "#include \"${arch2}-${fl}\""
                            close ${fh}

                            ui_debug "universal: merge: created ${prefixDir}/${fl} to include ${prefixDir}/${arch1}-${fl} ${prefixDir}/${arch1}-${fl}"

                            system "[muniversal::muniversal_get_diff_to_use] -d ${diffFormat} \"${dir}/${arch1}-${fl}\" \"${dir}/${arch2}-${fl}\" > \"${dir}/${fl}\"; test \$? -le 1"

                            copy -force ${dir1}/${fl} ${dir}/${arch1}-${fl}
                            copy -force ${dir2}/${fl} ${dir}/${arch2}-${fl}
                        } elseif {"${prefixDir}/${fl}" in ${merger_combine}} {
                            # user has specified that contents just need to be interlaced
                            set diffFormatCombine {--old-group-format='%<' --new-group-format='%>' --unchanged-group-format='%=' --changed-group-format='%<%>'}
                            ui_debug "universal: merge: created ${prefixDir}/${fl} by combining ${prefixDir}/${arch1}-${fl} ${prefixDir}/${arch1}-${fl}"
                            system "[muniversal::muniversal_get_diff_to_use] -dw ${diffFormatCombine} \"${dir1}/${fl}\" \"${dir2}/${fl}\" > \"${dir}/${fl}\"; test \$? -le 1"
                        } elseif {"${prefixDir}/${fl}" in ${merger_equivalent}} {
                            # user has specified that contents  are equivalent even though they are not byte by byte the same
                            ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2} the differences have been marked as trivial"
                            copy ${dir1}/${fl} ${dir}
                        } else {
                            # files could not be merged into a fat binary
                            # handle known file types
                            switch -glob ${fl} {
                                *.mod {
                                    # .mod files from Fortran modules
                                    # create a sepcial module directory for each architecture
                                    # to find these modules, GFortran might require -M or -J
                                    file mkdir ${dir}/mods32
                                    file mkdir ${dir}/mods64
                                    if {${arch1} in [list i386 ppc]} {
                                        copy ${dir1}/${fl} ${dir}/mods32
                                        copy ${dir2}/${fl} ${dir}/mods64
                                    } else {
                                        copy ${dir2}/${fl} ${dir}/mods32
                                        copy ${dir1}/${fl} ${dir}/mods64
                                    }
                                }
                                *.pc -
                                *-config {
                                    muniversal::strip_arch_flags ${dir1} ${dir2} ${dir} ${fl}
                                }
                                *.la {
                                    if {[option destroot.delete_la_files]} {
                                        ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2}; ignoring due to delete_la_files"
                                    } else {
                                        return -code error "${prefixDir}/${fl} differs in ${base1} and ${base2} and cannot be merged"
                                    }
                                }
                                *.typelib {
                                    # sometimes garbage ends up in ignored trailing bytes
                                    # https://trac.macports.org/ticket/39629
                                    # TODO: compare the g-ir-generate output
                                    ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2}; assume trivial difference"
                                    copy ${dir1}/${fl} ${dir}
                                }
                                *.pyc {
                                    # pyc files should be same across architectures
                                    # the timestamp is recorded, however
                                    ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2}; assume trivial difference"
                                    copy ${dir1}/${fl} ${dir}
                                }
                                *.gir {
                                    muniversal::strip_dir_arch ${arch1} ${arch2} ${dir1} ${dir2} ${dir} ${fl}
                                }
                                *.elc {
                                    # elc files can be different because they record when and where they were built.
                                    ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2}; assume trivial difference"
                                    copy ${dir1}/${fl} ${dir}
                                }
                                *.el.gz -
                                *.el.bz2 {
                                    # Emacs lisp files should be same across architectures
                                    # the emacs package (and perhaps others) records the date of automatically generated el files
                                    ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2}; assume trivial difference"
                                    copy ${dir1}/${fl} ${dir}
                                }
                                *.lzma -
                                *.xz -
                                *.gz -
                                *.zip -
                                *.jar -
                                *.bz2 {
                                    # compressed files can differ due to entropy
                                    switch -glob ${fl} {
                                        *.lzma {
                                            set cat ${prefix}/bin/lzcat
                                        }
                                        *.xz {
                                            set cat ${prefix}/bin/xzcat
                                        }
                                        *.gz {
                                            set cat /usr/bin/gzcat
                                        }
                                        *.zip {
                                            set cat "/usr/bin/unzip -p"
                                        }
                                        *.jar {
                                            set cat "/usr/bin/unzip -p"
                                        }
                                        *.bz2 {
                                            set cat /usr/bin/bzcat
                                        }
                                    }
                                    set tempdir [mkdtemp "/tmp/muniversal.XXXXXXXX"]
                                    set tempfile1 "${tempdir}/${arch1}-[file rootname ${fl}]"
                                    set tempfile2 "${tempdir}/${arch2}-[file rootname ${fl}]"
                                    system "${cat} \"${dir1}/${fl}\" > \"${tempfile1}\""
                                    system "${cat} \"${dir2}/${fl}\" > \"${tempfile2}\""
                                    if { ! [catch {system "/usr/bin/cmp -s \"${tempfile1}\" \"${tempfile2}\""}] } {
                                        # files are identical
                                        ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2} but the contents are the same"
                                        copy ${dir1}/${fl} ${dir}
                                        delete ${tempfile1} ${tempfile2} ${tempdir}
                                    } else {
                                        delete ${tempfile1} ${tempfile2} ${tempdir}
                                        return -code error "${prefixDir}/${fl} differs in ${base1} and ${base2} and cannot be merged"
                                    }
                                }
                                default {
                                    if { ! [catch {system "test \"`head -c2 ${dir1}/${fl}`\" = '#!'"}] } {
                                        # shell script, hopefully striping out arch flags works...
                                        muniversal::strip_arch_flags ${dir1} ${dir2} ${dir} ${fl}
                                    } elseif { ! [catch {system "[muniversal::muniversal_get_diff_to_use] -dw ${diffFormat} \"${dir1}/${fl}\" \"${dir2}/${fl}\" > \"${dir}/${fl}\"; test \$? -le 1"}] } {
                                        # diff worked
                                        ui_debug "universal: merge: used diff to create ${prefixDir}/${fl}"
                                    } else {
                                        # File created by diff is invalid
                                        delete ${dir}/${fl}
                                        return -code error "${prefixDir}/${fl} differs in ${base1} and ${base2} and cannot be merged"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

##########################################################################################
# change base behavior
##########################################################################################

# get default supported architectures then further restrict them depending on muniversal options
rename portconfigure::choose_supported_archs portconfigure::choose_supported_archs_real
proc portconfigure::choose_supported_archs {archs} {
    global  os.arch

    set universal_archs_supported [portconfigure::choose_supported_archs_real ${archs}]

    # user has specified that build platform must be able to run binaries for supported architectures
    if {[option muniversal.run_binaries]} {
        foreach arch {arm64 x86_64 i386 ppc ppc64} {
            if { ![option muniversal.can_run.${arch}] } {
                set universal_archs_supported [ldelete ${universal_archs_supported} ${arch}]
            }
        }
    }

    # if muniversal.no_3_archs is yes, prune universal_archs_supported until it only has two elements
    if {[option muniversal.no_3_archs]} {
        if { [llength ${universal_archs_supported}] >= 3 } {
            # first, try to remove ppc64 unless we're powerpc
            if {${os.arch} ne "powerpc"} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "ppc64"]
            }
        }

        if { [llength ${universal_archs_supported}] >= 3 } {
            # next, delete archs that are not evolutionarilary adjacent
            if {${os.arch} eq "powerpc"} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "arm64"]
            } elseif {${os.arch} eq "arm"} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "ppc"]
            }
        }

        if { [llength ${universal_archs_supported}] >= 3 } {
            # next continue to prune architectures that are not evolutionarilary adjacent
            if {${os.arch} eq "arm"} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "i386"]
            } elseif {${os.arch} eq "powerpc"} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "x86_64"]
            }
        }

        # arm64 hosts should be down to arm64 + x86_64 at this point
        # i386 hosts should be down to ppc + i386 + x86_64 at this point
        # powerpc hosts should be down to ppc + ppc64 + i386 at this point

        if { [llength ${universal_archs_supported}] >= 3 } {
            # lastly, remove remaining cross-compiled arch
            if {${os.arch} eq "powerpc"} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "i386"]
            } elseif {${os.arch} eq "i386"} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "ppc"]
            }
        }

        if { [llength ${universal_archs_supported}] >= 3 } {
            # at least one arch should have been removed from universal_archs_supported
            error "Should Not Happen"
        }
    }

    return ${universal_archs_supported}
}

# make use of architecture dependent variations of pre_args, args, and post_args
# N.B.: this is a candidate for inclusion in the base code
rename command_string command_string_real
proc command_string {command} {

    if { ${command} in "extract archive" } { return [command_string_real ${command}] }

    set arch [muniversal::get_build_arch]

    global ${command}.dir \
        ${command}.cmd \
        ${command}.pre_args \
        ${command}.pre_args.${arch} \
        ${command}.args \
        ${command}.args.${arch} \
        ${command}.post_args \
        ${command}.post_args.${arch}

    if { [info exists ${command}.dir] } {
        append cmdstring "cd \"[set ${command}.dir]\" &&"
    }

    if { [info exists ${command}.cmd] } {
        foreach string [set ${command}.cmd] {
            append cmdstring " $string"
        }
    } else {
        append cmdstring " ${command}"
    }

    foreach var "${command}.pre_args ${command}.pre_args.${arch} ${command}.args ${command}.args.${arch} ${command}.post_args ${command}.post_args.${arch}" {
        if {[info exists $var]} {
            foreach string [set ${var}] {
                append cmdstring " ${string}"
            }
        }
    }

    return $cmdstring
}

# make use of architecture dependent variations of env
# N.B.: this is a candidate for inclusion in the base code
rename parse_environment parse_environment_real
proc parse_environment {command} {

    parse_environment_real ${command}

    if { ${command} in "extract archive" } { return }

    set arch [muniversal::get_build_arch]

    global ${command}.env.${arch} \
           ${command}.env_array

    if { ${command} eq "configure" } {
        append_to_environment_value     ${command}  CPP_FOR_BUILD       {*}"[portconfigure::configure_get_compiler cpp]"
        append_to_environment_value     ${command}  CXXCPP_FOR_BUILD    {*}"[portconfigure::configure_get_compiler cpp]"
        append_to_environment_value     ${command}  CPPFLAGS_FOR_BUILD  {*}[option configure.cppflags_for_build]

        if { [option muniversal.arch_build_compiler] } {
            if { [option configure.append_build_flags_to_compiler] } {
                append_to_environment_value ${command}  CC_FOR_BUILD    {*}"[portconfigure::configure_get_compiler cc]  [portconfigure::configure_get_archflags cc] [option configure.cflags_for_build]"
                append_to_environment_value ${command}  CXX_FOR_BUILD   {*}"[portconfigure::configure_get_compiler cxx] [portconfigure::configure_get_archflags cxx] [option configure.cxxflags_for_build]"
            } else {
                append_to_environment_value ${command}  CC_FOR_BUILD    {*}"[portconfigure::configure_get_compiler cc]  [portconfigure::configure_get_archflags cc]"
                append_to_environment_value ${command}  CXX_FOR_BUILD   {*}"[portconfigure::configure_get_compiler cxx] [portconfigure::configure_get_archflags cxx]"
            }

            append_to_environment_value ${command}  CFLAGS_FOR_BUILD    {*}"[option configure.cflags_for_build]"
            append_to_environment_value ${command}  CXXFLAGS_FOR_BUILD  {*}[option configure.cxxflags_for_build]
            append_to_environment_value ${command}  LDFLAGS_FOR_BUILD   {*}[option configure.ldflags_for_build]
        } else {
            if { [option configure.append_build_flags_to_compiler] } {
                append_to_environment_value ${command}  CC_FOR_BUILD    {*}"[portconfigure::configure_get_compiler cc]  [option configure.cflags_for_build]"
                append_to_environment_value ${command}  CXX_FOR_BUILD   {*}"[portconfigure::configure_get_compiler cxx] [option configure.cxxflags_for_build]"
            } else {
                append_to_environment_value ${command}  CC_FOR_BUILD    {*}"[portconfigure::configure_get_compiler cc]"
                append_to_environment_value ${command}  CXX_FOR_BUILD   {*}"[portconfigure::configure_get_compiler cxx]"
            }

            append_to_environment_value ${command}  CFLAGS_FOR_BUILD    {*}"[option configure.cflags_for_build] [portconfigure::configure_get_archflags cc]"
            append_to_environment_value ${command}  CXXFLAGS_FOR_BUILD  {*}"[option configure.cxxflags_for_build] [portconfigure::configure_get_archflags cxx]"
            append_to_environment_value ${command}  LDFLAGS_FOR_BUILD   {*}"[option configure.ldflags_for_build] [portconfigure::configure_get_archflags ld]"
        }
    }

    if { [option universal_possible] && [variant_isset universal] && ${command} eq "destroot" && [info exists ${command}.env_array(DESTDIR)] } {
        # some PortGroups (e.g. meson) set the environment variable DESTDIR
        # map to correct universal directory
        set ${command}.env_array(DESTDIR)                   [muniversal::get_arch_dir [set ${command}.env_array(DESTDIR)] ${arch}]
    }
    # allow /usr/bin/arch to work without `-arch` flag
    set ${command}.env_array(ARCHPREFERENCE)                ${arch}

    if { [info exists ${command}.env.${arch}] } {
        foreach assignment [set ${command}.env.${arch}] {
            set equals_pos [string first = $assignment]
            if {$equals_pos == -1} {
                ui_debug "parse_environment: skipping invalid entry: '$assignment'"
                continue
            }
            set key [string range $assignment 0 $equals_pos-1]
            set ${command}.env_array(${key}) [string range $assignment $equals_pos+1 end]
        }
    }
}

# make use of architecture dependent variations of configure.xflags
# N.B.: this is a candidate for inclusion in the base code
rename get_canonical_archflags get_canonical_archflags_real
proc get_canonical_archflags {{tool cc}} {

    set ret     [get_canonical_archflags_real]

    set arch    [muniversal::get_build_arch]

    switch -- ${tool} {
        cc      { set c "c" }
        f77     { set c "f" }
        default { set c ${tool} }
    }

    lappend ret {*}[option configure.${c}flags.${arch}]

    if { ${tool} ne "cpp" && [option muniversal.arch_flag] } {
        lappend ret {*}[option configure.${tool}_archflags.${arch}]
    }

    return ${ret}
}

# make use of architecture dependent variations of patch files
# N.B.: this is a candidate for inclusion in the base code
rename portpatch::patch_main portpatch::patch_main_real
proc portpatch::patch_main {args} {
    global UI_PREFIX

    set patches [list]

    if {[exists patchfiles]} {
        lappend patches {*}[option patchfiles]
    }
    set arch [muniversal::get_build_arch]
    if {[exists patchfiles.${arch}]} {
        lappend patches {*}[option patchfiles.${arch}]
    }

    if { ${patches} eq "" } {
        return 0
    }

    ui_notice "$UI_PREFIX [format [msgcat::mc "Applying patches to %s"] [option subport]]"

    foreach patch ${patches} {
        set patch_file [getdistname $patch]
        if {[file exists [option filespath]/$patch_file]} {
            lappend patchlist [option filespath]/$patch_file
        } elseif {[file exists [option distpath]/$patch_file]} {
            lappend patchlist [option distpath]/$patch_file
        } else {
            return -code error [format [msgcat::mc "Patch file %s is missing"] $patch]
        }
    }
    if {![info exists patchlist]} {
        return -code error [msgcat::mc "Patch files missing"]
    }

    set gzcat "[findBinary gzip $portutil::autoconf::gzip_path] -dc"
    set bzcat "[findBinary bzip2 $portutil::autoconf::bzip2_path] -dc"
    catch {set xzcat "[findBinary xz $portutil::autoconf::xz_path] -dc"}

    foreach patch $patchlist {
        ui_info "$UI_PREFIX [format [msgcat::mc "Applying %s"] [file tail $patch]]"
        switch -- [file extension $patch] {
            .Z -
            .gz {command_exec patch "$gzcat \"$patch\" | (" ")"}
            .bz2 {command_exec patch "$bzcat \"$patch\" | (" ")"}
            .xz {
                if {[info exists xzcat]} {
                    command_exec patch "$xzcat \"$patch\" | (" ")"
                } else {
                    return -code error [msgcat::mc "xz binary not found; port needs to add 'depends_patch bin:xz:xz'"]
                }}
            default {command_exec patch "" "< '$patch'"}
        }
    }
    return 0
}

# add the universal variant if appropriate
rename universal_setup universal_setup_real
proc universal_setup {args} {
    if { ![exists os.universal_supported] || ![option os.universal_supported] } {
        ui_debug "OS doesn't support universal builds, so not adding the universal variant"
        return
    }

    if { [llength [option configure.universal_archs]] < 2 } {
        ui_debug "muniversal: < 2 archs supported, not adding universal variant"
        return
    }

    if { [exists universal_variant] && ![option universal_variant] } {
        ui_debug "muniversal: universal_variant is false, so not adding universal variant"
        return
    }

ui_debug "muniversal: adding universal variant"

variant universal {

##########################################################################################
# changes if universal variant is set
##########################################################################################

foreach phase {patch configure build destroot test} {
    foreach part {pre procedure post} {

        # wrap procedures (either user defined or MacPorts) with architecture specific code
        foreach p [ditem_key [set org.macports.${phase}] ${part}] {
            if {[info procs user${p}] ne ""} {
                set proc_name user${p}
            } else {
                set proc_name ${p}
            }
            rename ${proc_name} ${proc_name}_orig
            proc ${proc_name} {{args ""}} "
                global worksrcpath UI_PREFIX subport muniversal.current_arch

                foreach arch \"\[option configure.universal_archs\]\" {

                    if { \"${phase}\" eq \"test\" && !\[option muniversal.can_run.\${arch}\] } { continue }

                    ui_info \"\$UI_PREFIX \[format \[msgcat::mc \"Running ${part} ${phase} %1\\\$s for architecture %2\\\$s\"\] \${subport} \${arch}\]\"

                    muniversal.build_arch \${arch}
                    set muniversal.current_arch \${arch}

                    foreach dir {test.dir destroot.dir destroot build.dir autoreconf.dir autoconf.dir configure.dir} {
                        set     save-\${dir}    \[option \${dir}\]
                        option  \${dir}         \[muniversal::get_arch_dir \[option \${dir}\] \${arch}\]
                    }
                    set     save-worksrcpath    \${worksrcpath}
                    option  worksrcpath         \${worksrcpath}-\${arch}

                    if {\[option muniversal.arch_compiler\]} {
                        # configure.cpp is intentionally left out
                        foreach tool {cxx objcxx cc objc fc f90 f77} {
                            configure.\${tool}-append   {*}\[option configure.\${tool}_archflags.\${arch}\]
                        }
                    }

                    foreach phase_map {configure build destroot test} {
                        set     save-\${phase_map}.cmd \[option \${phase_map}.cmd\]
                        option  \${phase_map}.cmd \[muniversal::map_phase \${save-worksrcpath} \[option worksrcpath\] \[option \${phase_map}.cmd\]\]
                    }

                    ${proc_name}_orig

                    if {\[option muniversal.arch_compiler\]} {
                        foreach tool {f77 f90 fc objc cc objcxx cxx} {
                            configure.\${tool}-delete   {*}\[option configure.\${tool}_archflags.\${arch}\]
                        }
                    }

                    option  worksrcpath         \${save-worksrcpath}
                    foreach dir {configure.dir autoconf.dir autoreconf.dir build.dir destroot destroot.dir test.dir} {
                        option  \${dir}         \[set save-\${dir}\]
                    }

                    foreach phase_map {configure build destroot test} {
                        option  \${phase_map}.cmd   \[set save-\${phase_map}.cmd\]
                    }
                }
                unset muniversal.current_arch
                muniversal.build_arch
            "
        }
    }
}
unset phase part p

# copy `worksrcpath` to architecture-dependent version
# rename portextract::extract_finish portextract::extract_finish_real
target_postrun ${org.macports.extract} portextract::extract_finish
proc portextract::extract_finish {args} {
    global worksrcpath

    foreach arch [option configure.universal_archs] {
        muniversal.build_arch ${arch}

        if {![file exists ${worksrcpath}-${arch}]} {
            switch [file type ${worksrcpath}] {
                directory {
                    copy ${worksrcpath} ${worksrcpath}-${arch}
                }
                link {
                    # we have to copy the actual directory tree instead of the verbatim symlink
                    set worksrcpath_work ${worksrcpath}
                    set link_depth 0
                    while {[file type ${worksrcpath_work}] eq "link"} {
                        set target [file readlink ${worksrcpath_work}]

                        # canonicalize path
                        if {[string index ${target} 0] ne "/"} {
                            set target [file dirname ${worksrcpath_work}]/${target}
                        }

                        if {![file exists ${target}]} {
                            return -code error "worksrcpath symlink traversal encountered non-existent target path ${target} (dangling symlink)"
                        }

                        incr link_depth
                        if {${link_depth} >= 50} {
                            return -code error "worksrcpath symlink too deeply nested, giving up (loop?)"
                        }

                        set worksrcpath_work ${target}
                    }

                    copy ${worksrcpath_work} ${worksrcpath}-${arch}
                }
                default {
                    return -code error "worksrcpath not a symlink or directory, this is unexpected"
                }
            }
        }
    }
    muniversal.build_arch
}

# copy `destroot` to architecture-dependent version
rename portdestroot::destroot_start portdestroot::destroot_start_real
proc portdestroot::destroot_start {args} {
    portdestroot::destroot_start_real ${args}

    foreach arch [option configure.universal_archs] {
        copy [option destroot] [option workpath]/destroot-${arch}
    }
    delete [option destroot]
}

# merge architecture-dependent versions of `destroot`
rename portdestroot::destroot_finish portdestroot::destroot_finish_real
proc portdestroot::destroot_finish {args} {
    global  workpath \
            muniversal.dont_diff \
            muniversal.combine \
            muniversal.equivalent

    # GNU diff can merge two C/C++ files
    # See https://www.gnu.org/software/diffutils/manual/html_mono/diff.html#If-then-else
    # See https://www.gnu.org/software/diffutils/manual/html_mono/diff.html#Detailed%20If-then-else
    set diffFormatProc {--old-group-format='#if (defined(__ppc__) || defined(__ppc64__))
 %<#endif
' \
--new-group-format='#if defined (__i386__) || defined(__x86_64__)
%>#endif
' \
--unchanged-group-format='%=' \
--changed-group-format='#if (defined(__ppc__) || defined(__ppc64__))
%<#else
%>#endif
'}

    set diffFormatM {--old-group-format='#ifndef __LP64__
%<#endif
' \
--new-group-format='#ifdef __LP64__
%>#endif
' \
--unchanged-group-format='%=' \
--changed-group-format='#ifndef __LP64__
%<#else
%>#endif
'}

    set diffFormatArmElse {--old-group-format='#ifdef __arm64__
%<#endif
' \
--new-group-format='#ifndef __arm64__
%>#endif
' \
--unchanged-group-format='%=' \
--changed-group-format='#ifdef __arm64__
%<#else
%>#endif
'}

    muniversal::merge  ${workpath}/destroot-ppc      ${workpath}/destroot-ppc64     ${workpath}/destroot-powerpc   ""  ppc ppc64      ${muniversal.dont_diff}  ${muniversal.combine} ${muniversal.equivalent} ${diffFormatM}
    muniversal::merge  ${workpath}/destroot-i386     ${workpath}/destroot-x86_64    ${workpath}/destroot-intel     ""  i386 x86_64    ${muniversal.dont_diff}  ${muniversal.combine} ${muniversal.equivalent} ${diffFormatM}
    muniversal::merge  ${workpath}/destroot-powerpc  ${workpath}/destroot-intel     ${workpath}/destroot-ppc-intel ""  powerpc x86    ${muniversal.dont_diff}  ${muniversal.combine} ${muniversal.equivalent} ${diffFormatProc}
    muniversal::merge  ${workpath}/destroot-arm64    ${workpath}/destroot-ppc-intel ${workpath}/destroot           ""  arm64 ppcintel ${muniversal.dont_diff}  ${muniversal.combine} ${muniversal.equivalent} ${diffFormatArmElse}

    portdestroot::destroot_finish_real ${args}
}
}
}

##########################################################################################
# register callbacks
##########################################################################################

# if base code not modified (i.e. not a universal build), append architecture flag to compiler name if requested
proc muniversal::add_compiler_flags {} {
    if { (![option universal_possible] || ![variant_isset universal]) && [option muniversal.arch_compiler]} {
        # configure.cpp is intentionally left out
        foreach tool {cxx objcxx cc objc fc f90 f77} {
            configure.${tool}-append   {*}[option configure.${tool}_archflags.[option configure.build_arch]]
        }
    }

    if {[option universal_possible] && [variant_isset universal]} {
        if { [option os.platform] eq "darwin" && [option os.major] >= 22 } {
            depends_build-delete port:diffutils-for-muniversal
            depends_build-append port:diffutils-for-muniversal
        }
    }
}
port::register_callback muniversal::add_compiler_flags
