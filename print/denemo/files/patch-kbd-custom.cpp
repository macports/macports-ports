--- src/kbd-custom.cpp.orig	2005-11-03 21:21:10.000000000 -0500
+++ src/kbd-custom.cpp	2005-11-03 21:22:18.000000000 -0500
@@ -510,7 +510,7 @@
 load_standard_keymap_file (struct keymap *the_keymap)
 {  
   gchar *sysdir = gbr_find_data_dir (SYSCONFDIR);
-  gchar *systemwide = g_strdup_printf("%s/denemo/denemo.keymaprc",sysdir);
+  gchar *systemwide = g_strdup_printf("%s/denemo.keymaprc",sysdir);
   g_print("systemwide = %s\n", systemwide);
   static gchar *localrc = NULL;
 
