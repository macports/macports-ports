# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4

# This PortGroup supports the meson build system
#
# Usage:
#
# PortGroup meson 1.0
#

#---------
# WARNING:
#---------
#
# Meson's install_name currently seems to be broken, so workarounds might be needed to make ports actually work.
# See: https://github.com/mesonbuild/meson/issues/2121


# meson builds need to be done out-of-source
default build_dir           {${workpath}/build}

depends_build-append        port:meson \
                            port:ninja
depends_skip_archcheck-append \
                            meson \
                            ninja

# TODO: --buildtype=plain tells Meson not to add its own flags to the command line. This gives the packager total control on used flags.
default configure.cmd       {${prefix}/bin/meson}
default configure.post_args {[meson::get_post_args]}
configure.universal_args-delete \
                            --disable-dependency-tracking

default build.dir           {${build_dir}}
default build.cmd           {${prefix}/bin/ninja}
default build.post_args     {-v}
default build.target        ""

# remove DESTDIR= from arguments, but rather take it from environmental variable
destroot.env-append         DESTDIR=${destroot}
default destroot.post_args  ""

namespace eval meson {
    proc get_post_args {} {
        global configure.dir build_dir muniversal.current_arch
        if {[info exists muniversal.current_arch]} {
            return "${configure.dir} ${build_dir}-${muniversal.current_arch}"
        } else {
            return "${configure.dir} ${build_dir}"
        }
    }
}
