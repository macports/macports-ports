# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup sets up default variants for projects that want m
#
# Usage:
#
#   PortGroup               debug 1.0

configure.cflags-append    -mtune=native
configure.cxxflags-append  -mtune=native
configure.fflags-append    -mtune=native
configure.f90flags-append  -mtune=native
configure.fcflags-append   -mtune=native
configure.cppflags-append  -mtune=native

ui_debug "adding the default debug variant"
variant debug description {Enable debug flags and symbols} {
    configure.cflags-delete     -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.cxxflags-delete   -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.cppflags-delete   -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.fflags-delete     -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.f90flags-delete   -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.fcflags-delete    -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1

    # certain options break the way cmake configures, so test for cmake variable
    if {[info exists cmake_share_module_dir]} {
        configure.args-delete   -DCMAKE_BUILD_TYPE=Release
        configure.args-append   -DCMAKE_BUILD_TYPE=debugFull
    } else {
        configure.args-delete   --disable-debug
        configure.args-append   --enable-debug
    }

    configure.cflags-append     -g -O0
    configure.cxxflags-append   -g -O0
    configure.fflags-append     -g -O0
    configure.f90flags-append   -g -O0
    configure.fcflags-append    -g -O0
}

post-destroot {
  if {[variant_isset debug]} {
      ui_debug "Generating the .dSYM bundles because of +debug: find ${destroot}${prefix} -type f '(' -name '*.dylib' -or -name '*.so' ')' -exec dsymutil {} +"
      system -W ${destroot}${prefix} "find . -type f '(' -name '*.dylib' -or -name '*.so' ')' -exec dsymutil {} +"
  }
}
