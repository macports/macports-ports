--- gtksourceview/gtksourceregex.c.org	Fri Nov 28 11:23:58 2003
+++ gtksourceview/gtksourceregex.c	Fri Nov 28 11:24:18 2003
@@ -26,12 +26,7 @@
 #include <stdlib.h>
 #include <glib.h>
 
-#ifdef NATIVE_GNU_REGEX
-#include <sys/types.h>
-#include <regex.h>
-#else
-#include "gnu-regex/regex.h"
+#include <gnuregex.h>
-#endif
 
 #include "gtksourceview-i18n.h"
 #include "gtksourceregex.h"
