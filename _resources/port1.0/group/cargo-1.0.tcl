# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# Copyright (c) 2018 The MacPorts Project
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of Apple Computer, Inc. nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# This PortGroup supports the cargo build system
#
# Usage:
#
# PortGroup     cargo 1.0
#
# cargo.crates \
#     foo  1.0.1  abcdef123456... \
#     bar  2.5.0  fedcba654321...
#
# The cargo.crates option expects a list with 4-tuples consisting of name,
# version, and sha256 checksum. Only sha256 is supported at this time as
# the checksum will be reused by cargo internally.
#
# The list of crates and their checksums can be found in the Cargo.lock file in
# the upstream source code. The cargo2port generator can be used to automate
# updates of this list for new releases.
#
# https://github.com/macports/macports-contrib/tree/master/cargo2port/cargo2port.tcl
#
# If Cargo.lock references pre-release versions, or in general references
# crates not published on crates.io, but available from GitHub, also use the
# following:
#
# # download additional crates from github, not published on crates.io
# cargo.crates_github \
#    baz    author/baz  branch  abcdef12345678...commit...abcdef12345678  fedcba654321...
#

options cargo.home cargo.crates cargo.crates_github

default cargo.home      {${workpath}/.home/.cargo}
default cargo.crates    {}
default cargo.crates_github {}

option_proc cargo.crates handle_cargo_crates
proc handle_cargo_crates {option action {value ""}} {
    if {${action} eq "set"} {
        foreach {cname cversion chksum} ${value} {
            set cratefile       ${cname}-${cversion}.crate
            # The same crate name can appear with multiple versions. Use
            # a combination of crate name and checksum as unique identifier.
            # As the :disttag cannot contain dots, the version number cannot be
            # used.
            set cratetag        crate-${cname}-${chksum}
            distfiles-append    ${cratefile}:${cratetag}
            master_sites-append https://crates.io/api/v1/crates/${cname}/${cversion}/download?dummy=:${cratetag}
            checksums-append    ${cratefile} sha256 ${chksum}
        }
    }
}

option_proc cargo.crates_github handle_cargo_crates_github
proc handle_cargo_crates_github {option action {value ""}} {
    if {${action} eq "set"} {
        foreach {cname cgithub cbranch crevision chksum} ${value} {
            set cratefile       ${cname}-${crevision}.tar.gz
            # The same crate name can appear with multiple versions. Use
            # a combination of crate name and checksum as unique identifier.
            # As the :disttag cannot contain dots, the version number cannot be
            # used.
            set cratetag        crate-${cname}-${chksum}
            distfiles-append    ${cratefile}:${cratetag}
            master_sites-append https://github.com/${cgithub}/archive/${crevision}.tar.gz?dummy=:${cratetag}
            checksums-append    ${cratefile} sha256 ${chksum}
        }
    }
}

proc cargo._extract_crate {cratefile} {
    global cargo.home distpath

    set tar [findBinary tar ${portutil::autoconf::tar_path}]
    system -W "${cargo.home}/macports" "$tar -xf ${distpath}/${cratefile}"
}

proc cargo._write_cargo_checksum {cdirname chksum} {
    global cargo.home

    # although cargo will never see the .crate, it expects to find the sha256 checksum here
    set chkfile [open "${cargo.home}/macports/${cdirname}/.cargo-checksum.json" "w"]
    puts $chkfile "{"
    puts $chkfile "    \"package\": ${chksum},"
    puts $chkfile "    \"files\": {}"
    puts $chkfile "}"
    close $chkfile
}

proc cargo._import_crate {cname cversion chksum cratefile} {
    global cargo.home

    ui_info "Adding ${cratefile} to cargo home"
    cargo._extract_crate ${cratefile}
    cargo._write_cargo_checksum "${cname}-${cversion}" "\"${chksum}\""
}

proc cargo._import_crate_github {cname cgithub crevision chksum cratefile} {
    global cargo.home

    set crepo [lindex [split ${cgithub} "/"] 1]
    set cdirname "${crepo}-${crevision}"

    ui_info "Adding ${cratefile} from github to cargo home"
    cargo._extract_crate ${cratefile}
    cargo._write_cargo_checksum ${cdirname} "null"
}

# The distfiles of the main port will also be stored in this directory,
# but this is the only way to allow reusing the same crates across multiple ports.
dist_subdir             cargo-crates

default extract.only    {${distname}${extract.suffix}}

depends_build           port:cargo

post-extract {
    file mkdir "${cargo.home}/macports"

    # use a replacement for crates.io
    # https://doc.rust-lang.org/cargo/reference/source-replacement.html
    set conf [open "${cargo.home}/config" "w"]
    puts $conf "\[source\]"
    puts $conf "\[source.macports\]"
    puts $conf "directory = \"${cargo.home}/macports\""
    puts $conf "\[source.crates-io\]"
    puts $conf "replace-with = \"macports\""
    puts $conf "local-registry = \"/var/empty\""
    if {[llength ${cargo.crates_github}] > 0} {
        foreach {cname cgithub cbranch crevision chksum} ${cargo.crates_github} {
            puts $conf "\[source.\"https://github.com/${cgithub}\"\]"
            puts $conf "git = \"https://github.com/${cgithub}\""
            puts $conf "branch = \"${cbranch}\""
            puts $conf "replace-with = \"macports\""
        }
    }
    close $conf

    # import all crates
    foreach {cname cversion chksum} ${cargo.crates} {
        set cratefile ${cname}-${cversion}.crate
        cargo._import_crate ${cname} ${cversion} ${chksum} ${cratefile}
    }
    foreach {cname cgithub cbranch crevision chksum} ${cargo.crates_github} {
        set cratefile ${cname}-${crevision}.tar.gz
        cargo._import_crate_github ${cname} ${cgithub} ${crevision} ${chksum} ${cratefile}
    }
}

use_configure       no

build.cmd           cargo build
build.target
build.pre_args      --release --frozen -v -j${build.jobs}
build.args
build.env           RUSTFLAGS="-C linker=${configure.cc}"

destroot {
    ui_error "No destroot phase in the Portfile!"
    ui_msg "Here is an example destroot phase:"
    ui_msg
    ui_msg "destroot {"
    ui_msg {    xinstall -m 755 ${worksrcpath}/target/release/${name} ${destroot}${prefix}/bin/}
    ui_msg {    xinstall -m 444 ${worksrcpath}/doc/${name}.1 ${destroot}${prefix}/share/man/man1/}
    ui_msg "}"
    ui_msg
    ui_msg "Please check if there are additional files (configuration, documentation, etc.) that need to be installed."
    error "destroot phase not implemented"
}
