# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Usage:
#
#   1. use luarocks.setup and luarocks.branches
#
#     PortGroup            luarocks 1.0
#     luarocks.branches    5.1 5.2
#     luarocks.setup       module version type
#     # - adds subport "lua51-module" and "lua52-module"
#
#   2. use luarocks.branch
#
#     PortGroup            luarocks 1.0
#     luarocks.branch      3.0
#     depends_lib          port:luarocks${luarocks.suffix}
#     build.cmd            ${luarocks.bin}

# options:
#   luarocks.branches: the luarocks versions supported by this module.
#        this introduces subports such as lua51-, lua52-, ...
#   luarocks.branch: select luarocks version. 5.1, ... 5.2 or 5.3.
#   luarocks.link_binaries: whether to generate suffixed symlink under ${prefix}/bin
#        or not.
#   luarocks.link_binaries_suffix: suffix of commands from lua-foo under
#        ${prefix}/bin. such as "-5.1" or "-5.2".
# values:
#   luarocks.bin: fullpath to commands for ${luarocks.branch}.
#   luarocks.suffix: suffix of portname. port:luarocks${luarocks.suffix} or
#        port:lua${luarocks.suffix}-foo.
#   luarocks.bindir: install location of commands without suffix from lua-foo.
# values from luarocks.setup:
#   luarocks.module: port name without prefix. lua-${luarocks.module}.
#   luarocks.project: project name at luarocks.

options luarocks.default_branch
default luarocks.default_branch {[luarocks_get_default_version]}
options luarocks.branch luarocks.branches
default luarocks.branches {}
options luarocks.dependencies
default luarocks.dependencies {}
options luarocks.bin luarocks.bindir luarocks.rocksdir luarocks.suffix
proc luarocks_get_default_version {} {
    global luarocks.branches
    set def_v 5.3
    if {[info exists luarocks.branches]} {
        if {${def_v} in ${luarocks.branches}} {
            return ${def_v}
        } else {
            return [lindex ${luarocks.branches} end]
        }
    } else {
        return ${def_v}
    }
}
option_proc luarocks.branch luarocks_set_branch
proc luarocks_set_branch {option action args} {
    if {$action ne "set"} {
        return
    }
    set luarocks.latest_branch 5.3
    global prefix luarocks.branch \
           luarocks.bin luarocks.bindir luarocks.rocksdir \
           luarocks.suffix luarocks.branch
    set luarocks.bin            ${prefix}/bin/luarocks
    set luarocks.bindir         ${prefix}/libexec/lua${luarocks.branch}
    set luarocks.rocksdir       ${prefix}/lib/luarocks/rocks-${luarocks.branch}
    set luarocks.suffix         [join [split ${luarocks.branch} .] {}]
    if {${luarocks.branch} eq ${luarocks.latest_branch}} {
        set luarocks.suffix     ""
    }
}

set luarocks.module     ""
set luarocks.filename   ""
set luarocks.distname   ""
set luarocks.project    ""
set luarocks.docs       {}
set luarocks.branch     ""

luarocks.branch         ${luarocks.default_branch}

options luarocks.link_binaries luarocks.link_binaries_suffix
default luarocks.link_binaries yes
default luarocks.link_binaries_suffix {-${luarocks.branch}}

