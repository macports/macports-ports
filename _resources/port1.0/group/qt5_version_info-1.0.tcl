# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Provides Qt5 version info
# Separate from the main qt5 portgroup in case a port just wants these

global available_qt_versions
array set available_qt_versions {
    qt5   {qt5-qtbase   5.15}
    qt513 {qt513-qtbase 5.13}
    qt511 {qt511-qtbase 5.11}
    qt59  {qt59-qtbase  5.9}
    qt58  {qt58-qtbase  5.8}
    qt57  {qt57-qtbase  5.7}
    qt56  {qt56-qtbase  5.6}
    qt55  {qt55-qtbase  5.5}
    qt53  {qt53-qtbase  5.3}
}
#qt5-kde {qt5-kde 5.8}

global custom_qt_versions
array set custom_qt_versions {
    phantomjs-qt {phantomjs-qt-qtbase 5.5}
}

# Qt has what is calls reference configurations, which are said to be thoroughly tested
# Qt also has configurations which are "occasionally tested" or are "[d]eployment only"
# see https://doc.qt.io/qt-5/supported-platforms.html#reference-configurations
# see https://doc.qt.io/qt-5/supported-platforms-and-configurations.html

proc qt5.get_default_name {} {
    global os.major

    # see https://doc.qt.io/qt-5/supported-platforms-and-configurations.html
    # for older versions, see https://web.archive.org/web/*/http://doc.qt.io/qt-5/supported-platforms-and-configurations.html
    if { ${os.major} <= 7 } {
        #
        # Qt 5 does not support ppc
        # see http://doc.qt.io/qt-5/osx-requirements.html
        #
        return qt55
        #
    } elseif { ${os.major} <= 9 } {
        #
        # Mac OS X Tiger (10.4)
        # Mac OS X Leopard (10.5)
        #
        # never supported by Qt 5
        #
        return qt55
        #
    } elseif { ${os.major} == 10 } {
        #
        # Mac OS X Snow Leopard (10.6)
        #
        #     Qt 5.3: Deployment only
        # Qt 5.0-5.2: Occasionally tested
        #
        return qt53
        #
    } elseif { ${os.major} == 11 } {
        #
        # Mac OS X Lion (10.7)
        #
        # Qt 5.7:  Not Supported and is known not to work
        # Qt 5.6:  Deployment only but seems to work (except QtWebEngine)
        # Qt 5.5:  Occasionally tested
        # Qt 5.4:  Supported
        #
        return qt56
        #
    } elseif { ${os.major} == 12 } {
        #
        # OS X Mountain Lion (10.8)
        #
        # Qt 5.8:  Not Supported
        # Qt 5.7:  Supported (except QtWebEngine)
        # Qt 5.6:  Supported
        #
        return qt57
        #
    } elseif { ${os.major} == 13 } {
        #
        # OS X Mavericks (10.9)
        #
        # Qt 5.9:  Not Supported
        # Qt 5.8:  Supported
        # Qt 5.7:  Supported
        # Qt 5.6:  Supported
        #
        return qt58
        #
    } elseif { ${os.major} == 14 } {
        #
        # OS X Yosemite (10.10)
        #
        # Qt 5.10: Not Supported and QtWebEngine fails
        # Qt 5.9:  Supported
        # Qt 5.8:  Supported
        # Qt 5.7:  Supported
        # Qt 5.6:  Supported
        #
        return qt59
        #
    } elseif { ${os.major} == 15 } {
        #
        # OS X El Capitan (10.11)
        #
        # Qt 5.12: Not Supported
        # Qt 5.11: Supported
        # Qt 5.10: Supported
        # Qt 5.9:  Supported
        # Qt 5.8:  Supported
        # Qt 5.7:  Supported
        # Qt 5.6:  Supported
        #
        return qt511
        #
    } elseif { ${os.major} == 16 } {
        #
        # macOS Sierra (10.12)
        #
        # Qt 5.14: Not Supported
        # Qt 5.13: Supported
        # Qt 5.12: Supported
        # Qt 5.11: Supported
        # Qt 5.10: Supported
        # Qt 5.9:  Supported
        # Qt 5.8:  Supported
        # Qt 5.7:  Not Supported but seems to work
        #
        return qt513
        #
    } elseif { ${os.major} == 17 } {
        #
        # macOS High Sierra (10.13)
        #
        # Qt 5.14: Supported
        # Qt 5.13: Supported
        # Qt 5.12: Supported
        # Qt 5.11: Supported
        # Qt 5.10: Supported
        #
        return qt5
        #
    } elseif { ${os.major} == 18 } {
        #
        # macOS Mojave (10.14)
        #
        # Qt 5.14: Supported
        # Qt 5.13: Supported
        # Qt 5.12: Supported
        #
        return qt5
        #
    } elseif { ${os.major} == 19 } {
        #
        # macOS Catalina (10.15)
        #
        # Qt 5.14: Supported
        # Qt 5.13: Not Supported but seems to work
        # Qt 5.12: Not Supported but seems to work
        #
        return qt5
        #
    } else {
        #
        # macOS ??? (???)
        #
        return qt5
    }
}

global qt5.name qt5.base_port qt5.version

# get the latest Qt version that runs on current OS configuration
set qt5.name       [qt5.get_default_name]
set qt5.base_port  [lindex $available_qt_versions(${qt5.name}) 0]
set qt5.version    [lindex $available_qt_versions(${qt5.name}) 1]

# check if another version of Qt is installed
foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
    set qt_test_base_port [lindex ${qt_test_info} 0]
    if {![catch {set installed [lindex [registry_active ${qt_test_base_port}] 0]}]} {
        set qt5.name       ${qt_test_name}
        set qt5.base_port  ${qt_test_base_port}
        set qt5.version    [lindex $installed 1]
    }
}

if {[info exists name]} {
    # check to see if this is a Qt port being built
    foreach {qt_test_name qt_test_info} [array get available_qt_versions] {
        if {${qt_test_name} eq ${name}} {
            set qt5.name       ${name}
            set qt5.base_port  [lindex $available_qt_versions(${qt5.name}) 0]
            set qt5.version    [lindex $available_qt_versions(${qt5.name}) 1]
        }
    }
}

if {[info exists qt5.custom_qt_name]} {
    set qt5.name       ${qt5.custom_qt_name}
    set qt5.base_port  [lindex $custom_qt_versions(${qt5.name}) 0]
    set qt5.version    [lindex $custom_qt_versions(${qt5.name}) 1]
}
