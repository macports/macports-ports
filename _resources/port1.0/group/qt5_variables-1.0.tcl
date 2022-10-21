# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Provides Qt5 variables
# Separate from the main qt5 portgroup in case a port just wants these

PortGroup   qt5_version_info 1.0

# standard install directory
global qt_dir
set qt_dir               ${prefix}/libexec/qt5
if {[info exists qt5.custom_qt_name]} {
    set qt_dir           ${prefix}/libexec/${qt5.custom_qt_name}
}

# standard Qt non-.app executables directory
global qt_bins_dir
set qt_bins_dir         ${qt_dir}/bin

# standard Qt includes directory
global qt_includes_dir
set qt_includes_dir     ${qt_dir}/include

# standard Qt libraries directory
global qt_libs_dir
set qt_libs_dir         ${qt_dir}/lib

# standard Qt libraries directory
global qt_frameworks_dir
set qt_frameworks_dir   ${qt_libs_dir}

global qt_archdata_dir
set qt_archdata_dir  ${qt_dir}

# standard Qt plugins directory
global qt_plugins_dir
set qt_plugins_dir      ${qt_archdata_dir}/plugins

# standard Qt imports directory
global qt_imports_dir
set qt_imports_dir      ${qt_archdata_dir}/imports

# standard Qt qml directory
global qt_qml_dir
set qt_qml_dir          ${qt_archdata_dir}/qml

# standard Qt data directory
global qt_data_dir
set qt_data_dir         ${qt_dir}

# standard Qt documents directory
global qt_docs_dir
set qt_docs_dir         ${qt_data_dir}/doc

# standard Qt translations directory
global qt_translations_dir
set qt_translations_dir ${qt_data_dir}/translations

# standard Qt sysconf directory
global qt_sysconf_dir
set qt_sysconf_dir      ${qt_dir}/etc/xdg

# standard Qt examples directory
global qt_examples_dir
set qt_examples_dir     ${qt_dir}/examples

# standard Qt tests directory
global qt_tests_dir
set qt_tests_dir        ${qt_dir}/tests

# data used by qmake
global qt_host_data_dir
set qt_host_data_dir    ${qt_dir}

# standard Qt mkspecs directory
global qt_mkspecs_dir
set qt_mkspecs_dir      ${qt_dir}/mkspecs

# standard Qt .app executables directory, if created
global qt_apps_dir
set qt_apps_dir         ${applications_dir}/Qt5

# standard CMake module directory for Qt-related files
#global qt_cmake_module_dir
set qt_cmake_module_dir ${qt_libs_dir}/cmake

# standard qmake command location
global qt_qmake_cmd
set qt_qmake_cmd        ${qt_dir}/bin/qmake

# standard moc command location
global qt_moc_cmd
set qt_moc_cmd          ${qt_dir}/bin/moc

# standard uic command location
global qt_uic_cmd
set qt_uic_cmd          ${qt_dir}/bin/uic

# standard lrelease command location
global qt_lrelease_cmd
set qt_lrelease_cmd     ${qt_dir}/bin/lrelease

# standard lupdate command location
global qt_lupdate_cmd
set qt_lupdate_cmd     ${qt_dir}/bin/lupdate

# standard PKGCONFIG path
global qt_pkg_config_dir
set qt_pkg_config_dir   ${qt_libs_dir}/pkgconfig

