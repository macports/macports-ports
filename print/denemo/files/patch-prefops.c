--- src/prefops.c.orig	2006-02-09 14:56:10.000000000 -0500
+++ src/prefops.c	2006-02-10 14:12:09.000000000 -0500
@@ -89,10 +89,10 @@
     /* Reasonable default values */
 
     ret->lilypath = g_string_new ("lilypond");
-    ret->midiplayer = g_string_new ("playmidi");
-    ret->audioplayer = g_string_new ("play");
+    ret->midiplayer = g_string_new ("qtplay");
+    ret->audioplayer = g_string_new ("qtplay");
     ret->csoundcommand = g_string_new("csound -dm6");
-    ret->browser = g_string_new("firefox");
+    ret->browser = g_string_new("dillo");
     ret->csoundorcfile = g_string_new("");
     ret->pdfviewer = g_string_new("xpdf");
     ret->texteditor = g_string_new("xedit");
