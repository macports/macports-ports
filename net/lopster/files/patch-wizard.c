--- src/wizard.c	Sat Jul  3 08:19:21 2004
+++ src/wizard.c	Thu Oct  7 05:08:39 2004
@@ -978,7 +978,7 @@
   ww.page3_entry[0] = entry;
 #ifdef HAVE_OGG
 # ifdef HAVE_FLAC
-  gtk_entry_set_text (GTK_ENTRY (entry), "mp3 ogg flac");
+  gtk_entry_set_text (GTK_ENTRY (entry), "mp3 ogg flac m4a wma");
 # else
   gtk_entry_set_text (GTK_ENTRY (entry), "mp3 ogg");
 # endif // HAVE_FLAC
@@ -996,7 +996,7 @@
                     (GtkAttachOptions) (GTK_EXPAND | GTK_FILL),
                     (GtkAttachOptions) (0), 0, 0);
   ww.page3_entry[1] = entry;
-  gtk_entry_set_text(GTK_ENTRY(entry), "\"mpg mpeg\" avi asf mov wmf \"rm ram\"");
+  gtk_entry_set_text(GTK_ENTRY(entry), "\"mpg mpeg\" avi asf mov wmf wmv \"rm ram\"");
 
   entry = gtk_entry_new ();
   gtk_widget_show (entry);
@@ -1006,7 +1006,7 @@
   ww.page3_entry[2] = entry;
 #ifdef HAVE_OGG
 # ifdef HAVE_FLAC
-  gtk_entry_set_text(GTK_ENTRY(entry), "wav au");
+  gtk_entry_set_text(GTK_ENTRY(entry), "wav au aiff");
 # else
   gtk_entry_set_text(GTK_ENTRY(entry), "wav au flac");
 # endif
@@ -1024,7 +1024,7 @@
                     (GtkAttachOptions) (GTK_EXPAND | GTK_FILL),
                     (GtkAttachOptions) (0), 0, 0);
   ww.page3_entry[3] = entry;
-  gtk_entry_set_text(GTK_ENTRY(entry), "tgz tar gz exe bz2 zip rpm dep dll");
+  gtk_entry_set_text(GTK_ENTRY(entry), "tgz tar gz exe bz2 zip rpm deb dll hqx sit sitx dmg img toast");
 
   entry = gtk_entry_new ();
   gtk_widget_show (entry);
