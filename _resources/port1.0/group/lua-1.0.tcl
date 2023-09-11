# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Group code to manage use of Lua subports
# Usage:
#
# PortGroup        lua 1.0
#
# see below for a list of options
#
# global is used on several of the options since Lua is often used inside a variant

PortGroup                   conflicts_build 1.0

# Lua version to use
options lua.version
default lua.version         {}
global  lua.version

# location of Lua installation
options lua.dir
default lua.dir             {[expr {${lua.version} eq "" ? ${prefix} : "${prefix}/libexec/lua[join [split ${lua.version} .] {}]"}]}
global  lua.dir

# Lua binary
options lua.bin
default lua.bin             {${prefix}/bin/lua${lua.version}}
global  lua.bin

# Lua include directory in ${prefix}
options lua.include
default lua.include         {[expr {${lua.version} eq "" ? "${prefix}/include" : "${prefix}/include/lua${lua.version}"}]}
global  lua.include

# Lua library
options lua.lib             {${prefix}/lib/liblua${lua.version}.dylib}
default lua.lib             {${prefix}/lib/liblua${lua.version}.dylib}
global  lua.lib

# Lua modules required
options lua.modules
default lua.modules         {}

# port finds unversioned Lua installation even if not desired
options  lua.finds_default
default  lua.finds_default  {no}

# port finds versioned Lua installation even if not desired
options lua.finds_versioned
default lua.finds_versioned {no}

####################################################################################################################################
# internal procedures
####################################################################################################################################

# default Lua version
options lua.default_version
default lua.default_version {5.3}
global  lua.default_version

# all Lua versions
options lua.branches
default lua.branches        {5.4 5.3 5.2 5.1}

namespace eval lua          {}

proc lua::callback {} {
    global                                  prefix \
                                            lua.version \
                                            lua.dir \
                                            env

    depends_lib-delete                      port:lua[join [split ${lua.version} .] ""]
    depends_lib-append                      port:lua[join [split ${lua.version} .] ""]

    if {${lua.version} ne ""} {
        set module_branch_no_dot            [join [split ${lua.version} .] ""]
    } else {
        set module_branch_no_dot            [join [split [option lua.default_version] .] ""]
    }
    foreach m [option lua.modules] {
        depends_lib-delete                  port:lua${module_branch_no_dot}-${m}
        depends_lib-append                  port:lua${module_branch_no_dot}-${m}
    }

    # CMake modules FindLua.cmake and FindLua51.cmake use LUA_DIR
    if {${lua.dir} ne ""} {
        configure.env-delete                LUA_DIR=${lua.dir}
        configure.env-append                LUA_DIR=${lua.dir}
    }

    # attempt to have port find correct Lua version
    if {${lua.version} ne "" && ${lua.dir} ne ""} {
        configure.cppflags-delete           -I${lua.dir}/include
        configure.cppflags-prepend          -I${lua.dir}/include

        configure.ldflags-delete            -L${lua.dir}/lib
        configure.ldflags-prepend           -L${lua.dir}/lib

        compiler.cpath-delete               ${lua.dir}/include
        compiler.cpath-prepend              ${lua.dir}/include

        compiler.library_path-delete        ${lua.dir}/lib
        compiler.library_path-prepend       ${lua.dir}/lib

        configure.pkg_config_path-delete    ${lua.dir}/lib/pkgconfig
        configure.pkg_config_path-prepend   ${lua.dir}/lib/pkgconfig

        foreach stage {configure build destroot test} {
            set path_save                   ""
            if {[exists ${stage}.env]} {
                foreach e [option ${stage}.env] {
                    if {[string range ${e} 0 4] eq "PATH="} {
                        set path_save       [string range ${e} 5 end]
                        break
                    }
                }
            }
            if {${path_save} ne ""} {
                ${stage}.env-replace        PATH=${path_save} \
                                            PATH=${lua.dir}/bin:${path_save}
            } else {
                ${stage}.env-append         PATH=${lua.dir}/bin:$env(PATH)
            }
        }
    }

    # if it is too much effort ensure correct Lua is used, just add build conflict

    if {${lua.version} ne "" && [option lua.finds_default]} {
        conflicts_build-append              lua
    }

    if {${lua.version} eq "" && [option lua.finds_versioned]} {
        foreach v [option lua.branches] {
            conflicts_build-append          lua[join [split $v .] ""]
        }
    }
}
port::register_callback lua::callback