# luarocks group setup procedure
proc luarocks.setup {module vers {type "src.rock"} {docs {}} {source "custom"} {implementation "lua"}} {
    global name subport luarocks.branches luarocks.default_branch luarocks.dependencies
    global destroot prefix distpath distname worksrcpath os.platform
    global configure.cc configure.cflags configure.ldflags
    global luarocks.bin luarocks.branch
    global luarocks.suffix luarocks.bindir luarocks.rocksdir
    global luarocks.module luarocks.filename luarocks.distname luarocks.project luarocks.docs

    version         ${vers}
    categories      lua

    # define luarocks global names and lists
    # check if module is a list or string
    if {[llength ${module}] > 1} {
        # if a list, first item is the module name
        set luarocks.module     [lindex ${module} 0]
        # second argument is the project & file name
        set luarocks.project    [lindex ${module} 1]
        set luarocks.filename   [lindex ${module} 1]
    } else {
        # else, module, project, and file name are the same
        set luarocks.module     ${module}
        set luarocks.project    ${module}
        set luarocks.filename   ${module}
    }

    if {${luarocks.branches} ne ""} {
        # add subports luaXX-module from ${luarocks.branches}
        if {![info exists name]} {
            name lua-[string tolower ${luarocks.module}]
        }
        if {[string match lua-* $name]} {
            # stub port
            set rootname [string range $name 4 end]
            foreach v ${luarocks.branches} {
                set suffix [join [split ${v} .] {}]
                subport lua${suffix}-${rootname} {
                    luarocks.branch ${v}
                    depends_lib port:lua${luarocks.suffix}
                    if {${luarocks.branch} eq "5.1"} {
                        depends_lib-replace port:lua${luarocks.suffix} path:lib/libluajit-5.1.2.dylib:luajit
                    }
                }
            }
            if {$subport eq $name} {
                luarocks.link_binaries no
                distfiles
                supported_archs noarch
                platforms       any
                use_configure no
                depends_lib port:lua[join [split ${luarocks.default_branch} .] {}][string trimleft $name lua]
                build {}
                destroot {
                    xinstall -d -m 0755 ${destroot}${prefix}/share/doc/${name}
                    system "echo $name is a stub port > ${destroot}${prefix}/share/doc/${name}/README"
                }
                return
            }
        }
    } else {
        switch ${implementation} {
            lua { luarocks.branch 5.3 }
            lua52 { luarocks.branch 5.2 }
            lua53 { luarocks.branch 5.3 }
            lua54 { luarocks.branch 5.4 }
            default {
                ui_error "luarocks.setup: unknown implementation '${implementation}' specified"
                return -code error "luarocks.setup failed"
            }
        }
        name            lua${luarocks.suffix}-[string tolower ${luarocks.module}]
        depends_lib     port:${implementation}
    }

    set luarocks.docs   ${docs}

    # set source to luarocks by default for type "rock"
    if {[string match *.rock $type] && (${source} eq "custom")} {
        set source luarocks
    }
    switch -glob ${source} {
        luarocks {
            master_sites    https://luarocks.org/
        }
    }

    set suffix [join [split ${luarocks.branch} .] {}]
    foreach v ${luarocks.dependencies} {
        depends_lib-append port:lua${suffix}-[string tolower ${v}]
    }

    set luarocks.distname   ${luarocks.filename}-${vers}
    dist_subdir             luarocks

    destroot.env-append     CC="${configure.cc}"
    destroot.env-append     "CFLAGS=${configure.cflags} [get_canonical_archflags cc]"
    destroot.env-append     "LDFLAGS=${configure.ldflags} [get_canonical_archflags ld]"

    # https://github.com/luarocks/luarocks/wiki/Types-of-rocks
    switch -glob ${type} {
        rockspec {
            use_configure no

            proc luarocks.add_distfiles {} {
                global version luarocks.filename
                master_sites-append https://luarocks.org/:luarocks
                distfiles-append    ${luarocks.filename}-${version}.rockspec:luarocks
            }
            port::register_callback luarocks.add_distfiles

            depends_build-append    port:lua-luarocks

            post-extract {
                copy -force ${distpath}/${luarocks.distname}.rockspec ${worksrcpath}/${luarocks.distname}.rockspec
            }
            build {}

            destroot.cmd       ${luarocks.bin}
            destroot.pre_args  --lua-version ${luarocks.branch} --tree ${destroot}${prefix}
            destroot.args      make --deps-mode none
            destroot.post_args ${distpath}/${luarocks.distname}.rockspec

            destroot {
                command_exec destroot

                set binDir ${destroot}${prefix}/bin
                if {[file isdirectory $binDir]} {
                    foreach file [readdir $binDir] {
                        move [file join $binDir $file] ${destroot}${luarocks.bindir}
                        reinplace "s|${destroot}||g" ${destroot}${luarocks.bindir}/${file}
                    }
                }
            }
        }
        src.rock {
            use_configure no
            set distname    ${luarocks.distname}
            extract.suffix .src.rock

            depends_build-append    port:lua-luarocks

            extract.mkdir       yes
            extract {
                copy ${distpath}/${luarocks.distname}.src.rock ${worksrcpath}/${luarocks.distname}.src.rock
            }
            build {}

            destroot.cmd       ${luarocks.bin}
            destroot.pre_args  --lua-version ${luarocks.branch} --tree ${destroot}${prefix}
            destroot.args      build --deps-mode none
            destroot.post_args ${worksrcpath}/${luarocks.distname}.src.rock

            destroot {
                command_exec destroot

                set binDir ${destroot}${prefix}/bin
                if {[file isdirectory $binDir]} {
                    foreach file [readdir $binDir] {
                        move [file join $binDir $file] ${destroot}${luarocks.bindir}
                        reinplace "s|${destroot}||g" ${destroot}${luarocks.bindir}/${file}
                    }
                }
            }
        }
        all.rock {
            supported_archs noarch
            platforms       any
            use_configure no
            set distname    ${luarocks.distname}
            extract.suffix .all.rock

            depends_build-append    port:lua-luarocks

            extract.mkdir       yes
            extract {
                copy ${distpath}/${luarocks.distname}.all.rock ${worksrcpath}/${luarocks.distname}.all.rock
            }
            build {}

            destroot.cmd       ${luarocks.bin}
            destroot.pre_args  --lua-version ${luarocks.branch} --tree ${destroot}${prefix}
            destroot.args      build --deps-mode none
            destroot.post_args ${worksrcpath}/${luarocks.distname}.all.rock

            destroot {
                command_exec destroot

                set binDir ${destroot}${prefix}/bin
                if {[file isdirectory $binDir]} {
                    foreach file [readdir $binDir] {
                        move [file join $binDir $file] ${destroot}${luarocks.bindir}
                        reinplace "s|${destroot}||g" ${destroot}${luarocks.bindir}/${file}
                    }
                }
            }
        }
        fetch {
            # do nothing but fetch and extract - for strange installers
            build {}
        }
        default {
            ui_error "luarocks.setup: unknown setup type '${type}' specified!"
            return -code error "luarocks.setup failed"
        }
    }

    pre-destroot {
        xinstall -d -m 0755 ${destroot}${luarocks.bindir}
    }

    post-destroot {
        # Delete conflicting files
        delete ${destroot}${luarocks.rocksdir}/manifest

        if {${luarocks.link_binaries}} {
            foreach bin [glob -nocomplain -tails -directory "${destroot}${luarocks.bindir}" *] {
                if {[catch {file type "${destroot}${prefix}/bin/${bin}${luarocks.link_binaries_suffix}"}]} {
                    ln -s "${luarocks.bindir}/${bin}" "${destroot}${prefix}/bin/${bin}${luarocks.link_binaries_suffix}"
                }
            }
        }
        # Install documentation files (if specified)
        if {[llength ${luarocks.docs}] > 0} {
            set docPath ${prefix}/share/doc/${name}
            xinstall -d -m 0755 ${destroot}${docPath}
            foreach docitem ${luarocks.docs} {
                set docitem [file join ${worksrcpath} ${docitem}]
                if {[file isdirectory ${docitem}]} {
                    set subdir [file tail $docitem]
                    xinstall -d -m 0755 ${destroot}${docPath}/${subdir}
                    fs-traverse file $docitem {
                        set file [trimroot $docitem $file]
                        if {$file ne ""} {
                            set filepath [file join $docitem $file]
                            if {[file isdirectory $filepath]} {
                                xinstall -d -m 0755 ${destroot}${docPath}/${subdir}/${file}
                            } else {
                                xinstall -m 0644 $filepath ${destroot}${docPath}/${subdir}/${file}
                            }
                        }
                    }
                } else {
                    xinstall -m 0644 ${docitem} ${destroot}${docPath}
                }
            }
        }
    }
}

proc trimroot {root path} {
    set acc [list]
    set skiproot no
    foreach rootf [file split $root] pathf [file split $path] {
        if {$pathf eq ""} {
            # we've hit the end of the path
            break
        } elseif {$skiproot eq "yes" || $rootf eq ""} {
            lappend acc $pathf
        } elseif {$rootf ne $pathf} {
            # diverged from the root
            lappend acc $pathf
            set skiproot yes
        }
    }
    if {[llength $acc] == 0} {
        return ""
    } else {
        return [file join {*}$acc]
    }
}

# Do not extract .rockspec files
default extract.only    {[luarocks._disttagclean $distfiles]}

# based on portextract::disttagclean from portextract.tcl
proc luarocks._disttagclean {list} {
    if {$list eq ""} {
        return $list
    }
    foreach fname $list {
        set name [getdistname ${fname}]

        if {![string match *.rockspec $name]} {
            lappend val ${name}
        }
    }
    return $val
}
