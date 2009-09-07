--- src/prefops.c.orig	2009-09-07 09:00:16.000000000 -0300
+++ src/prefops.c	2009-09-07 09:05:42.000000000 -0300
@@ -88,13 +88,13 @@
   ret->texteditor = g_string_new ("wordpad");
   ret->midiplayer = g_string_new("wmplayer");
 #else /* !G_OS_WIN32 */
-  ret->browser = g_string_new ("firefox");
-  ret->midiplayer = g_string_new ("playmidi");
-  ret->audioplayer = g_string_new ("play");
+  ret->browser = g_string_new ("open");
+  ret->midiplayer = g_string_new ("qtplay");
+  ret->audioplayer = g_string_new ("qtplay");
   ret->lilypath = g_string_new ("lilypond");
-  ret->pdfviewer = g_string_new ("xpdf");
-  ret->imageviewer = g_string_new ("eog");
-  ret->texteditor = g_string_new ("xedit");
+  ret->pdfviewer = g_string_new ("open");
+  ret->imageviewer = g_string_new ("open");
+  ret->texteditor = g_string_new ("smultron");
 #endif /* !G_OS_WIN32 */
   ret->sequencer = g_string_new ("/dev/sequencer");
   ret->midi_in = g_string_new ("/dev/midi");
