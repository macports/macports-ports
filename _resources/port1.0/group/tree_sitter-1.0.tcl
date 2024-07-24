# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup accommodates tree-sitter parser libraries.

options tree_sitter.libname
default tree_sitter.libname {[regsub ^tree-sitter- [option name] ""]}

use_configure       no

build {
    system -W ${worksrcpath} "${configure.cc} ${configure.cppflags} ${configure.cflags} [get_canonical_archflags cc] -fPIC -c -I. parser.c"

    if {[file exists ${worksrcpath}/scanner.cc]} {
        system -W ${worksrcpath} "${configure.cxx} ${configure.cxxflags} ${configure.cflags} [get_canonical_archflags cxx] -fPIC -c -I. scanner.cc"
    } elseif {[file exists ${worksrcpath}/scanner.c]} {
        system -W ${worksrcpath} "${configure.cc} ${configure.cppflags} ${configure.cflags} [get_canonical_archflags cc] -fPIC -c -I. scanner.c"
    }

    if {[file exists ${worksrcpath}/scanner.cc]} {
        system -W ${worksrcpath} "${configure.cxx} ${configure.cxxflags} ${configure.cflags} [get_canonical_archflags cxx] -fPIC -shared *.o -o libtree-sitter-${tree_sitter.libname}.dylib"
    } else {
        system -W ${worksrcpath} "${configure.cc} ${configure.cppflags} ${configure.cflags} [get_canonical_archflags cc] -fPIC -shared *.o -o libtree-sitter-${tree_sitter.libname}.dylib"
    }
}

destroot {
    xinstall -m 0755 -W ${worksrcpath} libtree-sitter-${tree_sitter.libname}.dylib ${destroot}${prefix}/lib
}
