--- src/track.c.orig	Thu Dec 12 12:33:27 2002
+++ src/track.c	Thu Dec 12 12:34:10 2002
@@ -104,7 +104,7 @@
     }
 
   /* The shared library contains one symbol of interest: ``track'' */
-  track_struct = dlsym (lib, "track");
+  track_struct = dlsym (lib, "_track");
 
   /* This is OK. This symbol should never actually be NULL. */
   if (track_struct == NULL)
