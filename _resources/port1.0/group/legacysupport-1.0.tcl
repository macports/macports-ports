# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup provides support for various missing library functions
# on older OS releases.

# Newest OSX release that requires legacy support.
# Currently OSX 10.11 (Darwin 15) due to clock_gettime
options legacysupport.newest_darwin_requires_legacy
default legacysupport.newest_darwin_requires_legacy 15

proc add_legacysupport {} {
    
    global prefix
    global os.platform os.major
    global legacysupport.newest_darwin_requires_legacy

    set MPLegacyIncDir ${prefix}/include/LegacySupport
    set AddLDFlag      -lMacportsLegacySupport
    set AddCFlag       -I${MPLegacyIncDir}
    set AddCIncPath       C_INCLUDE_PATH=${MPLegacyIncDir}
    set AddCppIncPath CPLUS_INCLUDE_PATH=${MPLegacyIncDir}

    if {${os.platform} eq "darwin" && ${os.major} <= ${legacysupport.newest_darwin_requires_legacy}} {

        # Add Build Support
        ui_debug "Adding legacy build support"

        # Depend on the support library or devel version if installed
        depends_lib-append path:lib/libMacportsLegacySupport.dylib:legacy-support
        
        # Add to configure options
        configure.ldflags-append  ${AddLDFlag}
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

        # port dependency
        depends_lib-delete port:legacy-support
        
        # configure options
        configure.ldflags-delete  ${AddLDFlag}
        configure.cflags-delete   ${AddCFlag} 
        configure.cppflags-delete ${AddCFlag}
        
        # Include Dirs
        configure.env-delete ${AddCIncPath} ${AddCppIncPath}
        build.env-delete     ${AddCIncPath} ${AddCppIncPath}

    }

}

# Note it is intentional to both call this immediately now, and to
# register a callback to do it again later on. This is to handle the fact
# different ports do things in different ways and one or the other might
# work in any given case. Having both is not a problem, but does lead to it
# indicating being declared twice in port lint --nitpick
add_legacysupport
port::register_callback add_legacysupport

