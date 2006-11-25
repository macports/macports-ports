--- plugins.c.orig	2005-05-08 11:57:31.000000000 -0400
+++ plugins.c	2006-11-20 09:30:28.000000000 -0500
@@ -22,6 +22,7 @@
 
 #include "config.h"
 #ifdef  ENABLE_PLUGINS
+#include <sys/types.h>
 #include <dirent.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -81,6 +82,8 @@
    struct dirent *dirent;
    char full_name[FILENAME_MAX];
    struct plugin_s temp_plugin, *new_plugin;
+   GList *plugin_names = NULL; /* keep a list of plugins found so far */
+   GList *temp_list = NULL;
 
    count = 0;
    for (i=0; (dirent = readdir(dir)); i++) {
@@ -90,7 +93,8 @@
       }
       /* If the filename has either of these extensions then plug it in */
       if ((strcmp(&(dirent->d_name[strlen(dirent->d_name)-3]), ".so")) &&
-	  (strcmp(&(dirent->d_name[strlen(dirent->d_name)-3]), ".sl"))) {
+	  (strcmp(&(dirent->d_name[strlen(dirent->d_name)-3]), ".sl")) &&
+	  (strcmp(&(dirent->d_name[strlen(dirent->d_name)-6]), ".dylib"))) {
 	 continue;
       } else {
 	 jp_logf(JP_LOG_DEBUG, "found plugin %s\n", dirent->d_name);
@@ -103,6 +107,7 @@
 	    if (temp_plugin.name) {
 	       jp_logf(JP_LOG_DEBUG, "plugin name is [%s]\n", temp_plugin.name);
 	    }
+	    if (g_list_find_custom(plugin_names, temp_plugin.name, (GCompareFunc)strcmp) == NULL) {
 	    new_plugin = malloc(sizeof(struct plugin_s));
 	    if (!new_plugin) {
 	       jp_logf(JP_LOG_WARN, "load plugins(): %s\n", _("Out of memory"));
@@ -113,13 +118,21 @@
 	     * we want to avoid that slowness, prepend works for that
 	     * in this case since we have the head */
 	    plugins = g_list_prepend(plugins, new_plugin);
+	    plugin_names = g_list_prepend(plugin_names, g_strdup(temp_plugin.name));
 	    count++;
 	    (*number)++;
 	 }
       }
+      } 
    }
 
    plugins = g_list_sort(plugins, plugin_sort);
+   for (temp_list = plugin_names; temp_list; temp_list = temp_list->next) {
+      if (temp_list->data) {
+	g_free(temp_list->data);
+      }
+    }
+   g_list_free(plugin_names);
 
    return count;
 }
