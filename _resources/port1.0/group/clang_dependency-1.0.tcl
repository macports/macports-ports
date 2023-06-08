# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# This portgroup is to help prevent circular dependencies for ports that
# recent clang builds depend on, by blacklisting all 5+ clang compilers.

# call this if an older clang version depends on the port
proc clang_dependency.extra_versions {versions} {
    global prefix
    foreach ver $versions {
        compiler.blacklist-append macports-clang-${ver}
    }
}

clang_dependency.extra_versions {devel 16 15 14 13 12 11 10 9.0 8.0 7.0 6.0 5.0}