namespace eval qt5pg {
    ############################################################################### Component Format
    #
    # "Qt Component Name" {
    #     Qt version introduced
    #     Qt version removed
    #     file installed by component
    #     blank if module; "-plugin" if plugin
    # }
    #
    # module info found at https://doc.qt.io/qt-5/qtmodules.html
    #
    ###############################################################################
    array set qt5_component_lib {
        qt3d {
            5.5
            6.0
            lib/pkgconfig/Qt53DCore.pc
            ""
        }
        qtbase {
            5.0
            6.0
            lib/pkgconfig/Qt5Core.pc
            ""
        }
        qtcanvas3d {
            5.5
            5.13
            libexec/qt5/qml/QtCanvas3D/libqtcanvas3d.dylib
            ""
        }
        qtcharts {
            5.7
            6.0
            lib/pkgconfig/Qt5Charts.pc
            ""
        }
        qtconnectivity {
            5.2
            6.0
            lib/pkgconfig/Qt5Bluetooth.pc
            ""
        }
        qtdatavis3d {
            5.7
            6.0
            lib/pkgconfig/Qt5DataVisualization.pc
            ""
        }
        qtdeclarative {
            5.0
            6.0
            lib/pkgconfig/Qt5Qml.pc
            ""
        }
        qtdeclarative-render2d {
            5.7
            5.8
            lib/cmake/Qt5Quick/Qt5Quick_ContextPlugin.cmake
            ""
        }
        qtdoc {
            5.0
            6.0
            libexec/qt5/doc/qtdoc.qch
            ""
        }
        qtgamepad {
            5.7
            6.0
            lib/pkgconfig/Qt5Gamepad.pc
            ""
        }
        qtenginio {
            5.3
            5.7
            lib/pkgconfig/Enginio.pc
            ""
        }
        qtgraphicaleffects {
            5.0
            6.0
            libexec/qt5/qml/QtGraphicalEffects/libqtgraphicaleffectsplugin.dylib
            ""
        }
        qtimageformats {
            5.0
            6.0
            lib/cmake/Qt5Gui/Qt5Gui_QTiffPlugin.cmake
            ""
        }
        qtlocation {
            5.2
            6.0
            lib/pkgconfig/Qt5Location.pc
            ""
        }
        qtlottie {
            5.13
            6.0
            lib/cmake/Qt5Bodymovin/Qt5BodymovinConfig.cmake
            ""
        }
        qtmacextras {
            5.2
            6.0
            lib/pkgconfig/Qt5MacExtras.pc
            ""
        }
        qtmultimedia {
            5.0
            6.0
            lib/pkgconfig/Qt5Multimedia.pc
            ""
        }
        qtnetworkauth {
            5.8
            6.0
            lib/pkgconfig/Qt5NetworkAuth.pc
            ""
        }
        qtpurchasing {
            5.7
            6.0
            lib/pkgconfig/Qt5Purchasing.pc
            ""
        }
        qtquick1 {
            5.0
            5.6
            lib/pkgconfig/Qt5Declarative.pc
            ""
        }
        qtquick3d {
            5.14
            6.0
            lib/pkgconfig/Qt5Quick3D.pc
            ""
        }
        qtquickcontrols {
            5.1
            6.0
            libexec/qt5/qml/QtQuick/Controls/libqtquickcontrolsplugin.dylib
            ""
        }
        qtquickcontrols2 {
            5.6
            6.0
            lib/pkgconfig/Qt5QuickControls2.pc
            ""
        }
        qtquicktimeline {
            5.14
            6.0
            libexec/qt5/qml/QtQuick/Timeline/libqtquicktimelineplugin.dylib
            ""
        }
        qtremoteobjects {
            5.9
            6.0
            lib/pkgconfig/Qt5RemoteObjects.pc
            ""
        }
        qtscript {
            5.0
            6.0
            lib/pkgconfig/Qt5Script.pc
            ""
        }
        qtscxml {
            5.7
            6.0
            lib/pkgconfig/Qt5Scxml.pc
            ""
        }
        qtsensors {
            5.1
            6.0
            lib/pkgconfig/Qt5Sensors.pc
            ""
        }
        qtserialbus {
            5.6
            6.0
            lib/pkgconfig/Qt5SerialBus.pc
            ""
        }
        qtserialport {
            5.1
            6.0
            lib/pkgconfig/Qt5SerialPort.pc
            ""
        }
        qtspeech {
            5.8
            6.0
            lib/pkgconfig/Qt5TextToSpeech.pc
            ""
        }
        qtsvg {
            5.0
            6.0
            lib/pkgconfig/Qt5Svg.pc
            ""
        }
        qttools {
            5.0
            6.0
            lib/pkgconfig/Qt5Designer.pc
            ""
        }
        qttranslations {
            5.0
            6.0
            libexec/qt5/translations/qt_ar.qm
            ""
        }
        qtvirtualkeyboard {
            5.7
            6.0
            lib/cmake/Qt5Gui/Qt5Gui_QVirtualKeyboardPlugin.cmake
            ""
        }
        qtwebchannel {
            5.4
            6.0
            lib/pkgconfig/Qt5WebChannel.pc
            ""
        }
        qtwebengine {
            5.4
            6.0
            lib/pkgconfig/Qt5WebEngine.pc
            ""
        }
        qtwebglplugin {
            5.10
            6.0
            lib/cmake/Qt5Gui/Qt5Gui_QWebGLIntegrationPlugin.cmake
            ""
        }
        qtwebkit {
            5.0
            6.0
            lib/pkgconfig/Qt5WebKit.pc
            ""
        }
        qtwebkit-examples {
            5.0
            6.0
            libexec/qt5/examples/webkitwidgets/webkitwidgets.pro
            ""
        }
        qtwebsockets {
            5.3
            6.0
            lib/pkgconfig/Qt5WebSockets.pc
            ""
        }
        qtwebview {
            5.6
            6.0
            lib/pkgconfig/Qt5WebView.pc
            ""
        }
        qtxmlpatterns {
            5.0
            6.0
            lib/pkgconfig/Qt5XmlPatterns.pc
            ""
        }
        sqlite-plugin {
            5.0
            6.0
            lib/cmake/Qt5Sql/Qt5Sql_QSQLiteDriverPlugin.cmake
            "-plugin"
        }
        psql-plugin {
            5.0
            6.0
            lib/cmake/Qt5Sql/Qt5Sql_QPSQLDriverPlugin.cmake
            "-plugin"
        }
        mysql-plugin {
            5.0
            6.0
            lib/cmake/Qt5Sql/Qt5Sql_QMYSQLDriverPlugin.cmake
            "-plugin"
        }
    }
    #
    #
    #qtjsbackend {
    #    5.0
    #    5.2
    #    ""
    #}
    #
    # qtwebkit: official support dropped in 5.6.0
    #           as of 5.9, still maintained by community
}
