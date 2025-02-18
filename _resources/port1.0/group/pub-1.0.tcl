# -*- coding: utf-8; mode: tcl; c-basic-offset: 4; indent-tabs-mode: nil; tab-width: 4; truncate-lines: t -*- vim:fenc=utf-8:et:sw=4:ts=4:sts=4
#
# This PortGroup supports the Dart pub build system
#
# Usage:
#
# PortGroup     pub 1.0
#
# pub.packages \
#     foo  1.0.1  abcdef123456... \
#     bar  2.5.0  fedcba654321...
#
# The pub.packages option expects a list with 3-tuples consisting of name,
# version, and sha256 checksum. Only sha256 is supported at this time as the
# checksum will be reused by pub internally.
#
# The list of packages and their checksums can be found in the pubspec.lock file
# in the upstream source code. The pub2port generator can be used to automate
# updates of this list for new releases.
#
# https://github.com/amake/pub2port
#
# Dependencies on packages not published on pub.dev are currently unsupported.

PortGroup                 dart 1.0

options \
    pub.home \
    pub.get_args \
    pub.packages

default pub.home          {${workpath}/.home/.pub-cache}
default pub.get_args      {--offline --enforce-lockfile}
default pub.packages      {}

set pub_env {PUB_CACHE=${pub.home}}

default build.env         ${pub_env}
default test.env          ${pub_env}

# The distfiles of the main port will also be stored in this directory, but this
# is the only way to allow reusing the same packages across multiple ports.
default dist_subdir  {[expr {[llength ${pub.packages}] > 0 ? "pub-packages" : ${name}}]}
default extract.only {[pub::disttagclean ${distfiles}]}

####################################################################################################################################
# Internal procedures
####################################################################################################################################

namespace eval pub {}

# Based on rust::disttagclean from cargo_fetch-1.0.tcl
proc pub::disttagclean {list} {
    if {$list eq ""} {
        return $list
    }
    foreach fname $list {
        set name [getdistname ${fname}]

        set is_pkg no
        foreach {pname pversion chksum} [option pub.packages] {
            set pubfile ${pname}-${pversion}.tar.gz
            if {${name} eq ${pubfile}} {
                set is_pkg yes
            }
        }
        if {!${is_pkg}} {
            lappend val ${name}
        }
    }
    return $val
}

proc pub::handle_packages {} {
    foreach {pname pversion chksum} [option pub.packages] {
        # The same package name can appear with multiple versions. Use a
        # combination of crate name and checksum as unique identifier. As the
        # :disttag cannot contain dots, the version number cannot be used.
        set pubfile         ${pname}-${pversion}.tar.gz
        set pubtag          pub-${pname}-${chksum}
        distfiles-append    ${pubfile}:${pubtag}
        master_sites-append https://pub.dev/api/archives/:${pubtag}
        checksums-append    ${pubfile} sha256 ${chksum}
    }
}
port::register_callback pub::handle_packages

proc pub::extract_package {pname pversion pubfile} {
    set targetdir "[option pub.home]/hosted/pub.dev/${pname}-${pversion}"
    file mkdir ${targetdir}
    set tar [findBinary tar ${portutil::autoconf::tar_path}]
    system -W ${targetdir} "${tar} -xf [shellescape [option distpath]/${pubfile}]"
}

proc pub::import_package {pname pversion chksum pubfile} {
    global pub.home

    pub::extract_package ${pname} ${pversion} ${pubfile}

    set chkfile [open "${pub.home}/hosted-hashes/pub.dev/${pname}-${pversion}.sha256" "w"]
    puts -nonewline ${chkfile} ${chksum}
    close ${chkfile}
}

post-extract {
    if {[llength ${pub.packages}] > 0} {
        file mkdir ${pub.home}/hosted/pub.dev ${pub.home}/hosted-hashes/pub.dev

        foreach {pname pversion chksum} [option pub.packages] {
            set pubfile ${pname}-${pversion}.tar.gz
            pub::import_package ${pname} ${pversion} ${chksum} ${pubfile}
        }
        system -W ${worksrcpath} "PUB_CACHE=${pub.home} ${dart.bin} pub get ${pub.get_args}"
    }
}
