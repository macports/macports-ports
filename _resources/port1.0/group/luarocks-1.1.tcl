# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup supports the luarocks build system
#
# Usage:
#
# PortGroup luarocks 1.1
#
# see below for a list of options

# luarocks behaves like make, so use makefile PortGroup instead of duplicating its functionality
PortGroup                                       makefile 1.0

# Lua module installed by luarocks
options luarocks.module

# other rock dependencies
# see https://github.com/luarocks/luarocks/wiki/Creating-a-rock#depending-on-other-rocks
options luarocks.dependencies
default luarocks.dependencies                   {}

# Lua versions known to work with module
options luarocks.branches
default luarocks.branches                       {5.4 5.3 5.2 5.1}

# rockspec file
# see https://github.com/luarocks/luarocks/wiki/Rockspec-format
options luarocks.rockspec
default luarocks.rockspec                       {${worksrcpath}/${luarocks.module}-${luarocks.version}.rockspec}

# the version of the rock, which combines the version of a module and the version of the rockspec file
# for example, if the version of the module is 2.3, and the version of the rockspec file, then the rock version is 2.3-1
options luarocks.version
default luarocks.version                        {${version}-1}

# rock build type
# see https://github.com/luarocks/luarocks/wiki/Rockspec-format#build-back-ends
options luarocks.build_type
default luarocks.build_type                     {builtin}

# indicates that the rock consists exclusively of Lua code
options luarocks.pure_lua
default luarocks.pure_lua                       {no}

# during testing, paths help luarocks find not-yet-installed module
# see https://www.lua.org/pil/8.1.html
options luarocks.lua_path
default luarocks.lua_path                       {?.lua ../?.lua ../src/?.lua}
options luarocks.lua_cpath
default luarocks.lua_cpath                      {?.so ../?.so}

# indicates that the rock requires information from the versioned Lua directory
# e.g., lua.h
options luarocks.search_lua_dir
default luarocks.search_lua_dir                 {no}

# set defaults appropriate for rocks downloaded from luarocks.org

default build.cmd                               {${prefix}/bin/luarocks}
default destroot.cmd                            {${prefix}/bin/luarocks}
default test.cmd                                {${prefix}/bin/luarocks}

default categories                              {lua devel}

default build.pre_args                          {make --deps-mode=none --lua-version=${lua.version} --no-install ${luarocks.rockspec}}
default destroot.pre_args                       {make --deps-mode=none --lua-version=${lua.version} --tree=${destroot}${prefix} ${luarocks.rockspec}}
default test.pre_args                           {test --lua-version=${lua.version} ${luarocks.rockspec}}

default test.dir                                {${worksrcpath}/tests}

####################################################################################################################################
# internal procedures
####################################################################################################################################

options lua.version

post-destroot {
    # avoid conflict with every other rock port
    delete                                      ${destroot}${prefix}/lib/luarocks/rocks-${lua.version}/manifest

    foreach f [glob -nocomplain -tails -directory ${destroot}${prefix}/bin *] {
        # fix Lua scripts
        reinplace                               "s|${destroot}||g" \
                                                ${destroot}${prefix}/bin/$f

        # put Lua scripts in their own directory but put a versioned link in ${prefix}/bin
        set lua_subport                         lua[join [split ${lua.version} .] ""]

        xinstall -d -m 0755                     ${destroot}${prefix}/libexec/${lua_subport}/bin

        move                                    ${destroot}${prefix}/bin/$f \
                                                ${destroot}${prefix}/libexec/${lua_subport}/bin/$f

        ln -s                                   ${prefix}/libexec/${lua_subport}/bin/$f \
                                                ${destroot}${prefix}/bin/$f-${lua.version}
    }
}

# maintain luarocks manifest for MacPorts rocks
#post-activate {
#    system                                      "${prefix}/bin/luarocks-admin make_manifest --lua-version=${lua.version} --tree=${prefix} --local-tree"
#}
#post-deactivate {
#    system                                      "${prefix}/bin/luarocks-admin make_manifest --lua-version=${lua.version} --tree=${prefix} --local-tree"
#}

namespace eval                                  luarocks {}

