--- src/qt_install.pri.orig	Mon Sep 13 09:25:13 2004
+++ src/qt_install.pri	Mon Sep 13 09:24:40 2004
@@ -24,7 +24,7 @@
     QtDocs      = /Developer/Documentation/Qt
     framework.path = $$QtFramework/Headers/private $$QtDocs
     framework.extra  = -cp -rf $$htmldocs.files $(INSTALL_ROOT)/$$QtDocs;
-    framework.extra += cp -rf $$target.path/$(TARGET) $(INSTALL_ROOT)/$$QtFramework/Qt;
+    framework.extra += cp -rf $(INSTALL_ROOT)$$target.path/$(TARGET) $(INSTALL_ROOT)/$$QtFramework/Qt;
     framework.extra += cp -rf $$headers.files $(INSTALL_ROOT)/$$QtFramework/Headers;
     framework.extra += cp -rf $$headers_p.files $(INSTALL_ROOT)/$$QtFramework/Headers/private
     INSTALLS += framework
