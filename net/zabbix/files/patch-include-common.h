--- include/common.h.orig	2008-11-04 13:44:59.000000000 -0800
+++ include/common.h	2008-11-11 16:25:09.000000000 -0800
@@ -21,6 +21,7 @@
 #define ZABBIX_COMMON_H
 
 #include "sysinc.h"
+#undef HAVE_FUNCTION_SYSCTLBYNAME
 
 #include "zbxtypes.h"
 
