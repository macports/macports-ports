
LOCAL_INCDIR_QT = $${WORKSRCPATH}/includes

BUILD_LIBDIR_QT = $$LOCAL_BUILD_TREE/lib
BUILD_INCDIR_QT = $$LOCAL_BUILD_TREE/includes

isEqual(TARGET,phonon) {
    CONFIG += create_prl
}

isEqual(TARGET,phonon_qt7) {
    SUFFIX_STR =
    CONFIG(debug, debug|release) {
        SUFFIX_STR = _debug
    }
    LIBS += -L$$BUILD_LIBDIR_QT -lphonon$${SUFFIX_STR}
}
