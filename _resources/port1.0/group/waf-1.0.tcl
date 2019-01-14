# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

options waf.python
default waf.python {${prefix}/bin/python2.7}

depends_build-append    port:python27

configure.cmd           ${waf.python} ./waf configure
configure.args          --nocache

configure.universal_args-delete --disable-dependency-tracking

build.cmd               ${waf.python} ./waf
build.target            build

destroot.destdir        --destdir=${destroot}
