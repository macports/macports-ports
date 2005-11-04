--- src/help.cpp.orig	2005-11-02 17:44:38.000000000 -0500
+++ src/help.cpp	2005-11-02 17:45:15.000000000 -0500
@@ -46,14 +46,14 @@
 void
 browse_manual (GtkAction * action, gpointer data)
 {
-  gchar *browser = "sensible-browser"; 
+  gchar *browser = "dillo"; 
   gint retval;
  // struct scoreinfo *si; 
   GError *error = NULL;
   gchar **argv;
   gchar *cmd;
   gchar *data_dir = gbr_find_data_dir (PKGDATADIR);	
-  gchar *path = g_strdup_printf("%s/denemo/manual/manualout.html", data_dir);
+  gchar *path = g_strdup_printf("file://%s/manual/manualout.html", data_dir);
   gchar *argument = g_shell_quote(path); 
  
   
