# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# This portgroup is to help prevent circular dependencies for ports that
# recent clang builds depend on, by blacklisting any clang compiler not already
# installed

PortGroup compiler_blacklist_versions 1.0

foreach ver {8.0 7.0 6.0 5.0} {
    if {![file exists ${prefix}/bin/clang-mp-${ver}]} {
        compiler.blacklist-append macports-clang-${ver}
    }
}
