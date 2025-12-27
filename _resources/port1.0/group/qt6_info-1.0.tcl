# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Provides Qt6 variables.
# This PG does *not* change functionality.

# standard install directory
options         qt6.dir
default         qt6.dir         {${prefix}/libexec/qt6}

options         qt6.blacklist
default         qt6.blacklist   {}

options         qt6.base
default         qt6.base        {[qt6::base]}

options         qt6.version
default         qt6.version     {[qt6::version]}
option_proc     qt6.version     qt6::read_only_option

####################################################################################################################################
# internal data
####################################################################################################################################
namespace eval  qt6             {}

# Information about each Qt version
#
# index 0:
#     port prefix
#
# index 1:
#     supported OS versions
#     see https://doc.qt.io/qt-6/supported-platforms.html
#     for older Qt versions, see https://web.archive.org/web/*/http://doc.qt.io/qt-6/supported-platforms-and-configurations.html
#
# please keep in order with the most recent Qt and OS versions with the lowest indices
#
set qt6::available_versions {
    qt6     {6.10  {25 24 23}}
    qt69    {6.9   {25 24 23}}
    qt68    {6.8   {24 23}}
    qt67    {6.7   {24 23 22 21}}
    qt64    {6.4   {24 23 22 21 20 19 18}}
}

####################################################################################################################################
# internal procedures
####################################################################################################################################

proc qt6::is_blacklisted {qt_version} {
    foreach blacklist [option qt6.blacklist] {
        foreach {c v} ${blacklist} {
            if { [vercmp ${qt_version} $c $v] } {
                return yes
            }
        }
    }
    return no
}

proc qt6::base {} {
    global os.major

    foreach {qt_base qt_info} ${qt6::available_versions} {
        if { ${os.major} ni [lindex ${qt_info} 1] } {
            # Qt does not support this OS
            continue
        }

        if { [qt6::is_blacklisted [lindex ${qt_info} 0]] } {
            # port does not support this version of Qt
            continue
        }

        # return first acceptable Qt version found
        return ${qt_base}
    }

    # no working Qt version has been found

    set last_known_os       [lindex [lindex [lindex ${qt6::available_versions} 1] 1] 0]
    set latest_qt_version   [lindex [lindex ${qt6::available_versions} 1] 0]
    if { ${os.major} > ${last_known_os} && ![qt6::is_blacklisted ${latest_qt_version}] } {
        # the OS is newer than the one supported by the most recent version of Qt, and
        #     the latest Qt version has not been blacklisted
        # assume that a new OS has been released and the PG has not yet been updated
        return [lindex ${qt6::available_versions} 0]
    }
    return ""
}

proc qt6::version {} {
    array set qt_info [list {*}${qt6::available_versions}]
    if {[info exists qt_info([option qt6.base])]} {
        return [lindex $qt_info([option qt6.base]) 0]
    } else {
        return {}
    }
}

proc qt6::read_only_option {opt action args} {
    if {${action} eq "set"} {
        return -code error "${opt} is read-only"
    }
}

