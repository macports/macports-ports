--- psi-otr.pro.orig	2008-01-14 23:01:56.000000000 +0100
+++ psi-otr.pro	2008-01-14 23:00:00.000000000 +0100
@@ -7,10 +7,10 @@
 CONFIG	+= release
 LIBS += -lotr
 DEPENDPATH += .
-INCLUDEPATH += .
+INCLUDEPATH += /opt/local/include
 QT += xml
 DESTDIR	= .
-target.path = /usr/local/share/psi/plugins
+target.path = /opt/local/share/psi/plugins
 INSTALLS += target
 
 # Input
