# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2009-2017 The MacPorts Project,
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
# 3. Neither the name of Apple Computer, Inc. nor the names of its
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

# User variables:
#         merger_configure_env: associative array of configure.env variables
#             merger_build_env: associative array of build.env variables
#              merger_test_env: associative array of test.env variables
#          merger_destroot_env: associative array of destroot.env variables
#                  merger_host: associative array of host values
#        merger_configure_args: associative array of configure.args
#            merger_build_args: associative array of build.args
#             merger_test_args: associative array of test.args
#         merger_destroot_args: associative array of destroot.args
#    merger_configure_compiler: associative array of configure.compiler
#    merger_configure_cppflags: associative array of configure.cppflags
#      merger_configure_cflags: associative array of configure.cflags
#    merger_configure_cxxflags: associative array of configure.cxxflags
#   merger_configure_objcflags: associative array of configure.objcflags
#     merger_configure_ldflags: associative array of configure.ldflags
#             merger_arch_flag: if no, -arch xxx will not be appended configure.???flags
#         merger_arch_compiler: if no, -arch xxx will not be appended to compilers
#             merger_dont_diff: list of file names for which diff will not work
#     merger_must_run_binaries: if yes, build platform must be able to run binaries for supported architectures
#            merger_no_3_archs: if yes, merger will not work correctly if there are three supported architectures

options universal_archs_supported merger_must_run_binaries merger_no_3_archs merger_arch_flag merger_arch_compiler
default universal_archs_supported {${universal_archs}}
default merger_must_run_binaries {no}
default merger_no_3_archs {no}
default merger_arch_flag {yes}
default merger_arch_compiler {no}

proc muniversal_arch_flag_supported {args} {
    global configure.compiler
    return [regexp {^gcc-4|llvm|apple|clang} ${configure.compiler}]
}

proc muniversal_get_arch_flag {arch {fortran ""}} {
    global os.arch
    # Prefer -arch to -m
    if {[muniversal_arch_flag_supported] && ${fortran}==""} {
        set archf "-arch ${arch}"
    } else {
        if { ${os.arch}=="i386" && ${arch}=="i386" } {
            set archf -m32
        } elseif { ${os.arch}=="i386" && ${arch}=="x86_64" } {
            set archf -m64
        } elseif { ${os.arch}=="powerpc" && ${arch}=="ppc" } {
            set archf -m32
        } elseif { ${os.arch}=="powerpc" && ${arch}=="ppc64" } {
            set archf -m64
        } else {
            if { ${fortran}=="" } {
                return -code error "selected compiler can't build for ${arch}"
            } else {
                return ""
            }
        }
    }
    return ${archf}
}

# set up the merger-post-destroot hook

proc merger_target_provides {ditem args} {
    global targets
    # register just the procedure, no pre-/post-
    # User-code exceptions are caught and returned as a result of the target.
    # Thus if the user code breaks, dependent targets will not execute.
    set script_template {
        variable proc_index
        set proc_index [llength [ditem_key ${ditem} post]]
        set proc_name proc-merger-post-${ident}-${target}-$proc_index
        ditem_append ${ditem} merger-post $proc_name
        proc $proc_name name {
            set userproc_name user[lindex [info level 0] 0]
            if {[catch $userproc_name result]} {
                return -code error $result
            }
            return 0
        }
        if {[info commands macports_version] ne ""
                && [vercmp 2.3.99 [macports_version]] <= 0} {
            makeuserproc user$proc_name [lindex $args 0]
        } else {
            makeuserproc user$proc_name $args
        }
    }
    foreach target $args {
        set ident [ditem_key $ditem name]
        proc merger-post-$target args \
                [string map [list \${ditem} [list $ditem] \
                                  \${ident} [list $ident] \
                                  \${target} [list $target]] \
                            $script_template]
    }
}

merger_target_provides ${org.macports.destroot} destroot

