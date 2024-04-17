# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4

# This PortGroup supports the meson build system
#
# Usage:
#
# PortGroup meson 1.0
#


# Wrap mode handling for subprojects.
# Possible values: default, nofallback, nodownload, forcefallback, nopromote
options meson.wrap_mode
default meson.wrap_mode     {default}

# meson builds need to be done out-of-source
default build_dir           {${workpath}/build}

depends_skip_archcheck-append \
                            meson \
                            ninja

# TODO: --buildtype=plain tells Meson not to add its own flags to the command line. This gives the packager total control on used flags.
default configure.cmd       {${prefix}/bin/meson}
default configure.pre_args  {setup --prefix=${prefix}}
default configure.post_args {[meson::get_post_args]}
configure.universal_args-delete \
                            --disable-dependency-tracking

default build.dir           {${build_dir}}
default build.cmd           {${prefix}/bin/ninja}
default build.post_args     {-v}
default build.target        ""

# remove DESTDIR= from arguments, but rather take it from environment variable
destroot.env-append         DESTDIR=${destroot}
default destroot.cmd        {${prefix}/bin/meson}
default destroot.post_args  ""

# There shouldn't be any need to change the name of the native file.
options meson.native_file
default meson.native_file   {${workpath}/meson_native.ini}

# To override the results of find_program, add key/value pairs, e.g.:
# meson.native.binaries-append m4=${prefix}/bin/gm4
options meson.native.binaries
default meson.native.binaries {}

pre-configure {
    if {[option meson.native.binaries] ne {}} {
        set fp [open [option meson.native_file] w]
        puts ${fp} {[binaries]}
        foreach kv [option meson.native.binaries] {
            set kv [split ${kv} =]
            puts ${fp} "[lindex ${kv} 0]='[lindex ${kv} 1]'"
        }
        close ${fp}
    }
}

namespace eval meson { }

proc meson::get_post_args {} {
    global configure.dir build_dir build.dir muniversal.current_arch muniversal.build_arch
    set args [list ${configure.dir}]
    if {[info exists muniversal.build_arch]} {
        # muniversal 1.1 PG is being used
        lappend args ${build.dir}
        if {[option muniversal.is_cross.[option muniversal.build_arch]]} {
            lappend args --cross-file=[option muniversal.build_arch]-darwin
        }
    } elseif {[info exists muniversal.current_arch]} {
        # muniversal 1.0 PG is being used
        lappend args ${build_dir}-${muniversal.current_arch} --cross-file=${muniversal.current_arch}-darwin
    } else {
        lappend args ${build_dir}
    }
    if {[option meson.native.binaries] ne {}} {
        lappend args --native-file=[option meson.native_file]
    }
    lappend args --wrap-mode=[option meson.wrap_mode]
    return ${args}
}

proc meson::add_depends {} {
    depends_build-delete    port:meson \
                            port:ninja
    depends_build-append    port:meson \
                            port:ninja
}
port::register_callback meson::add_depends
