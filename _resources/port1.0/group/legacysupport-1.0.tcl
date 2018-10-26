# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup provides support for various missing library functions
# on older OS releases.

# Newest OSX release that requires legacy support.
# Currently OSX 10.11 (Darwin 15) due to clock_gettime
set newest_darwin_requires_legacy 15

proc add_legacysupport {} {
    
    global prefix
    set MPLegacyIncDir ${prefix}/include/LegacySupport

    depends_lib-append port:legacy-support

    # Add to configure options
    configure.ldflags-append  -lMacportsLegacySupport
    configure.cflags-append   -I${MPLegacyIncDir}
    configure.cppflags-append -I${MPLegacyIncDir}

    # Set env vars so gcc/clang add legacy include dir to default search paths
    # Note using C_INCLUDE_PATH and CPLUS_INCLUDE_PATH to avoid conflicts
    # eith MacPorts setting of CPATH
    configure.env-append     C_INCLUDE_PATH=${MPLegacyIncDir} \
                         CPLUS_INCLUDE_PATH=${MPLegacyIncDir}
    build.env-append         C_INCLUDE_PATH=${MPLegacyIncDir} \
                         CPLUS_INCLUDE_PATH=${MPLegacyIncDir}
}

if {${os.platform} eq "darwin" && ${os.major} <= ${newest_darwin_requires_legacy}} {
    # Note it is intentional to both call this immediately now, and to
    # register a callback to do it again later on. This is to handle the fact
    # different ports do things in different ways and one or the other might
    # work in any given case. Having both is not a problem.
    add_legacysupport
    port::register_callback add_legacysupport
}
