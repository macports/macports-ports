--- setup.py.orig	Tue Oct 12 15:04:14 2004
+++ setup.py	Tue Oct 12 17:35:26 2004
@@ -4,8 +4,8 @@
 plist = dict(
     CFBundleExecutable = "ZopeEditManager",
     CFBundleIdentifier = "com.urbanape.zopeeditmanager",
-    CFBundleShortVersionString = "Version 0.9.5",
-    CFBundleGetInfoString = ("ZopeEditManager version 0.9.5, "
+    CFBundleShortVersionString = "Version @VERSION@",
+    CFBundleGetInfoString = ("ZopeEditManager version @VERSION@, "
                              "Copyright 2003 Zope Corporation"),
     NSHumanReadableCopyright = "Copyright 2003 Zope Corporation",
     CFBundleIconFile = "ZEM.icns",
@@ -16,6 +16,8 @@
     NSMainNibFile = "MainMenu",
     NSPrincipalClass = "NSApplication",
     CFBundleDevelopmentRegion = "English",
+    CFBundleHelpBookFolder = "ZopeEditManagerHelp",
+    CFBundleHelpBookName = "ZopeEditManager Help",
     CFBundleDocumentTypes = [
         dict(CFBundleTypeExtensions = ["zem"],
              CFBundleTypeOSTypes = ["ZEMD"],
