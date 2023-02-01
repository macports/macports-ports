# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# Provides Qt6 variables
# Separate from the main qt6 portgroup in case a port just wants these

PortGroup   qt6_version_info 1.0

# standard install directory
global qt_dir
set qt_dir              ${prefix}/libexec/qt6
if {[info exists qt6.custom_qt_name]} {
    set qt_dir          ${prefix}/libexec/${qt6.custom_qt_name}
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

# standard Qt frameworks directory
global qt_frameworks_dir
set qt_frameworks_dir   ${qt_libs_dir}

global qt_archdata_dir
set qt_archdata_dir     ${qt_dir}

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
set qt_apps_dir         ${applications_dir}/Qt6

# standard CMake module directory for Qt-related files
global qt_cmake_module_dir
set qt_cmake_module_dir ${qt_libs_dir}/cmake

# standard qt-cmake command location
global qt_cmake_cmd
set qt_cmake_cmd        ${qt_dir}/bin/qt-cmake

# standard qt-configure-module command location
global qt_configure_module_cmd
set qt_configure_module_cmd ${qt_dir}/bin/qt-configure-module

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

namespace eval qt6pg {
    ###############################################################################
    # Component Format
    #
    # "Qt Component Name" {
    #     Qt version introduced
    #     Qt version removed
    #     file installed by component
    #     blank if module; "-plugin" if plugin
    # }
    #
    # module info found at https://doc.qt.io/qt-6/qtmodules.html
    #
    ###############################################################################
    array set qt6_component_lib {
        qt3d {
            6.1
            7.0
            lib/cmake/Qt63DCore
            ""
        }
        qt5compat {
            6.0
            7.0
            lib/cmake/Qt6Core5Compat
            ""
        }
        qtbase {
            6.0
            7.0
            libexec/qt6/lib/QtCore.framework/Versions/A/QtCore
            ""
        }
        qtcharts {
            6.1
            7.0
            lib/cmake/Qt6Charts
            ""
        }
        qtconnectivity {
            6.2
            7.0
            libexec/qt6/lib/QtBluetooth.framework/Versions/A/QtBluetooth
            ""
        }
        qtdeclarative {
            6.0
            7.0
            lib/cmake/Qt6Qml/Qt6QmlMacros.cmake
            ""
        }
        qtimageformats {
            6.1
            7.0
            lib/cmake/Qt6/FindLibmng.cmake
            ""
        }
        qtmultimedia {
            6.2
            7.0
            lib/cmake/Qt6Multimedia
            ""
        }
        qtnetworkauth {
            6.1
            7.0
            libexec/qt6/lib/QtNetworkAuth.framework/Versions/A/QtNetworkAuth
            ""
        }
        qtpositioning {
            6.2
            7.0
            lib/cmake/Qt6Positioning
            ""
        }
        qtremoteobjects {
            6.2
            7.0
            lib/cmake/Qt6RemoteObjects
            ""
        }
        qtsensors {
            6.2
            7.0
            lib/cmake/Qt6Sensors
            ""
        }
        qtserialbus {
            6.2
            7.0
            lib/cmake/Qt6SerialBus
            ""
        }
        qtserialport {
            6.2
            7.0
            libexec/qt6/lib/QtSerialPort.framework/Versions/A/QtSerialPort
            ""
        }
        qtshadertools {
            6.0
            7.0
            libexec/qt6/lib/QtShaderTools.framework/Versions/A/QtShaderTools
            ""
        }
        qtsvg {
            6.0
            7.0
            libexec/qt6/lib/QtSvgWidgets.framework/Versions/A/QtSvgWidgets
            ""
        }
        qttools {
            6.0
            7.0
            libexec/qt6/lib/QtUiTools.framework/Versions/A/QtUiTools
            ""
        }
        qttranslations {
            6.0
            7.0
            libexec/qt6/translations/qt_ar.qm
            ""
        }
        qtwebchannel {
            6.2
            7.0
            lib/cmake/Qt6WebChannel
            ""
        }
        qtwebsockets {
            6.2
            7.0
            lib/cmake/Qt6WebSockets
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
}
