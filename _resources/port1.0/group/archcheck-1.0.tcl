# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This PortGroup checks that the architecture(s) of the given files match
# the architecture(s) we are trying to install this port as now. This is
# a crutch to get us by until a proper solution is implemented in base.
# See #20728.
#
# Usage:
#
#   PortGroup               archcheck 1.0
#   archcheck.files         file1 file2 ...
#
# Files can (and probably usually should) be specified relative to ${prefix}.

options archcheck.files
default archcheck.files {}

if {"darwin" eq ${os.platform}} {
pre-configure {
    if {[variant_exists universal] && [variant_isset universal]} {
        set requested_archs ${configure.universal_archs}
    } else {
        set requested_archs ${configure.build_arch}
    }
    foreach file ${archcheck.files} {
        # Prepend prefix if necessary.
        if {"/" != [string index ${file} 0]} {
            set file [file join ${prefix} ${file}]
        }

        # Make sure the file exists -- there have been cases where dylibs are
        # inexplicably absent (e.g. #23057).
        if {![file exists ${file}]} {
            ui_error "The file ${file} does not exist, though it was"
            ui_error "expected to have been provided by one of ${name}'s dependencies. Try"
            ui_error "rebuilding the port that should have provided that file by running"
            ui_error ""
            ui_error "    sudo port -n upgrade --force <portname>"
            ui_error ""
            return -code error "missing required file"
        }

        set file_archs [string trim [strsed [exec lipo -info ${file}] {s/.*://}]]
        set file_archs [string map {ppc7400 ppc ppc7450 ppc} ${file_archs}]

        foreach file_arch ${file_archs} {
            switch ${file_arch} {
                i386 -
                x86_64 -
                ppc -
                ppc64 {
                    # ok
                }
                default {
                    ui_error "File ${file} contains unexpected architecture ${file_arch}."
                    ui_error "This may be a bug in the archcheck portgroup."
                    return -code error "unexpected architecture"
                }
            }
        }

        foreach requested_arch ${requested_archs} {
            if {-1 == [string first " ${requested_arch} " " ${file_archs} "]} {
                set dependency [strsed [exec ${prefix}/bin/port provides ${file} 2>/dev/null] {s/.*: //}]
                ui_error "You cannot install ${name} for the architecture(s) ${requested_archs} because"
                ui_error "its dependency ${dependency} only contains the architecture(s) ${file_archs}."
                # Dependency is not universal?
                if {1 == [llength ${file_archs}]} {
                    # Trying to install this port either universal or for non-default arch?
                    if {([variant_exists universal] && [variant_isset universal]) || (${build_arch} != ${configure.build_arch})} {
                        ui_error ""
                        ui_error "Try rebuilding ${dependency} (and all its dependencies) with"
                        ui_error "the +universal variant by running"
                        ui_error ""
                        ui_error "    sudo port upgrade --enforce-variants ${dependency} +universal"
                        ui_error ""
                    # Dependency's arch is not the default arch? User has likely upgraded
                    # from Leopard to Snow Leopard and has not reinstalled all ports.
                    } elseif {${file_archs} != ${build_arch}} {
                        ui_error ""
                        ui_error "Did you upgrade to a new version of macOS? If so, please see"
                        ui_error ""
                        ui_error "    https://trac.macports.org/wiki/Migration"
                        ui_error ""
                    }
                }
                return -code error "incompatible architectures in dependencies"
            }
        }
    }
}
}
