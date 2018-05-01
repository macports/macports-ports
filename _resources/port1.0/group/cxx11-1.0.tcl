# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup introduces no new options. Simply including this
# PortGroup indicates that a port requires C++11. We only support C++11
# with libc++.
#
# Ideally the functionality of this PortGroup should be integrated into
# MacPorts base as a new option.

PortGroup compiler_blacklist_versions 1.0

# Compilers supporting C++11 are GCC >= 4.6 and clang >= 3.3.
# As we only support libc++, clang is implicitly required.
# Blacklist all GCC compilers to not accidentally pull in libstdc++.
# We do not know what "cc" is, so blacklist it as well.
compiler.blacklist-append   *gcc* {clang < 500} cc

pre-configure {
    if {${configure.cxx_stdlib} eq "libstdc++"} {
        ui_error "${subport} does not support your selected MacPorts C++ runtime. libc++ must be selected and C++-based ports built against it."

        if {${os.major} < 13} {
            ui_error "Please follow the instructions on https://trac.macports.org/wiki/LibcxxOnOlderSystems."
            ui_error "After adding the required options to macports.conf, reinstall all ports like you would when switching macOS versions."
            ui_error "Follow step 3 on https://trac.macports.org/wiki/Migration in order to do this."
        }

        return -code error "libstdc++ unsupported."
    }
}
