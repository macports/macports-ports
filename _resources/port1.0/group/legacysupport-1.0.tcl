# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup provides support for various missing library functions
# on older macOS releases.

# Newest Darwin version that requires legacy support.
# Currently OS X 10.14 ( Mojave, Darwin 18) due to timespec_get
options legacysupport.newest_darwin_requires_legacy
default legacysupport.newest_darwin_requires_legacy 18

# allow static linking of legacysupport if preferred (e.g. compilers)
options legacysupport.use_static
default legacysupport.use_static no

proc get_legacysupport_depends_type {} {
    if {[option legacysupport.use_static]} {
        return depends_build
    } else {
        return depends_lib
    }
}

proc add_legacysupport {} {

    global prefix \
           os.platform os.major \
           legacysupport.newest_darwin_requires_legacy

    set MPLegacyIncDir     ${prefix}/include/LegacySupport
    set AddLDFlag          -lMacportsLegacySupport
    set AddStaticLDFlag    ${prefix}/lib/libMacportsLegacySupport.a
    set AddCFlag           -I${MPLegacyIncDir}
    set AddCIncPath        C_INCLUDE_PATH=${MPLegacyIncDir}
    set AddCppIncPath      CPLUS_INCLUDE_PATH=${MPLegacyIncDir}

    # Delete everything first to avoid duplicate values

    # port dependency
    set legacy_dep path:lib/libMacportsLegacySupport.dylib:legacy-support
    [get_legacysupport_depends_type]-delete ${legacy_dep}

    # configure options
    configure.ldflags-delete  ${AddLDFlag}
    configure.ldflags-delete  ${AddStaticLDFlag}
    configure.cflags-delete   ${AddCFlag}
    configure.cppflags-delete ${AddCFlag}

    # Include Dirs
    configure.env-delete ${AddCIncPath} ${AddCppIncPath}
    build.env-delete     ${AddCIncPath} ${AddCppIncPath}

    if {${os.platform} eq "darwin" && ${os.major} <= ${legacysupport.newest_darwin_requires_legacy}} {

        # Add Build Support
        ui_debug "Adding legacy build support"

        # Depend on the support library or devel version if installed
        [get_legacysupport_depends_type]-append ${legacy_dep}

        # Add to configure options
        if {[option legacysupport.use_static]} {
            configure.ldflags-append    ${AddStaticLDFlag}
        } else {
            configure.ldflags-append    ${AddLDFlag}
        }
        configure.cflags-append   ${AddCFlag}
        configure.cppflags-append ${AddCFlag}

        # Set env vars so gcc/clang add legacy include dir to default search paths
        # Note using C_INCLUDE_PATH and CPLUS_INCLUDE_PATH to avoid conflicts
        # eith MacPorts setting of CPATH
        configure.env-append ${AddCIncPath} ${AddCppIncPath}
        build.env-append     ${AddCIncPath} ${AddCppIncPath}

    } else {

        # Remove build support
        ui_debug "Removing legacy build support"
    }

}

# Note it is intentional to both call this immediately now, and to
# register a callback to do it again later on. This is to handle the fact
# different ports do things in different ways and one or the other might
# work in any given case. Having both is not a problem, but does lead to it
# indicating being declared twice in port lint --nitpick
add_legacysupport
port::register_callback add_legacysupport