variant universal {
    global universal_archs_to_use

    foreach arch ${universal_archs} {
        configure.universal_cflags-delete    -arch ${arch}
        configure.universal_cxxflags-delete  -arch ${arch}
        configure.universal_ldflags-delete   -arch ${arch}
    }

    configure.args-append      {*}${configure.universal_args}
    configure.cflags-append    {*}${configure.universal_cflags}
    configure.cxxflags-append  {*}${configure.universal_cxxflags}
    configure.objcflags-append {*}${configure.universal_cflags}
    configure.ldflags-append   {*}${configure.universal_ldflags}
    configure.cppflags-append  {*}${configure.universal_cppflags}

    # user has specified that build platform must be able to run binaries for supported architectures
    if { ${merger_must_run_binaries}=="yes" } {
        if { ${os.arch}=="i386" } {
            set universal_archs_supported [ldelete ${universal_archs_supported} "ppc64"]
            if {${os.major} >= 9 && [sysctl hw.cpu64bit_capable] == 0} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "x86_64"]
            }
        } else {
            set universal_archs_supported [ldelete ${universal_archs_supported} "i386"]
            set universal_archs_supported [ldelete ${universal_archs_supported} "x86_64"]
            if {${os.major} >= 9 && [sysctl hw.cpu64bit_capable] == 0} {
                set universal_archs_supported [ldelete ${universal_archs_supported} "ppc64"]
            }
        }
    }

    # set universal_archs_to_use as the intersection of universal_archs and universal_archs_supported
    set universal_archs_to_use {}
    foreach arch ${universal_archs} {
        set arch_ok no
        foreach archt ${universal_archs_supported} {
            if { ${arch}==${archt} } {
                set arch_ok yes
            }
        }
        if { ${arch_ok}=="yes" } {
            lappend universal_archs_to_use ${arch}
        }
    }

    # if merger_no_3_archs is yes, prune universal_archs_to_use until it only has two elements
    if { ${merger_no_3_archs}=="yes" } {
        if { [llength ${universal_archs_to_use}] == 3 } {
            # first try to remove cross-compiled 64-bit arch
            if { ${os.arch}=="i386" } {
                set universal_archs_to_use [ldelete ${universal_archs_to_use} "ppc64"]
            } else {
                set universal_archs_to_use [ldelete ${universal_archs_to_use} "x86_64"]
            }
        }
        if { [llength ${universal_archs_to_use}] == 3 } {
            # next try to remove cross-compiled 32-bit arch
            if { ${os.arch}=="i386" } {
                set universal_archs_to_use [ldelete ${universal_archs_to_use} "ppc"]
            } else {
                set universal_archs_to_use [ldelete ${universal_archs_to_use} "i386"]
            }
        }
        if { [llength ${universal_archs_to_use}] == 3 } {
            # at least one arch should have been removed from universal_archs_to_use
            error "Should Not Happen"
        }
    }

    configure {

        foreach arch ${universal_archs_to_use} {
            ui_info "$UI_PREFIX [format [msgcat::mc "Configuring %1\$s for architecture %2\$s"] ${subport} ${arch}]"

            if {![file exists ${worksrcpath}-${arch}]} {
                copy ${worksrcpath} ${worksrcpath}-${arch}
            }

            set archf [muniversal_get_arch_flag ${arch}]
            set archff [muniversal_get_arch_flag ${arch} "fortran"]

            if { ${merger_arch_flag} != "no" } {
                configure.cflags-append    ${archf}
                configure.cxxflags-append  ${archf}
                configure.objcflags-append ${archf}
                configure.fflags-append    ${archff}
                configure.fcflags-append   ${archff}
                configure.f90flags-append  ${archff}
                configure.ldflags-append   ${archf}
            }

            if { [info exists merger_configure_env(${arch})] } {
                configure.env-append  $merger_configure_env(${arch})
            }
            if { [info exists merger_configure_cppflags(${arch})] } {
                configure.cppflags-append  $merger_configure_cppflags(${arch})
            }
            if { [info exists merger_configure_cflags(${arch})] } {
                configure.cflags-append  $merger_configure_cflags(${arch})
            }
            if { [info exists merger_configure_cxxflags(${arch})] } {
                configure.cxxflags-append  $merger_configure_cxxflags(${arch})
            }
            if { [info exists merger_configure_objcflags(${arch})] } {
                configure.objcflags-append  $merger_configure_objcflags(${arch})
            }
            if { [info exists merger_configure_ldflags(${arch})] } {
                configure.ldflags-append  $merger_configure_ldflags(${arch})
            }

            # Don't set the --host unless we have to.
            set host ""
            if { [info exists merger_host($arch)] } {
                if { $merger_host($arch) != "" } {
                    set host  --host=$merger_host($arch)
                }
            } elseif {[file tail ${configure.cmd}] != "cmake"} {
                # check if building for a word length we can't run
                set bits_differ 0
                if {(${arch}=="x86_64" || ${arch}=="ppc64") &&
                    (${os.major} < 9 || [sysctl hw.cpu64bit_capable] == 0)} {
                    set bits_differ 1
                }
                # check if building for a completely different arch
                if {$bits_differ || (${os.arch}=="i386" && (${arch}=="ppc" || ${arch}=="ppc64"))
                        || (${os.arch}=="powerpc" && (${arch}=="i386" || ${arch}=="x86_64"))} {
                    switch -- ${arch} {
                        x86_64  {set host "--host=x86_64-apple-${os.platform}${os.version}"}
                        i386    {set host "--host=i686-apple-${os.platform}${os.version}"}
                        ppc     {set host "--host=powerpc-apple-${os.platform}${os.version}"}
                        ppc64   {set host "--host=powerpc64-apple-${os.platform}${os.version}"}
                    }
                }
            }
            if {$host != ""} {
                configure.args-append  ${host}
            }

            if { [info exists merger_configure_args(${arch})] } {
                configure.args-append  $merger_configure_args(${arch})
            }

            set configure_compiler_save ${configure.compiler}
            set configure_cc_save       ${configure.cc}
            set configure_cxx_save      ${configure.cxx}
            set configure_objc_save     ${configure.objc}
            set configure_fc_save       ${configure.fc}
            set configure_f77_save      ${configure.f77}
            set configure_f90_save      ${configure.f90}

            if { [info exists merger_configure_compiler($arch)] } {
                configure.compiler  $merger_configure_compiler($arch)
                configure.cc        [portconfigure::configure_get_compiler cc]
                configure.cxx       [portconfigure::configure_get_compiler cxx]
                configure.objc      [portconfigure::configure_get_compiler objc]
                configure.f77       [portconfigure::configure_get_compiler f77]
                configure.f90       [portconfigure::configure_get_compiler f90]
                configure.fc        [portconfigure::configure_get_compiler fc]
            }

            if { ${merger_arch_compiler} != "no" } {
                configure.cc   ${configure.cc}   ${archf}
                configure.cxx  ${configure.cxx}  ${archf}
                configure.objc ${configure.objc} ${archf}
                if { ${configure.fc}  != "" } { configure.fc   ${configure.fc}  ${archff} }
                if { ${configure.f77} != "" } { configure.f77  ${configure.f77} ${archff} }
                if { ${configure.f90} != "" } { configure.f90  ${configure.f90} ${archff} }
            }

            set configure_dir_save  ${configure.dir}
            if { [string match "${worksrcpath}/*" ${configure.dir}] } {
                # The configure directory is inside the source directory, so put in the new source directory name.
                option configure.dir [string map "${worksrcpath} ${worksrcpath}-${arch}" ${configure.dir}]
            } else {
                # The configure directory is outside the source directory, so give it a new name by appending ${arch}.
                option configure.dir ${configure.dir}-${arch}
                if { ![file exists ${configure.dir}] } {
                    file mkdir ${configure.dir}
                }
            }

            set autoreconf_dir_save  ${autoreconf.dir}
            if { [string match "${worksrcpath}/*" ${autoreconf.dir}] } {
                # The autoreconf directory is inside the source directory, so put in the new source directory name.
                option autoreconf.dir [string map "${worksrcpath} ${worksrcpath}-${arch}" ${autoreconf.dir}]
            } else {
                # The autoreconf directory is outside the source directory, so give it a new name by appending ${arch}.
                option autoreconf.dir ${autoreconf.dir}-${arch}
                if { ![file exists ${autoreconf.dir}] } {
                    file mkdir ${autoreconf.dir}
                }
            }

            set autoconf_dir_save  ${autoconf.dir}
            if { [string match "${worksrcpath}/*" ${autoconf.dir}] } {
                # The autoconf directory is inside the source directory, so put in the new source directory name.
                option autoconf.dir [string map "${worksrcpath} ${worksrcpath}-${arch}" ${autoconf.dir}]
            } else {
                # The autoconf directory is outside the source directory, so give it a new name by appending ${arch}.
                option autoconf.dir ${autoconf.dir}-${arch}
                if { ![file exists ${autoconf.dir}] } {
                    file mkdir ${autoconf.dir}
                }
            }

            portconfigure::configure_main

            # Undo changes to the configure related variables
            option autoconf.dir         ${autoconf_dir_save}
            option autoreconf.dir       ${autoreconf_dir_save}
            option configure.dir        ${configure_dir_save}
            option configure.compiler   ${configure_compiler_save}
            option configure.f90        ${configure_f90_save}
            option configure.f77        ${configure_f77_save}
            option configure.fc         ${configure_fc_save}
            option configure.cc         ${configure_cc_save}
            option configure.cxx        ${configure_cxx_save}
            option configure.objc       ${configure_objc_save}
            if { [info exists merger_configure_args(${arch})] } {
                configure.args-delete  $merger_configure_args(${arch})
            }
            configure.args-delete  ${host}
            if { [info exists merger_configure_ldflags(${arch})] } {
                configure.ldflags-delete  $merger_configure_ldflags(${arch})
            }
            if { [info exists merger_configure_cxxflags(${arch})] } {
                configure.cxxflags-delete  $merger_configure_cxxflags(${arch})
            }
            if { [info exists merger_configure_objcflags(${arch})] } {
                configure.objcflags-delete  $merger_configure_objcflags(${arch})
            }
            if { [info exists merger_configure_cflags(${arch})] } {
                configure.cflags-delete  $merger_configure_cflags(${arch})
            }
            if { [info exists merger_configure_cppflags(${arch})] } {
                configure.cppflags-delete  $merger_configure_cppflags(${arch})
            }
            if { [info exists merger_configure_env(${arch})] } {
                configure.env-delete  $merger_configure_env(${arch})
            }
            if { ${merger_arch_flag} != "no" } {
                configure.ldflags-delete   ${archf}
                configure.f90flags-delete  ${archff}
                configure.fcflags-delete   ${archff}
                configure.fflags-delete    ${archff}
                configure.objcflags-delete ${archf}
                configure.cxxflags-delete  ${archf}
                configure.cflags-delete    ${archf}
            }
        }
    }

    build {
        foreach arch ${universal_archs_to_use} {
            ui_info "$UI_PREFIX [format [msgcat::mc "Building %1\$s for architecture %2\$s"] ${subport} ${arch}]"

            if { [info exists merger_build_env(${arch})] } {
                build.env-append  $merger_build_env(${arch})
            }
            if { [info exists merger_build_args(${arch})] } {
                build.args-append  $merger_build_args(${arch})
            }
            set build_dir_save  ${build.dir}
            if { [string match "${worksrcpath}/*" ${build.dir}] } {
                # The build directory is inside the source directory, so put in the new source directory name.
                option build.dir [string map "${worksrcpath} ${worksrcpath}-${arch}" ${build.dir}]
            } else {
                if { [string match "${configure.dir}/*" ${build.dir}] } {
                    # The build directory is outside the source directory, and ${build.dir} is a subdirectory of ${configure.dir}, so
                    #    append ${arch} to the ${configure.dir} part
                    option build.dir [string map "${configure.dir} ${configure.dir}-${arch}" ${build.dir}]
                } else {
                    # The build directory is outside the source directory, so give it a new name by appending ${arch}.
                    option build.dir ${build.dir}-${arch}
                }
                if { ![file exists ${build.dir}] } {
                    file mkdir ${build.dir}
                }
            }

            portbuild::build_main

            option build.dir ${build_dir_save}
            if { [info exists merger_build_args(${arch})] } {
                build.args-delete $merger_build_args(${arch})
            }
            if { [info exists merger_build_env(${arch})] } {
                build.env-delete  $merger_build_env(${arch})
            }
        }
    }

    destroot {
        foreach arch ${universal_archs_to_use} {
            ui_info "$UI_PREFIX [format [msgcat::mc "Staging %1\$s into destroot for architecture %2\$s"] ${subport} ${arch}]"
            copy ${destroot} ${workpath}/destroot-${arch}
            set destdirSave ${destroot.destdir}
            option destroot.destdir [string map "${destroot} ${workpath}/destroot-${arch}" ${destroot.destdir}]

            if { [info exists merger_destroot_env(${arch})] } {
                destroot.env-append  $merger_destroot_env(${arch})
            }
            if { [info exists merger_destroot_args(${arch})] } {
                destroot.args-append  $merger_destroot_args(${arch})
            }
            set destroot_dir_save ${destroot.dir}
            if { [string match "${worksrcpath}/*" ${destroot.dir}] } {
                # The destroot directory is inside the source directory, so put in the new source directory name.
                option destroot.dir [string map "${worksrcpath} ${worksrcpath}-${arch}" ${destroot.dir}]
            } else {
                if { [string match "${configure.dir}/*" ${destroot.dir}] } {
                    # The destroot directory is outside the source directory, and ${destroot.dir} is a subdirectory of ${configure.dir}, so
                    #    append ${arch} to the ${configure.dir} part
                    option destroot.dir [string map "${configure.dir} ${configure.dir}-${arch}" ${destroot.dir}]
                } else {
                    # The destroot directory is outside the source directory, so give it a new name by appending ${arch}.
                    option destroot.dir ${destroot.dir}-${arch}
                }
                if { ![file exists ${destroot.dir}] } {
                    file mkdir ${destroot.dir}
                }
            }

            portdestroot::destroot_main

            option destroot.dir ${destroot_dir_save}
            if { [info exists merger_destroot_args(${arch})] } {
                destroot.args-delete $merger_destroot_args(${arch})
            }
            if { [info exists merger_destroot_env(${arch})] } {
                destroot.env-delete  $merger_destroot_env(${arch})
            }
            option destroot.destdir ${destdirSave}
        }
        delete ${destroot}

        # execute merger-post-destroot, if it exists

        set ditem ${org.macports.destroot}
        set procedure [ditem_key $ditem merger-post]
        if {$procedure != ""} {
            set targetname [ditem_key $ditem name]
            ui_debug "Executing org.macports.merger-post-destroot"
            set result [catch { $procedure $targetname } errstr]
            # Save variables in order to re-throw the same error code.
            set errcode $::errorCode
            set errinfo $::errorInfo
            if {$result != 0} {
                set portname $subport
                ui_error "$targetname for port $portname returned: $errstr"
                ui_debug "Error code: $errcode"
                ui_debug "Backtrace: $errinfo"
                return $result
            }
        }

        # Merge two files (${dir1}/${fl} and ${dir2}/${fl}) to ${dir}/${fl}
        # by stripping out -arch XXXX, -m32, and -m64
        proc mergeStripArchFlags {dir1 dir2 dir fl} {
            set tempdir [mkdtemp "/tmp/muniversal.XXXXXXXX"]
            set tempfile1 "${tempdir}/1-${fl}"
            set tempfile2 "${tempdir}/2-${fl}"

            copy ${dir1}/${fl} ${tempfile1}
            copy ${dir2}/${fl} ${tempfile2}

            reinplace -q -E {s:-arch +[^ ]+::g} ${tempfile1} ${tempfile2}
            reinplace -q {s:-m32::g} ${tempfile1} ${tempfile2}
            reinplace -q {s:-m64::g} ${tempfile1} ${tempfile2}

            if { ! [catch {system "/usr/bin/cmp -s \"${tempfile1}\" \"${tempfile2}\""}] } {
                # modified files are identical
                ui_debug "universal: merge: ${fl} differs in ${dir1} and ${dir2} but are the same when stripping out -m32, -m64, and -arch XXX"
                copy ${tempfile1} ${dir}/${fl}
                delete ${tempfile1} ${tempfile2} ${tempdir}
            } else {
                delete ${tempfile1} ${tempfile2} ${tempdir}
                return -code error "${fl} differs in ${dir1} and ${dir2} and cannot be merged"
            }
        }

        # Merge ${base1}/${prefixDir} and ${base2}/${prefixDir} into dir ${base}/${prefixDir}
        #        arch1, arch2: names to prepend to files if a diff merge of two files is forbidden by merger_dont_diff
        #    merger_dont_diff: list of files for which /usr/bin/diff ${diffFormat} will not merge correctly
        #          diffFormat: format used by diff to merge two text files
        proc merge2Dir {base1 base2 base prefixDir arch1 arch2 merger_dont_diff diffFormat} {
            set dir1  ${base1}/${prefixDir}
            set dir2  ${base2}/${prefixDir}
            set dir   ${base}/${prefixDir}

            xinstall -d -m 0755 ${dir}

            foreach fl [glob -directory ${dir2} -tails -nocomplain * .*] {
                if { ${fl} == "." || ${fl} == ".." } {
                    continue
                }
                if { ![muniversal_file_or_symlink_exists ${dir1}/${fl}] } {
                    # File only exists in ${dir1}
                    ui_debug "universal: merge: ${prefixDir}/${fl} only exists in ${base2}"
                    copy ${dir2}/${fl} ${dir}
                }
            }
            foreach fl [glob -directory ${dir1} -tails -nocomplain * .*] {
                if { ${fl} == "." || ${fl} == ".." } {
                    continue
                }
                if { ![muniversal_file_or_symlink_exists ${dir2}/${fl}] } {
                    # File only exists in ${dir2}
                    ui_debug "universal: merge: ${prefixDir}/${fl} only exists in ${base1}"
                    copy ${dir1}/${fl} ${dir}
                } else {
                    # File exists in ${dir1} and ${dir2}
                    ui_debug "universal: merge: merging ${prefixDir}/${fl} from ${base1} and ${base2}"

                    # Ensure files are of same type
                    if { [file type ${dir1}/${fl}]!=[file type ${dir2}/${fl}] } {
                        error "${dir1}/${fl} and ${dir2}/${fl} are of different types"
                    }

                    if { [file type ${dir1}/${fl}]=="link" } {
                        # Files are links
                        ui_debug "universal: merge: ${prefixDir}/${fl} is a link"

                        # Ensure links don't point to different things
                        if { [file readlink ${dir1}/${fl}]==[file readlink ${dir2}/${fl}] } {
                            copy ${dir1}/${fl} ${dir}
                        } else {
                            error "${dir1}/${fl} and ${dir2}/${fl} point to different targets (can't merge them)"
                        }
                    } elseif { [file isdirectory ${dir1}/${fl}] } {
                        # Files are directories (but not links), so recursively call function
                        merge2Dir ${base1} ${base2} ${base} ${prefixDir}/${fl} ${arch1} ${arch2} ${merger_dont_diff} ${diffFormat}
                    } else {
                        # Files are neither directories nor links
                        if { ! [catch {system "/usr/bin/cmp -s \"${dir1}/${fl}\" \"${dir2}/${fl}\" && /bin/cp -v \"${dir1}/${fl}\" \"${dir}\""}] } {
                            # Files are byte by byte the same
                            ui_debug "universal: merge: ${prefixDir}/${fl} is identical in ${base1} and ${base2}"
                        } else {
                            # Actually try to merge the files
                            # First try lipo, then libtool
                            if { ! [catch {system "/usr/bin/lipo -create \"${dir1}/${fl}\" \"${dir2}/${fl}\" -output \"${dir}/${fl}\""}] } {
                                # lipo worked
                                ui_debug "universal: merge: lipo created ${prefixDir}/${fl}"
                            } elseif { ! [catch {system "/usr/bin/libtool \"${dir1}/${fl}\" \"${dir2}/${fl}\" -o \"${dir}/${fl}\""}] } {
                                # libtool worked
                                ui_debug "universal: merge: libtool created ${prefixDir}/${fl}"
                            } else {
                                # lipo and libtool have failed, so assume they are text files to be merged
                                set dontdiff no
                                foreach dont ${merger_dont_diff} {
                                    if { ${dont}=="${prefixDir}/${fl}" } {
                                        set dontdiff yes
                                    }
                                }
                                if { ${dontdiff}==yes } {
                                    # user has specified that diff does not work
                                    # attempt to give each file a unique name and create a new file which includes one of the original depending on the arch

                                    set fh [open ${dir}/${arch1}-${fl} w 0644]
                                    puts ${fh} "#include \"${arch1}-${fl}\""
                                    close ${fh}

                                    set fh [open ${dir}/${arch2}-${fl} w 0644]
                                    puts ${fh} "#include \"${arch2}-${fl}\""
                                    close ${fh}

                                    ui_debug "universal: merge: created ${prefixDir}/${fl} to include ${prefixDir}/${arch1}-${fl} ${prefixDir}/${arch1}-${fl}"

                                    system "/usr/bin/diff -d ${diffFormat} \"${dir}/${arch1}-${fl}\" \"${dir}/${arch2}-${fl}\" > \"${dir}/${fl}\"; test \$? -le 1"

                                    copy -force ${dir1}/${fl} ${dir}/${arch1}-${fl}
                                    copy -force ${dir2}/${fl} ${dir}/${arch2}-${fl}
                                } else {
                                    # Text file on which diff will not give correct results.
                                    switch -glob ${fl} {
                                        *.mod {
                                            # .mod files from Fortran modules.
                                            # Create a sepcial module directory for each architecture.
                                            # To find these modules, GFortran might require -M or -J.
                                            file mkdir ${dir}/mods32
                                            file mkdir ${dir}/mods64
                                            if { ${arch1}=="i386" || ${arch1}=="ppc" } {
                                                copy ${dir1}/${fl} ${dir}/mods32
                                                copy ${dir2}/${fl} ${dir}/mods64
                                            } else {
                                                copy ${dir2}/${fl} ${dir}/mods32
                                                copy ${dir1}/${fl} ${dir}/mods64
                                            }
                                        }
                                        *.pc -
                                        *-config {
                                            mergeStripArchFlags ${dir1} ${dir2} ${dir} ${fl}
                                        }
                                        *.la {
                                            global destroot.delete_la_files
                                            if {${destroot.delete_la_files} == "yes"} {
                                                ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2}; ignoring due to delete_la_files"
                                            } else {
                                                return -code error "${prefixDir}/${fl} differs in ${base1} and ${base2} and cannot be merged"
                                            }
                                        }
                                        *.typelib {
                                            # Sometimes garbage ends up in ignored trailing bytes
                                            # https://trac.macports.org/ticket/39629
                                            # TODO: Compare the g-ir-generate output
                                            ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2}; assume trivial difference"
                                            copy ${dir1}/${fl} ${dir}
                                        }
                                        *.pyc {
                                            # pyc files should be same across architectures
                                            # the timestamp is recorded, however
                                            ui_debug "universal: merge: ${prefixDir}/${fl} differs in ${base1} and ${base2}; assume trivial difference"
                                            copy ${dir1}/${fl} ${dir}
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
                                            if { ! [catch {system "test `head -c2 ${dir1}/${fl}` == '#!'"}] } {
                                                # Shell script, hopefully striping out arch flags works...
                                                mergeStripArchFlags ${dir1} ${dir2} ${dir} ${fl}
                                            } elseif { ! [catch {system "/usr/bin/diff -dw ${diffFormat} \"${dir1}/${fl}\" \"${dir2}/${fl}\" > \"${dir}/${fl}\"; test \$? -le 1"} ] } {
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

        # /usr/bin/diff can merge two C/C++ files
        # See http://www.gnu.org/software/diffutils/manual/html_mono/diff.html#If-then-else
        # See http://www.gnu.org/software/diffutils/manual/html_mono/diff.html#Detailed%20If-then-else
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

        if { ![info exists merger_dont_diff] } {
            set merger_dont_diff {}
        }

        merge2Dir  ${workpath}/destroot-ppc      ${workpath}/destroot-ppc64 ${workpath}/destroot-powerpc  ""  ppc ppc64    ${merger_dont_diff}  ${diffFormatM}
        merge2Dir  ${workpath}/destroot-i386     ${workpath}/destroot-x86_64 ${workpath}/destroot-intel   ""  i386 x86_64  ${merger_dont_diff}  ${diffFormatM}
        merge2Dir  ${workpath}/destroot-powerpc  ${workpath}/destroot-intel ${workpath}/destroot          ""  powerpc x86  ${merger_dont_diff}  ${diffFormatProc}
    }

    test {
        foreach arch ${universal_archs_to_use} {
            # Rosetta does not translate G5 instructions
            # PowerPC systems can't translate Intel instructions
            if { (${os.arch}=="i386" && ${arch}!="ppc64") || (${os.arch}=="powerpc" && ${arch}!="i386" && ${arch}!="x86_64") } {
                ui_info "$UI_PREFIX [format [msgcat::mc "Testing %1\$s for architecture %2\$s"] ${subport} ${arch}]"

                if { [info exists merger_test_env(${arch})] } {
                    test.env-append  $merger_test_env(${arch})
                }
                if { [info exists merger_test_args(${arch})] } {
                    test.args-append  $merger_test_args(${arch})
                }
                set test_dir_save ${test.dir}
                if { [string match "${worksrcpath}/*" ${test.dir}] } {
                    # The test directory is inside the source directory, so put in the new source directory name.
                    option test.dir [string map "${worksrcpath} ${worksrcpath}-${arch}" ${test.dir}]
                } else {
                    if { [string match "${configure.dir}/*" ${test.dir}] } {
                        # The test directory is outside the source directory, and ${test.dir} is a subdirectory of ${configure.dir}, so
                        #    append ${arch} to the ${configure.dir} part
                        option test.dir [string map "${configure.dir} ${configure.dir}-${arch}" ${test.dir}]
                    } else {
                        # The test directory is outside the source directory, so give it a new name by appending ${arch}.
                        option test.dir ${test.dir}-${arch}
                    }
                    if { ![file exists ${test.dir}] } {
                        file mkdir ${test.dir}
                    }
                }

                porttest::test_main

                option test.dir ${test_dir_save}
                if { [info exists merger_test_args(${arch})] } {
                    test.args-delete $merger_test_args(${arch})
                }
                if { [info exists merger_test_env(${arch})] } {
                    test.env-delete  $merger_test_env(${arch})
                }
            }
        }
    }
}

# [muniversal_file_or_symlink_exists ${f}] tells you if ${f} exists. And unlike
# [file exists ${f}], if used on a symlink, [muniversal_file_or_symlink_exists ${f}]
# tells you about the symlink, not what it points to.
proc muniversal_file_or_symlink_exists {f} {
    # If [file type ${f}] throws an error, ${f} doesn't exist.
    if {[catch {file type ${f}}]} {
        return 0
    }
    # Otherwise, it does.
    return 1
}
