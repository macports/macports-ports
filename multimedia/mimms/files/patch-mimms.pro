--- mimms.pro	2006-06-05 00:24:32.000000000 +0000
+++ mimms.pro.new	2007-06-13 05:47:57.000000000 +0000
@@ -5,7 +5,7 @@
 TEMPLATE = app
 TARGET += 
 DEPENDPATH += .
-INCLUDEPATH += . libmms /usr/include/libmms /usr/include/glib-2.0 /usr/lib/glib-2.0/include
+INCLUDEPATH += . libmms @prefix@/include/libmms @prefix@/include/glib-2.0 @prefix@/lib/glib-2.0/include
 CONFIG += release
 LIBS += -lmms
 QT -= gui
