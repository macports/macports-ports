--- src/prefops.c.orig	2006-12-22 07:51:18.000000000 -0500
+++ src/prefops.c	2007-01-11 23:09:16.000000000 -0500
@@ -88,10 +88,10 @@
   /* Reasonable default values */
 
   ret->lilypath = g_string_new ("lilypond");
-  ret->midiplayer = g_string_new ("playmidi");
-  ret->audioplayer = g_string_new ("play");
+  ret->midiplayer = g_string_new ("qtplay");
+  ret->audioplayer = g_string_new ("qtplay");
   ret->csoundcommand = g_string_new ("csound -dm6");
-  ret->browser = g_string_new ("firefox");
+  ret->browser = g_string_new ("dillo");
   ret->csoundorcfile = g_string_new ("");
   ret->pdfviewer = g_string_new ("xpdf");
   ret->texteditor = g_string_new ("xedit");
