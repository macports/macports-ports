--- src/py2app/apptemplate/src/main.m.orig	2005-05-09 13:30:34.000000000 -0600
+++ src/py2app/apptemplate/src/main.m	2006-03-07 13:05:38.000000000 -0700
@@ -382,7 +382,8 @@
         pythonProgramName = [pythonProgramName stringByDeletingLastPathComponent];
     }
 
-    setenv("PYTHONHOME", [pythonProgramName fileSystemRepresentation], 1);
+    if (![[pyOptions objectForKey:@"alias"] boolValue])
+        setenv("PYTHONHOME", [pythonProgramName fileSystemRepresentation], 1);
 	
 	// Python might not copy the strings, and some evil code may not create a new NSAutoreleasePool.
 	// Who knows.  We retain things just in case...	
