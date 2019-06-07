# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup supports the cargo build system
#
# This PortGroup is designed to be used when cargo is the
#    exclusive build mechanism.
# Use the cargo_fetch PortGroup if cargo is called from other
#    build mechanisms (e.g. configure and make).
#
# Usage:
#
# PortGroup     cargo 1.0
#
# See the cargo_fetch PortGroup for more options
#

PortGroup cargo_fetch 1.0

use_configure       no
default universal_variant yes

if {[vercmp [macports_version] 2.5.3] <= 0} {
    default build.cmd   {"${cargo.bin} build"}
} else {
    default build.cmd   {${cargo.bin} build}
}
build.target
build.pre_args      --release --frozen -v -j${build.jobs}
build.args

destroot {
    ui_error "No destroot phase in the Portfile!"
    ui_msg "Here is an example destroot phase:"
    ui_msg
    ui_msg "destroot {"
    ui_msg {    xinstall -m 0755 ${worksrcpath}/target/release/${name} ${destroot}${prefix}/bin/}
    ui_msg {    xinstall -m 0444 ${worksrcpath}/doc/${name}.1 ${destroot}${prefix}/share/man/man1/}
    ui_msg "}"
    ui_msg
    ui_msg "Please check if there are additional files (configuration, documentation, etc.) that need to be installed."
    error "destroot phase not implemented"
}
