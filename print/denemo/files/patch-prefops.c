--- src/prefops.c.orig	2009-02-01 11:40:50.000000000 -0500
+++ src/prefops.c	2009-02-01 11:41:28.000000000 -0500
@@ -72,18 +72,18 @@
   /* Reasonable default values */
 
   ret->lilypath = g_string_new ("lilypond");
-  ret->midiplayer = g_string_new ("playmidi");
-  ret->audioplayer = g_string_new ("play");
+  ret->midiplayer = g_string_new ("qtplay");
+  ret->audioplayer = g_string_new ("qtplay");
   ret->csoundcommand = g_string_new ("csound -dm6");
-  ret->browser = g_string_new ("firefox");
+  ret->browser = g_string_new ("open");
   ret->csoundorcfile = g_string_new ("");
-  ret->pdfviewer = g_string_new ("xpdf");
+  ret->pdfviewer = g_string_new ("open");
   ret->sequencer = g_string_new ("/dev/sequencer");
   ret->midi_in = g_string_new ("/dev/midi");
 
 
-  ret->imageviewer = g_string_new ("eog");
-  ret->texteditor = g_string_new ("xedit");
+  ret->imageviewer = g_string_new ("open");
+  ret->texteditor = g_string_new ("smultron");
   ret->denemopath = g_string_new (g_get_home_dir());
   ret->lilyversion = g_string_new (LILYPOND_VERSION);
   ret->temperament = g_string_new("Equal");
