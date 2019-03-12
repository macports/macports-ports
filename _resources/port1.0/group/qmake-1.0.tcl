# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup defines standard settings when using qmake.
#
# Usage:
# PortGroup                     qmake 1.0

PortGroup                       qt4 1.0

pre-configure {
    configure.cmd                   ${qt_qmake_cmd}
    configure.pre_args-delete       --prefix=${prefix}
    configure.pre_args-append       PREFIX=${prefix} \
                                    "QMAKE_CC=${configure.cc}" \
                                    "QMAKE_CXX=${configure.cxx}" \
                                    "QMAKE_OBJC=${configure.objc}" \
                                    "QMAKE_CFLAGS=\"${configure.cflags} [get_canonical_archflags cc]\"" \
                                    "QMAKE_CXXFLAGS=\"${configure.cxxflags} [get_canonical_archflags cxx]\"" \
                                    "QMAKE_LFLAGS=\"${configure.ldflags}\"" \
                                    "QMAKE_LINK_C=${configure.cc}" \
                                    "QMAKE_LINK_C_SHLIB=${configure.cc}" \
                                    "QMAKE_LINK=${configure.cxx}" \
                                    "QMAKE_LINK_SHLIB=${configure.cxx}"
    configure.universal_args-delete --disable-dependency-tracking

    if {[variant_exists universal] && [variant_isset universal]} {
        configure.pre_args-append   "CONFIG+=\"${qt_arch_types}\""
    }
}

variant debug description "Enable debug binaries" {
    configure.pre_args-append   "CONFIG+=debug"
}

# check for +debug variant of this port, and make sure Qt was
# installed with +debug as well; if not, error out.
platform darwin {
    pre-extract {
        if {[variant_exists debug] && \
            [variant_isset debug] && \
           ![info exists building_qt4]} {
            if {![file exists ${qt_frameworks_dir}/QtCore.framework/QtCore_debug]} {
                return -code error "\n\nERROR:\n\
In order to install this port as +debug,
Qt4 must also be installed with +debug.\n"
            }
        }
    }
}
