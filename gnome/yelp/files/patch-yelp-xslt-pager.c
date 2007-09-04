--- /Users/mta/macports/dports/gnome/yelp/save/yelp-xslt-pager.c	2007-08-23 11:43:19.000000000 -0400
+++ src/yelp-xslt-pager.c	2007-08-23 11:45:13.000000000 -0400
@@ -35,6 +35,7 @@
 #include <libxslt/extensions.h>
 #include <libxslt/xsltInternals.h>
 #include <libxslt/xsltutils.h>
+#include <libexslt/exslt.h>
 
 #include "yelp-error.h"
 #include "yelp-settings.h"
@@ -98,6 +99,8 @@
 	type = g_type_register_static (YELP_TYPE_PAGER,
 				       "YelpXsltPager", 
 				       &info, 0);
+	
+	exsltRegisterAll();
     }
     return type;
 }
