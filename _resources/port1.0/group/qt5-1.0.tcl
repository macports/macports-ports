# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4
#
# This portgroup defines standard settings when using Qt5.
#
# Usage:
# PortGroup     qt5 1.0

PortGroup   qt5_variables 1.0

# a procedure for declaring dependencies on Qt5 components, which will expand them
# into the appropriate subports for the Qt5 flavour installed
# e.g. qt5.depends_component qtsvg qtdeclarative
proc qt5.depends_component {args} {
    global qt5_private_components
    foreach comp ${args} {
        lappend qt5_private_components ${comp}
    }
}
proc qt5.depends_build_component {args} {
    global qt5_private_build_components
    foreach comp ${args} {
        lappend qt5_private_build_components ${comp}
    }
}
proc qt5.depends_runtime_component {args} {
    global qt5_private_runtime_components
    foreach comp ${args} {
        lappend qt5_private_runtime_components ${comp}
    }
}

options qt5.kde_variant
default qt5.kde_variant no

options qt5.min_version
default qt5.min_version 5.0

# valid value for Qt variable QMAKE_MAC_SDK
options qt5.mac_sdk
default qt5.mac_sdk     {[qt5pg::qmake_mac_sdk]}

# use PKGCONFIG for Qt discovery in configure scripts
depends_build-delete    port:pkgconfig
depends_build-append    port:pkgconfig

# standard qmake spec
# other platforms required
#     see http://doc.qt.io/qt-5/supported-platforms.html
#     and http://doc.qt.io/QtSupportedPlatforms/index.html
options qt_qmake_spec
global qt_qmake_spec_32
global qt_qmake_spec_64
compiler.blacklist-append *gcc*

if {[vercmp ${qt5.version} >= 5.15]} {
    # only qt5 5.15.x has so far been built as arm64 on MacPorts
    default supported_archs "x86_64 arm64"
} elseif {[vercmp ${qt5.version} >= 5.10]} {
    # see https://bugreports.qt.io/browse/QTBUG-58401
    default supported_archs x86_64
} else {
    # no PPC support in Qt 5
    #     see http://lists.qt-project.org/pipermail/interest/2012-December/005038.html
    default supported_archs "i386 x86_64"
}

if {[vercmp ${qt5.version} >= 5.9]} {
    # in version 5.9, QT changed how it handles multiple architectures
    # see http://web.archive.org/web/20170621174843/http://doc.qt.io/qt-5/osx.html

    set qt_qmake_spec_32 macx-clang
    set qt_qmake_spec_64 macx-clang

    destroot.env-append INSTALL_ROOT=${destroot}
} else {
    # no universal binary support in Qt 5 versions < 5.9
    #     see http://lists.qt-project.org/pipermail/interest/2012-December/005038.html
    #     and https://bugreports.qt.io/browse/QTBUG-24952
    # see https://trac.macports.org/ticket/51643
    PortGroup muniversal 1.0
    default universal_archs_supported {i386 x86_64}

    # standard destroot environment
    pre-destroot {
        global merger_destroot_env
        if {![variant_exists universal]  || ![variant_isset universal]} {
            destroot.env-append \
                INSTALL_ROOT=${destroot}
        } else {
            foreach arch ${configure.universal_archs} {
                lappend merger_destroot_env($arch) INSTALL_ROOT=${workpath}/destroot-${arch}
            }
        }
    }

    set qt_qmake_spec_32 macx-clang-32
    set qt_qmake_spec_64 macx-clang
}

default qt_qmake_spec {[qt5pg::get_default_spec]}

namespace eval qt5pg {
    proc get_default_spec {} {
        global configure.build_arch qt_qmake_spec_32 qt_qmake_spec_64
        if {![variant_exists universal]  || ![variant_isset universal]} {
            if { ${configure.build_arch} eq "i386" } {
                return ${qt_qmake_spec_32}
            } else {
                return ${qt_qmake_spec_64}
            }
        } else {
            return ${qt_qmake_spec_64}
        }
    }
}

set private_building_qt5 false
# check to see if this is a Qt base port being built
foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {${qt_test_base_port} eq ${subport}} {
        set private_building_qt5 true
    }
}
foreach {qt_test_name qt_test_info} [array get custom_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {${qt_test_base_port} eq ${subport}} {
        set private_building_qt5 true
    }
}

if {!${private_building_qt5}} {
    pre-configure {
        ui_debug "qt5 PortGroup: Qt is provided by ${qt5.name}"

        if { [variant_exists qt5kde] && [variant_isset qt5kde] } {
            if { ${qt5.base_port} ne "qt5-kde" } {
                ui_error "qt5 PortGroup: Qt is installed but not qt5-kde, as is required by this variant"
                ui_error "qt5 PortGroup: please run `sudo port uninstall --follow-dependents ${qt5.base_port} and try again"
                return -code error "improper Qt installed"
            }
        } elseif { ![info exists qt5.custom_qt_name] } {
            if { ${qt5.name} ne [qt5.get_default_name] } {
                # see https://wiki.qt.io/Qt-Version-Compatibility
                ui_warn "qt5 PortGroup: default Qt for this platform is [qt5.get_default_name] but ${qt5.name} is installed"
            }
            if { ${qt5.name} ne "qt5" } {
                ui_warn "Qt dependency is not the latest version but may be the latest supported on your OS"
            }
            if { ${os.major} < 11 } {
                ui_warn "Qt dependency is not supported on this platform and may not build"
            }
        }
    }
}

# add qt5kde variant if one does not exist and one is requested via qt5.kde_variant
# variant is added in eval_variants so that qt5.kde_variant can be set anywhere in the Portfile
rename ::eval_variants ::real_qt5_eval_variants
proc eval_variants {variations} {
    global qt5.kde_variant
    if { ![variant_exists qt5kde] && [tbool qt5.kde_variant] } {
        variant qt5kde description {use Qt patched for KDE compatibility} {}
    }
    uplevel ::real_qt5_eval_variants $variations
}

