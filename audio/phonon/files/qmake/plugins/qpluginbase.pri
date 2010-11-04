# change to this file:
# (0) this header
# (1) comment out CONFIG += debug_and_release (specd elsewhere)

TEMPLATE = lib
isEmpty(QT_MAJOR_VERSION) {
   VERSION=4.7.0
} else {
   VERSION=$${QT_MAJOR_VERSION}.$${QT_MINOR_VERSION}.$${QT_PATCH_VERSION}
}
CONFIG += qt plugin

# win32|mac:!wince*:!win32-msvc:!macx-xcode:CONFIG += debug_and_release
TARGET = $$qtLibraryTarget($$TARGET)
contains(QT_CONFIG, reduce_exports):CONFIG += hide_symbols

include(../qt_targets.pri)

wince*:LIBS += $$QMAKE_LIBS_GUI

symbian: {
    TARGET.EPOCALLOWDLLDATA=1
    TARGET.CAPABILITY = All -Tcb
    TARGET = $${TARGET}$${QT_LIBINFIX}
    load(armcc_warnings)
}
