--- src/main.cpp.org	Thu Apr 15 17:45:59 2004
+++ src/main.cpp	Thu Apr 15 17:50:00 2004
@@ -76,9 +76,7 @@
 
 #include "helper/sp-intl.h"
 
-#ifndef HAVE_BIND_TEXTDOMAIN_CODESET
 #define bind_textdomain_codeset(p,c)
-#endif
 #ifndef HAVE_GTK_WINDOW_SET_DEFAULT_ICON_FROM_FILE
 #define gtk_window_set_default_icon_from_file(f,v)
 #endif
