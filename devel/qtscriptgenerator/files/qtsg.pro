# -*- mode: sh -*- ###########################

TEMPLATE = subdirs
CONFIG   += ordered

QMAKE_CC = @CC@
QMAKE_CXX = @CXX@

SUBDIRS = generator qtbindings
