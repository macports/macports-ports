--- ../ZopeEditManager-src-0.9.4.orig/buildapp.py	Tue May 18 12:56:30 2004
+++ buildapp.py	Thu May 20 13:47:47 2004
@@ -7,8 +7,10 @@
 from bundlebuilder import buildapp, Plist
 
 plist = Plist( CFBundleIdentifier = "com.urbanape.zopeeditmanager"
-             , CFBundleShortVersionString = "Version 0.9.4"
-             , CFBundleGetInfoString = ("ZopeEditManager version 0.9.4, "
+             , CFBundleHelpBookFolder = "ZopeEditManagerHelp"
+             , CFBundleHelpBookName = "ZopeEditManager Help"
+             , CFBundleShortVersionString = "Version @VERSION@"
+             , CFBundleGetInfoString = ("ZopeEditManager version @VERSION@, "
                                         "Copyright 2003 Zope Corporation")
              , NSHumanReadableCopyright = "Copyright 2003 Zope Corporation"
              , CFBundleDocumentTypes = (
@@ -20,6 +22,7 @@
     }, ) )
 
 buildapp( name = "ZopeEditManager"
+        , creator = "ZEMD"
         , mainprogram = "__main__.py"
         , resources = [ "Resources/English.lproj"
                       , "Resources/com.urbanape.zopeeditmanager.plist"
@@ -33,6 +36,9 @@
                       , "Resources/remove_idle.png"
                       , "Resources/remove_pressed.png"
                       , "Resources/ZEMDocument.icns"
+                      , "ZopeEditController.py"
+                      , "ZopeDocument.py"
+                      , "PreferenceController.py"
                       ]
         , nibname = "MainMenu"
         , iconfile = "Resources/ZEM.icns"
