# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Provides Qt6 version info
# Separate from the main qt6 portgroup in case a port just wants these

global available_qt_versions
array set available_qt_versions {
    qt6 {qt6-qtbase 6.2}
}

# Qt has what is calls reference configurations, which are said to be thoroughly tested
# Qt also has configurations which are "occasionally tested" or are "[d]eployment only"
# see https://doc.qt.io/qt-6/supported-platforms.html#reference-configurations
# see https://doc.qt.io/qt-6/supported-platforms-and-configurations.html

proc qt6.get_default_name {} {
    global os.major

    # see https://doc.qt.io/qt-6/supported-platforms-and-configurations.html
    # for older versions, see https://web.archive.org/web/*/http://doc.qt.io/qt-6/supported-platforms-and-configurations.html
    #
    # macOS Mojave (10.14) and later
    #
    # # Qt 6.0 - 6.2: Supported
    #
    return qt6
}

global qt6.name qt6.base_port qt6.version

# get the latest Qt version that runs on current OS configuration
set qt6.name        [qt6.get_default_name]
set qt6.base_port   [lindex $available_qt_versions(${qt6.name}) 0]
set qt6.version     [lindex $available_qt_versions(${qt6.name}) 1]

# check if another version of Qt is installed
foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {![catch {set installed [lindex [registry_active ${qt_test_base_port}] 0]}]} {
        set qt6.name        ${qt_test_name}
        set qt6.base_port   ${qt_test_base_port}
        set qt6.version     [lindex $installed 1]
    }
}

if {[info exists name]} {
    # check to see if this is a Qt port being built
    foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
        if {${qt_test_name} eq ${name}} {
            set qt6.name       ${name}
            set qt6.base_port  [lindex $available_qt_versions(${qt6.name}) 0]
            set qt6.version    [lindex $available_qt_versions(${qt6.name}) 1]
        }
    }
}

if {[info exists qt6.custom_qt_name]} {
    set qt6.name        ${qt6.custom_qt_name}
    set qt6.base_port   [lindex $custom_qt_versions(${qt6.name}) 0]
    set qt6.version     [lindex $custom_qt_versions(${qt6.name}) 1]
}