namespace eval qt5pg {
    proc register_dependents {} {
        global qt5_private_components qt5_private_build_components qt5_private_runtime_components qt5.name qt5.version qt5.min_version

        if { ![exists qt5_private_components] } {
            # no Qt components have been requested
            # qt5.depends_component has never been called
            set qt5_private_components ""
        }
        if { ![exists qt5_private_build_components] } {
            # qt5.depends_build_component has never been called
            set qt5_private_build_components ""
        }
        if { ![exists qt5_private_runtime_components] } {
            # qt5.depends_build_component has never been called
            set qt5_private_runtime_components ""
        }

        if { [variant_exists qt5kde] && [variant_isset qt5kde] } {
            set qt_kde_name qt5-kde

            depends_lib-append port:${qt_kde_name}

            foreach component ${qt5_private_components} {
                switch -exact ${component} {
                    qtwebkit -
                    qtwebengine -
                    qtwebview -
                    qtenginio {
                        # these components are subports
                        depends_lib-append port:${qt_kde_name}-${component}
                    }
                    default {
                        # qt5-kde provides all components except those above
                    }
                }
            }
            foreach component ${qt5_private_build_components} {
                switch -exact ${component} {
                    qtwebkit -
                    qtwebengine -
                    qtwebview -
                    qtenginio {
                        # these components are subports
                        depends_run-append port:${qt_kde_name}-${component}
                    }
                    default {
                        # qt5-kde provides all components except those above
                    }
                }
            }
            foreach component ${qt5_private_runtime_components} {
                switch -exact ${component} {
                    qtwebkit -
                    qtwebengine -
                    qtwebview -
                    qtenginio {
                        # these components are subports
                        depends_build-append port:${qt_kde_name}-${component}
                    }
                    default {
                        # qt5-kde provides all components except those above
                    }
                }
            }
        } else {
            # ![variant_isset qt5kde]
            foreach component "qtbase ${qt5_private_components}" {
                if { ${component} eq "qt5" } {
                    depends_lib-append path:share/doc/qt5/README.txt:${qt5.name}
                } elseif { [info exists qt5pg::qt5_component_lib(${component})] } {
                    set component_info $qt5pg::qt5_component_lib(${component})
                    set path           [lindex ${component_info} 2]
                    set version_intro  [lindex ${component_info} 0]
                    if {[vercmp ${qt5.version} >= ${version_intro}]} {
                        depends_lib-append path:${path}:${qt5.name}-${component}
                    } else {
                        if {[vercmp ${qt5.version} >= ${qt5.min_version}]} {
                            ui_warn "${component} does not exist in Qt ${qt5.version}"
                        } else {
                            # port will fail during pre-fetch
                        }
                    }
                } else {
                    return -code error "unknown component ${component}"
                }
            }
            foreach component ${qt5_private_build_components} {
                if { [info exists qt5pg::qt5_component_lib(${component})] } {
                    set component_info $qt5pg::qt5_component_lib(${component})
                    set path           [lindex ${component_info} 2]
                    set version_intro  [lindex ${component_info} 0]
                    if {[vercmp ${qt5.version} >= ${version_intro}]} {
                        depends_build-append path:${path}:${qt5.name}-${component}
                    } else {
                        if {[vercmp ${qt5.version} >= ${qt5.min_version}]} {
                            ui_warn "${component} does not exist in Qt ${qt5.version}"
                        } else {
                            # port will fail during pre-fetch
                        }
                    }
                } else {
                    return -code error "unknown component ${component}"
                }
            }
            foreach component ${qt5_private_runtime_components} {
                if { [info exists qt5pg::qt5_component_lib(${component})] } {
                    set component_info $qt5pg::qt5_component_lib(${component})
                    set path           [lindex ${component_info} 2]
                    set version_intro  [lindex ${component_info} 0]
                    if {[vercmp ${qt5.version} >= ${version_intro}]} {
                        depends_run-append path:${path}:${qt5.name}-${component}
                    } else {
                        if {[vercmp ${qt5.version} >= ${qt5.min_version}]} {
                            ui_warn "${component} does not exist in Qt ${qt5.version}"
                        } else {
                            # port will fail during pre-fetch
                        }
                    }
                } else {
                    return -code error "unknown component ${component}"
                }
            }
        }
    }
}

if {!${private_building_qt5}} {
    port::register_callback qt5pg::register_dependents
}

proc qt5pg::check_min_version {} {
    global qt5.version qt5.min_version
    if {[vercmp ${qt5.version} < ${qt5.min_version}]} {
        known_fail yes
        pre-fetch {
            ui_error "Qt version ${qt5.min_version} or above is required, but Qt version ${qt5.version} is installed"
            return -code error "Qt version too old"
        }
    }
}
port::register_callback qt5pg::check_min_version

# get a valid value for Qt variable QMAKE_MAC_SDK
proc qt5pg::qmake_mac_sdk {} {
    global  configure.sdkroot \
            configure.sdk_version

    if {${configure.sdkroot} eq "" || [file tail ${configure.sdkroot}] eq "MacOSX.sdk"} {
        return "macosx"
    } elseif {[string first . ${configure.sdk_version}] == -1} {
        set sdks [lsort -command vercmp -decreasing [glob -nocomplain [file rootname ${configure.sdkroot}]*.sdk]]
        set best_sdk_version [string map {MacOSX ""} [file rootname [file tail [lindex $sdks 0]]]]
        return macosx${best_sdk_version}
    } else {
        return macosx${configure.sdk_version}
    }
}

unset private_building_qt5
