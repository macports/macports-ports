--- src/prefops.cpp.orig	2005-11-02 17:02:34.000000000 -0500
+++ src/prefops.cpp	2005-11-02 17:03:51.000000000 -0500
@@ -230,9 +230,9 @@
   /* Reasonable default values */
 
   ret->lilypath = g_string_new ("lilypond");
-  ret->midiplayer = g_string_new ("playmidi");
-  ret->audioplayer = g_string_new ("play");
-  ret->browser = g_string_new("firefox");
+  ret->midiplayer = g_string_new ("qtplay");
+  ret->audioplayer = g_string_new ("qtplay");
+  ret->browser = g_string_new("dillo");
   ret->immediateplayback = TRUE;
   ret->playbackoutput = FALSE;
   ret->lilyentrystyle = FALSE;