###############################################################################
# Component Format
#
# "Qt Component Name" {
#     Qt version introduced
#     Qt version removed
#     file installed by component
#     empty if module; "-plugin" if plugin
# }
#
# module info found at https://doc.qt.io/qt-6/qtmodules.html
# see also https://code.qt.io/cgit/qt/qt5.git/tree/.gitmodules
#
###############################################################################
array set qt6::components {
    qtbase {
        6.0
        7.0
        libexec/qt6/lib/QtCore.framework/Versions/A/QtCore
        ""
    }
    qtsvg {
        6.0
        7.0
        libexec/qt6/lib/QtSvg.framework/Versions/A/QtSvg
        ""
    }
    qtdeclarative {
        6.0
        7.0
        libexec/qt6/lib/QtQml.framework/QtQml
        ""
    }
    qtmultimedia {
        6.2
        7.0
        libexec/qt6/lib/QtMultimedia.framework/QtMultimedia
        ""
    }
    qttools {
        6.0
        7.0
        libexec/qt6/lib/QtUiTools.framework/QtUiTools
        ""
    }
    qttranslations {
        6.0
        7.0
        libexec/qt6/translations/qt_ar.qm
        ""
    }
    qtdoc {
        6.0
        7.0
        libexec/qt6/mkspecs/qtdoc_dummy_file.txt
        ""
    }
    qtpositioning {
        6.2
        7.0
        libexec/qt6/lib/QtPositioning.framework/QtPositioning
        ""
    }
    qtsensors {
        6.2
        7.0
        libexec/qt6/lib/QtSensors.framework/QtSensors
        ""
    }
    qtconnectivity {
        6.2
        7.0
        libexec/qt6/lib/QtBluetooth.framework/Versions/A/QtBluetooth
        ""
    }
    qt3d {
        6.1
        7.0
        libexec/qt6/lib/Qt3DCore.framework/Qt3DCore
        ""
    }
    qtimageformats {
        6.1
        7.0
        lib/cmake/Qt6/FindLibmng.cmake
        ""
    }
    qtserialbus {
        6.2
        7.0
        libexec/qt6/lib/QtSerialBus.framework/QtSerialBus
        ""
    }
    qtserialport {
        6.2
        7.0
        libexec/qt6/lib/QtSerialPort.framework/Versions/A/QtSerialPort
        ""
    }
    qtwebsockets {
        6.2
        7.0
        libexec/qt6/lib/QtWebSockets.framework/QtWebSockets
        ""
    }
    qtwebchannel {
        6.2
        7.0
        libexec/qt6/lib/QtWebChannel.framework/QtWebChannel
        ""
    }
    qtwebengine {
        6.2
        7.0
        libexec/qt6/lib/QtWebEngineCore.framework/QtWebEngineCore
        ""
    }
    qtwebview {
        6.2
        7.0
        libexec/qt6/lib/QtWebView.framework/QtWebView
        ""
    }
    qtcharts {
        6.1
        7.0
        libexec/qt6/lib/QtCharts.framework/QtCharts
        ""
    }
    qtdatavis3d {
        6.1
        7.0
        libexec/qt6/lib/QtDataVisualization.framework/QtDataVisualization
        ""
    }
    qtvirtualkeyboard {
        6.1
        7.0
        libexec/qt6/lib/QtVirtualKeyboard.framework/QtVirtualKeyboard
        ""
    }
    qtscxml {
        6.1
        7.0
        libexec/qt6/lib/QtScxml.framework/QtScxml
        ""
    }
    qtspeech {
        6.4
        7.0
        libexec/qt6/lib/QtTextToSpeech.framework/QtTextToSpeech
        ""
    }
    qtnetworkauth {
        6.1
        7.0
        libexec/qt6/lib/QtNetworkAuth.framework/Versions/A/QtNetworkAuth
        ""
    }
    qtremoteobjects {
        6.2
        7.0
        libexec/qt6/lib/QtRemoteObjects.framework/QtRemoteObjects
        ""
    }
    qtlottie {
        6.1
        7.0
        libexec/qt6/lib/QtBodymovin.framework/QtBodymovin
        ""
    }
    qtquicktimeline {
        6.0
        7.0
        libexec/qt6/lib/QtQuickTimeline.framework/QtQuickTimeline
        ""
    }
    qtquick3d {
        6.0
        7.0
        libexec/qt6/lib/QtQuick3D.framework/QtQuick3D
        ""
    }
    qtshadertools {
        6.0
        7.0
        libexec/qt6/lib/QtShaderTools.framework/Versions/A/QtShaderTools
        ""
    }
    qt5compat {
        6.0
        7.0
        libexec/qt6/lib/QtCore5Compat.framework/QtCore5Compat
        ""
    }
    qtlanguageserver {
        6.3
        7.0
        libexec/qt6/lib/QtLanguageServer.framework/QtLanguageServer
        ""
    }
    qthttpserver {
        6.4
        7.0
        libexec/qt6/lib/QtHttpServer.framework/QtHttpServer
        ""
    }
    qtquick3dphysics {
        6.4
        7.0
        libexec/qt6/lib/QtQuick3DPhysics.framework/QtQuick3DPhysics
        ""
    }
    qtgrpc {
        6.5
        7.0
        libexec/qt6/lib/QtGrpc.framework/QtGprc
        ""
    }
    qtlocation {
        6.5
        7.0
        libexec/qt6/lib/QtLocation.framework/QtLocation
        ""
    }
    qtquickeffectmaker {
        6.5
        7.0
        /opt/local/libexec/qt6/qml/QtQuickEffectMaker/defaultnodes/basic/brightness_contrast.qen
        ""
    }
    qtgraphs {
        6.6
        7.0
        libexec/qt6/lib/QtGraphs.framework/QtGraphs
        ""
    }
    sqlite-plugin {
        6.0
        7.0
        lib/cmake/Qt6Sql/Qt6Sql_QSQLiteDriverPlugin.cmake
        "-plugin"
    }
    psql-plugin {
        6.0
        7.0
        lib/cmake/Qt6Sql/Qt6Sql_QPSQLDriverPlugin.cmake
        "-plugin"
    }
    mysql-plugin {
        6.0
        7.0
        lib/cmake/Qt6Sql/Qt6Sql_QMYSQLDriverPlugin.cmake
        "-plugin"
    }
}
