--- buildapp.py.orig	Thu Jan  8 19:48:20 2004
+++ buildapp.py	Thu Mar  4 23:33:59 2004
@@ -7,8 +7,10 @@
 from bundlebuilder import buildapp, Plist
 
 plist = Plist( CFBundleIdentifier = "com.urbanape.zopeeditmanager"
-             , CFBundleShortVersionString = "Version 0.9.2"
-             , CFBundleGetInfoString = ("ZopeEditManager version 0.9.2, "
+             , CFBundleShortVersionString = "Version @VERSION@"
+             , CFBundleHelpBookFolder = "ZopeEditManagerHelp"
+             , CFBundleHelpBookName = "ZopeEditManager Help"
+             , CFBundleGetInfoString = ("ZopeEditManager version @VERSION@, "
                                         "Copyright 2003 Zope Corporation")
              , NSHumanReadableCopyright = "Copyright 2003 Zope Corporation"
              , CFBundleDocumentTypes = ( { 'CFBundleTypeExtensions' : ( 'zem', ),
@@ -18,6 +20,7 @@
                                            'CFBundleTypeIconFile' : 'ZEMDocument.icns', }, ) )
 
 buildapp( name = "ZopeEditManager"
+        , creator = "ZEMD"
         , mainprogram = "__main__.py"
         , resources = [ "Resources/English.lproj"
                       , "Resources/com.urbanape.zopeeditmanager.plist"
@@ -31,6 +34,9 @@
                       , "Resources/remove_idle.png"
                       , "Resources/remove_pressed.png"
                       , "Resources/ZEMDocument.icns"
+                      , "ZopeEditController.py"
+                      , "ZopeDocument.py"
+                      , "PreferenceController.py"
                       ]
         , nibname = "MainMenu"
         , iconfile = "Resources/ZEM.icns"
