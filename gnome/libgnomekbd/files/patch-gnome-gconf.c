--- libgnome/gnome-gconf.c.org	2005-06-12 21:40:22.000000000 +0200
+++ libgnome/gnome-gconf.c	2005-06-12 21:49:56.000000000 +0200
@@ -30,7 +30,6 @@
 #define GCONF_ENABLE_INTERNALS
 #include <gconf/gconf.h>
 #include <gconf/gconf-client.h>
-extern struct poptOption gconf_options[];
 
 #include "gnome-i18nP.h"
 
@@ -39,6 +38,8 @@
 #include "gnome-gconf.h"
 #include "gnome-gconfP.h"
 
+extern struct poptOption gconf_options[];
+
 /**
  * gnome_gconf_get_gnome_libs_settings_relative:
  * @subkey: key part below the gnome desktop settings directory
