--- src/qt_install.pri.orig	Thu Feb 12 09:07:52 2004
+++ src/qt_install.pri	Thu Feb 12 09:08:18 2004
@@ -20,11 +20,11 @@
 INSTALLS += translations
 
 macx { #mac framework
-    QtFramework = /System/Library/Frameworks/Qt.framework
+    QtFramework = /Library/Frameworks/Qt.framework
     QtDocs      = /Developer/Documentation/Qt
     framework.path = $$QtFramework/Headers/private $$QtDocs
     framework.extra  = -cp -rf $$htmldocs.files $(INSTALL_ROOT)/$$QtDocs;
-    framework.extra += cp -rf $$target.path/$(TARGET) $(INSTALL_ROOT)/$$QtFramework/Qt;
+    framework.extra += cp -rf $(INSTALL_ROOT)$$target.path/$(TARGET) $(INSTALL_ROOT)/$$QtFramework/Qt;
     framework.extra += cp -rf $$headers.files $(INSTALL_ROOT)/$$QtFramework/Headers;
     framework.extra += cp -rf $$headers_p.files $(INSTALL_ROOT)/$$QtFramework/Headers/private
     INSTALLS += framework