proc luarocks::callback {} {
    global                                      name \
                                                env

    set names                                   [split ${name} -]
    if {[lindex ${names} 0] ne "lua"} {
        ui_error                                "luarocks setup: invalid name ${name} used!"
        return -code error                      "luarocks setup failed"
    }
    set subname                                 [join [lrange ${names} 1 end] -]

    # ensure linker value is the same as compiler value set in makefile PG
    build.args-append                           LD=\$CC
    destroot.args-append                        LD=\$CC

    if {[option luarocks.pure_lua]} {
        default platforms                       any
        default supported_archs                 noarch
    }

    test.env-append                             "LUA_PATH=[join [option luarocks.lua_path] \;];;" \
                                                "LUA_CPATH=[join [option luarocks.lua_cpath] \;];;"

    switch [option luarocks.build_type] {
        builtin {
            if {![exists test.run] || ![option test.run]} {
                # if build type is builtin, the destroot phase rebuilds the code regardless of the build phase
                # however, test phase is run before destroot phase and may need module to be built
                build                           {}
            }
        }
        make {
        }
        cmake {
            # untested
        }
        command {
            # untested
        }
        none {
            # untested
        }
        default {
            ui_error                            "luarocks setup: invalid build type [option luarocks.build_type] used!"
            return -code error                  "luarocks setup failed"
        }
    }

    # create a subport for each Lua version
    foreach branch [option luarocks.branches] {
        set branch_no_dot                       [join [split ${branch} .] ""]
        set subport_name                        lua${branch_no_dot}-${subname}

        subport                                 ${subport_name} {}

        if {[option subport] eq ${subport_name}} {

            lua.version                         ${branch}

            depends_lib-delete                  port:lua${branch_no_dot}
            depends_lib-append                  port:lua${branch_no_dot}

            foreach d [option luarocks.dependencies] {
                depends_lib-delete              port:lua${branch_no_dot}-${d}
                depends_lib-append              port:lua${branch_no_dot}-${d}
            }

            depends_build-delete                port:lua-luarocks
            depends_build-append                port:lua-luarocks

            # do not run livecheck on subports
            livecheck.type                      none

            if {[option luarocks.search_lua_dir]} {
                # attempt to have port find correct Lua version
                set lua_dir                     [option prefix]/libexec/lua${branch_no_dot}

                configure.cppflags-delete       -I${lua_dir}/include
                configure.cppflags-prepend      -I${lua_dir}/include

                configure.ldflags-delete        -L${lua_dir}/lib
                configure.ldflags-prepend       -L${lua_dir}/lib

                compiler.cpath-delete           ${lua_dir}/include
                compiler.cpath-prepend          ${lua_dir}/include

                compiler.library_path-delete    ${lua_dir}/lib
                compiler.library_path-prepend   ${lua_dir}/lib

                configure.pkg_config_path-delete    ${lua_dir}/lib/pkgconfig
                configure.pkg_config_path-prepend   ${lua_dir}/lib/pkgconfig

                foreach stage {configure build destroot test} {
                    set path_save               ""
                    if {[exists ${stage}.env]} {
                        foreach e [option ${stage}.env] {
                            if {[string range ${e} 0 4] eq "PATH="} {
                                set path_save   [string range ${e} 5 end]
                                break
                            }
                        }
                    }
                    if {${path_save} ne ""} {
                        ${stage}.env-replace    PATH=${path_save} \
                                                PATH=${lua_dir}/bin:${path_save}
                    } else {
                        ${stage}.env-append     PATH=${lua_dir}/bin:$env(PATH)
                    }
                }
            }
        }
    }

    # have ${name} subport do nothing without requiring conditional code in the main Portfile
    subport ${name} {
        distfiles
        patchfiles
        use_configure                           no
        extract.rename                          no
        foreach deptype {depends_extract depends_patch depends_lib depends_build depends_run depends_test} {
            ${deptype}
        }
        uplevel 2 {
            foreach phase {patch configure build destroot test} {
                foreach part {pre procedure post} {
                    foreach p [ditem_key [set org.macports.${phase}] ${part}] {
                        if {[info procs user${p}] ne ""} {
                            set proc_name       user${p}
                        } else {
                            set proc_name       ${p}
                        }
                        proc ${proc_name} {{args ""}} {}
                    }
                }
            }
        }

        post-destroot {
            set docdir ${destroot}${prefix}/share/doc/[option subport]
            xinstall -d                         ${docdir}
            set f                               [open "${docdir}/README" w 0644]
            puts ${f}                           "[option subport] is a stub port"
            close                               ${f}
        }
    }
}
port::register_callback luarocks::callback
