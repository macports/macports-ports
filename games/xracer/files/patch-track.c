--- src/track.c.orig	Thu Dec 12 14:08:55 2002
+++ src/track.c	Thu Dec 12 14:08:34 2002
@@ -76,7 +76,7 @@
   char filename[PATH_MAX];
 
   /* Try to construct the name of the shared library containing this track. */
-  snprintf (filename, sizeof filename, "tracks/libtrack%s.so", name);
+  snprintf (filename, sizeof filename, "tracks/libtrack%s.dylib", name);
 
   return xrTrackLoadByFilename (filename);
 }
@@ -104,7 +104,7 @@
     }
 
   /* The shared library contains one symbol of interest: ``track'' */
-  track_struct = dlsym (lib, "track");
+  track_struct = dlsym (lib, "_track");
 
   /* This is OK. This symbol should never actually be NULL. */
   if (track_struct == NULL)
