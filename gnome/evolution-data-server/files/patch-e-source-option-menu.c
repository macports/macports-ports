--- libedataserverui/e-source-option-menu.c.org	2005-03-14 07:46:54.000000000 +0100
+++ libedataserverui/e-source-option-menu.c	2005-03-14 07:50:09.000000000 +0100
@@ -30,6 +30,8 @@
 #include "e-data-server-ui-marshal.h"
 #include "e-source-option-menu.h"
 
+#include <sys/types.h>
+
 /* We set data on each menu item specifying the corresponding ESource using this key.  */
 #define MENU_ITEM_SOURCE_DATA_ID	"ESourceOptionMenu:Source"
 
@@ -52,7 +54,7 @@
 	NUM_SIGNALS
 };
 
-static uint signals[NUM_SIGNALS] = { 0 };
+static u_int signals[NUM_SIGNALS] = { 0 };
 
 G_DEFINE_TYPE (ESourceOptionMenu, e_source_option_menu, GTK_TYPE_OPTION_MENU)
 
