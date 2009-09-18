This patch is already included upstream, unfortunately *after* the 0.9.7.9 release

--- qtiplot/qtiplot.pro.orig	2009-09-18 19:46:47.000000000 +0200
+++ qtiplot/qtiplot.pro	2009-09-18 19:47:42.000000000 +0200
@@ -1,72 +1,30 @@
-# building without muParser doesn't work yet
-SCRIPTING_LANGS += muParser
-SCRIPTING_LANGS += Python
-
-# a console displaying output of scripts; particularly useful on Windows
-# where running QtiPlot from a terminal is inconvenient
-DEFINES         += SCRIPTING_CONSOLE
-
-# a dialog for selecting the scripting language on a per-project basis
-DEFINES         += SCRIPTING_DIALOG
-
-#DEFINES         += QTIPLOT_DEMO
-
-# Comment the following lines to disable donations start-up message.
-#DEFINES         += QTIPLOT_SUPPORT
-
-# Comment the next line, if you don't have libpng on your system.
-CONFIG          += HAVE_LIBPNG
-
-# Uncomment the next line in order to enable export of 2D plots to the EMF file format on Windows. You need EmfEngine on your system.
-CONFIG          += HAVE_EMF
-
-# Uncomment the following line if you want to perform a custom installation using the *.path variables defined bellow.
-#CONFIG          += CustomInstall
-
-CONFIG          += release
-#CONFIG          += debug
-#win32: CONFIG   += console
+TARGET   = qtiplot
+QTI_ROOT = ..
+!include( $$QTI_ROOT/build.conf ) {
+  message( "You need a build.conf file with local settings!" )
+}
 
 ##################### 3rd PARTY HEADER FILES SECTION ########################
-#!!! Warning: You must modify these paths according to your computer settings
+#!!! Warning: You must set this up in $$QTIROOT/build.conf
 #############################################################################
 
-INCLUDEPATH       += ../3rdparty/muparser/include
+# local copy included
 INCLUDEPATH       += ../3rdparty/qwtplot3d/include
-INCLUDEPATH       += ../3rdparty/qwt/src
 INCLUDEPATH       += ../3rdparty/liborigin
-INCLUDEPATH       += ../3rdparty/gsl/include
 INCLUDEPATH       += ../3rdparty/zlib
-INCLUDEPATH       += ../3rdparty/boost
-
-##################### 3rd PARTY LIBRARIES SECTION ###########################
-#!!! Warning: You must modify these paths according to your computer settings
-#############################################################################
-
-##################### Linux (Mac OS X) ######################################
+INCLUDEPATH 	  += ../3rdparty/QTeXEngine/src
 
-# statically link against libraries in 3rdparty
-unix:LIBS         += ../3rdparty/muparser/lib/libmuparser.a
-unix:LIBS         += ../3rdparty/qwt/lib/libqwt.a
-unix:LIBS         += ../3rdparty/gsl/lib/libgsl.a
-unix:LIBS         += ../3rdparty/gsl/lib/libgslcblas.a
-unix:LIBS         += ../3rdparty/boost/lib/libboost_date_time-gcc43-mt-1_38.a
-unix:LIBS         += ../3rdparty/boost/lib/libboost_thread-gcc43-mt-1_38.a
-
-# dynamically link against dependencies if they are installed system-wide
-#unix:LIBS         += -lmuparser
-#unix:LIBS         += -lqwt
-#unix:LIBS         += -lgsl -lgslcblas
-
-##################### Windows ###############################################
-
-win32:LIBS        += ../3rdparty/muparser/lib/libmuparser.a
-win32:LIBS        += ../3rdparty/qwt/lib/libqwt.a
-win32:LIBS        += ../3rdparty/gsl/lib/libgsl.a
-win32:LIBS        += ../3rdparty/gsl/lib/libgslcblas.a
-win32:LIBS        += ../3rdparty/zlib/libz.a
-win32:LIBS        += ../3rdparty/boost/lib/libboost_date_time-mgw34-mt.lib
-win32:LIBS        += ../3rdparty/boost/lib/libboost_thread-mgw34-mt.lib
+# configurable
+INCLUDEPATH       += $$MUPARSER_INCLUDEPATH
+INCLUDEPATH       += $$QWT_INCLUDEPATH
+INCLUDEPATH       += $$GSL_INCLUDEPATH
+INCLUDEPATH       += $$BOOST_INCLUDEPATH
+
+# configurable libs
+LIBS         += $$MUPARSER_LIBS
+LIBS         += $$QWT_LIBS
+LIBS         += $$GSL_LIBS
+LIBS         += $$BOOST_LIBS
 
 #############################################################################
 ###################### BASIC PROJECT PROPERTIES #############################
@@ -74,7 +32,6 @@
 
 QMAKE_PROJECT_DEPTH = 0
 
-TARGET         = qtiplot
 TEMPLATE       = app
 CONFIG        += qt warn_on exceptions opengl thread
 CONFIG        += assistant
@@ -137,9 +94,6 @@
                   translations/qtiplot_ja.ts \
                   translations/qtiplot_sv.ts
 
-system(lupdate -verbose qtiplot.pro)
-system(lrelease -verbose qtiplot.pro)
-
 translations.files += translations/qtiplot_de.qm \
                   translations/qtiplot_es.qm \
                   translations/qtiplot_fr.qm \
@@ -184,7 +138,7 @@
 ###############################################################
 
 INCLUDEPATH += ../3rdparty/QTeXEngine/src
-HEADERS     += ../3rdparty/QTeXEngine/src/QTeXEngine.h
+HEADERS 	+= ../3rdparty/QTeXEngine/src/QTeXEngine.h
 SOURCES     += ../3rdparty/QTeXEngine/src/QTeXPaintEngine.cpp
 SOURCES     += ../3rdparty/QTeXEngine/src/QTeXPaintDevice.cpp
 
@@ -222,20 +176,26 @@
 
 ###############################################################
 
-contains(CONFIG, HAVE_LIBPNG){
+# check if we have libpng
+!isEmpty(LIBPNG_LIBS) {
 	DEFINES += GL2PS_HAVE_LIBPNG
-	INCLUDEPATH += ../3rdparty/libpng/
-	LIBS        += ../3rdparty/libpng/libpng.a
+	INCLUDEPATH += $$LIBPNG_INCLUDEPATH
+	LIBS        += $$LIBPNG_LIBS
 }
 
 ###############################################################
 
-contains(CONFIG, HAVE_EMF){
-	win32 {
-		DEFINES += EMF_OUTPUT
-		INCLUDEPATH += ../3rdparty/EmfEngine/src
-		LIBS        += ../3rdparty/EmfEngine/libEmfEngine.a -lgdiplus
-	}
+# check if we have EmfEnginge
+!isEmpty(EMF_ENGINE_LIBS) {
+	DEFINES += EMF_OUTPUT
+	INCLUDEPATH += $$EMF_ENGINE_INCLUDEPATH
+	LIBS        += $$EMF_ENGINE_LIBS
+  win32:LIBS += -lgdiplus
+  unix:LIBS += -lEMF
 }
 
 ###############################################################
+
+# At the very end: add global include- and lib path
+unix:INCLUDEPATH += $$SYS_INCLUDEPATH
+unix:LIBS += $$SYS_LIBS
