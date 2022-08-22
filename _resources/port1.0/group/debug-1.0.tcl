# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#===================================================================================================
#
# This PortGroup defines a debug variant, for ports not based on CMake, Meson, etc.
#
# Usage:
#   PortGroup               debug 1.0
#
#===================================================================================================

ui_debug "pg_debug: adding variant"
variant debug description {Enable debug flags and symbols} {
    configure.cflags-delete       -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.cppflags-delete     -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.cxxflags-delete     -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.objcflags-delete    -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.objcxxflags-delete  -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.fflags-delete       -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.f90flags-delete     -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1
    configure.fcflags-delete      -O1 -O2 -O3 -Os -mtune=native -DNDEBUG -DNDEBUG=1

    configure.cflags-append       -g -O0
    configure.cppflags-append     -g -O0
    configure.cxxflags-append     -g -O0
    configure.objcflags-append    -g -O0
    configure.objcxxflags-append  -g -O0
    configure.fflags-append       -g -O0
    configure.f90flags-append     -g -O0
    configure.fcflags-append      -g -O0
}

post-destroot {
  if {[variant_isset debug]} {
      ui_debug "pg_debug: Generating the .dSYM bundles because of +debug: find ${destroot}${prefix} -type f '(' -name '*.dylib' -or -name '*.so' ')' -exec dsymutil {} +"
      system -W ${destroot}${prefix} "find . -type f '(' -name '*.dylib' -or -name '*.so' ')' -exec dsymutil {} +"
  }
}
