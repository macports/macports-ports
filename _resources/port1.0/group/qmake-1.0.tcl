# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup defines standard settings when using qmake.
#
# Usage:
# PortGroup                     qmake 1.0

PortGroup                       qt4 1.0
PortGroup                       active_variants 1.1
PortGroup                       compiler_wrapper 1.0

options qt4.debug_variant
default qt4.debug_variant yes

pre-configure {
    set cc  [compwrap::wrap_compiler cc]
    set cxx [compwrap::wrap_compiler cxx]
    configure.cmd                   ${qt_qmake_cmd}
    configure.pre_args-delete       --prefix=${prefix}
    configure.pre_args-append       PREFIX=${prefix} \
                                    "QMAKE_CC=${cc}" \
                                    "QMAKE_CXX=${cxx}" \
                                    "QMAKE_OBJC=[compwrap::wrap_compiler objc]" \
                                    "QMAKE_CFLAGS=\"${configure.cppflags} ${configure.cflags} [get_canonical_archflags cc]\"" \
                                    "QMAKE_CXXFLAGS=\"${configure.cppflags} ${configure.cxxflags} [get_canonical_archflags cxx]\"" \
                                    "QMAKE_LFLAGS=\"${configure.cppflags} ${configure.ldflags}\"" \
                                    "QMAKE_LINK_C=${cc}" \
                                    "QMAKE_LINK_C_SHLIB=${cc}" \
                                    "QMAKE_LINK=${cxx}" \
                                    "QMAKE_LINK_SHLIB=${cxx}"
    configure.universal_args-delete --disable-dependency-tracking

    if {[variant_exists universal] && [variant_isset universal]} {
        configure.pre_args-append   "CONFIG+=\"${qt_arch_types}\""
    }
}

# add debug variant if one does not exist and one is requested via qt4.debug_variant
# variant is added in eval_variants so that qt4.debug_variant can be set anywhere in the Portfile
rename ::eval_variants ::real_qmake_eval_variants
proc eval_variants {variations} {
    global qt4.debug_variant
    if { ![variant_exists debug] && [tbool qt4.debug_variant] } {
        variant debug description {Build both release and debug binaries and libraries} {
            configure.pre_args-append   "CONFIG+=debug"
        }
    }
    uplevel ::real_qmake_eval_variants $variations
}

# check for +debug variant of this port, and make sure Qt was
# installed with +debug as well; if not, error out.
platform darwin {
    pre-extract {
        if {[variant_exists debug] && \
            [variant_isset debug] && \
           ![info exists building_qt4]} {
            if {![catch {set result [active_variants "qt4-mac" "debug" ""]}]} {
                if {$result} {
                    # code to be executed if $depspec is active with at least all variants in
                    # $required and none from $forbidden
                } else {
                    # code to be executed if $depspec is active, but either not with all
                    # variants in $required or any variant in $forbidden
                    return -code error "\n\nERROR:\n\
In order to install this port with variant +debug,\
qt4-mac must also be installed with variant +debug.\n"
                }
            } else {
                # code to be executed if $depspec isn't active
                return -code error "\n\nERROR:\n\
Requested to install this port with variant +debug,\
but qt4-mac is not installed or installed but not active.\n"
            }
        }
    }
}
