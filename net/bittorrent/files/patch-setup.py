--- setup.py.orig	Sun Mar 30 17:01:05 2003
+++ setup.py	Sun Mar 30 17:01:20 2003
@@ -18,9 +18,9 @@
     
     packages = ["BitTorrent"],
 
-    scripts = ["btdownloadgui.py", "btdownloadheadless.py", "btdownloadlibrary.py", 
+    scripts = ["btdownloadheadless.py", "btdownloadlibrary.py", 
         "bttrack.py", "btmakemetafile.py", "btlaunchmany.py", "btcompletedir.py",
-        "btdownloadcurses.py", "btcompletedirgui.py", "btlaunchmanycurses.py", 
+        "btdownloadcurses.py", "btlaunchmanycurses.py", 
         "btmakemetafile.py", "btreannounce.py", "btrename.py", "btshowmetainfo.py",
         "bttest.py"]
     )
