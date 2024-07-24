# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup chooses the right FUSE library to use.
#
# Usage:
#
# PortGroup           fuse 1.0
#

# use osxfuse up to OS X 10.11
if {${os.platform} eq "darwin" && ${os.major} < 16} {

    set fuse_port "osxfuse"
    set fuse_path "lib/pkgconfig/fuse.pc"

    configure.cflags-append -I${prefix}/include/osxfuse -I${prefix}/include/osxfuse/fuse
    configure.cppflags-append -I${prefix}/include/osxfuse -I${prefix}/include/osxfuse/fuse

} else {

    set fuse_port "macfuse"
    set fuse_path "lib/pkgconfig/fuse.pc"

    configure.cflags-append -I${prefix}/include/fuse
    configure.cppflags-append -I${prefix}/include/fuse

}

depends_lib-append \
    path:${fuse_path}:${fuse_port}

depends_build-append \
    path:bin/pkg-config:pkgconfig

universal_variant no
