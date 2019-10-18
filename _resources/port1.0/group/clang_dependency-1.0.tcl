# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# This portgroup is to help prevent circular dependencies for ports that
# recent clang builds depend on, by blacklisting any clang compiler not already
# installed

# call this if an older clang version depends on the port
proc clang_dependency.extra_versions {versions} {
    global prefix
    foreach ver $versions {
        if {![file exists ${prefix}/bin/clang-mp-${ver}]} {
            compiler.blacklist-append macports-clang-${ver}
        }
    }
}

clang_dependency.extra_versions {9.0 8.0 7.0 6.0 5.0}
