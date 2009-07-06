--- include/cspublic.h	2007-06-25 21:48:20.000000000 +1200
+++ include/cspublic.h	2009-07-06 10:49:56.000000000 +1200
@@ -34,7 +34,7 @@
 #define TDS_STATIC_CAST(type, a) ((type)(a))
 #endif
 
-static const char rcsid_cspublic_h[] = "$Id: cspublic.h,v 1.58 2007/06/25 09:48:20 freddy77 Exp $";
+static const char rcsid_cspublic_h[] = "$Id: cspublic.h,v 1.58.2.2 2008/09/08 17:48:50 jklowden Exp $";
 static const void *const no_unused_cspublic_h_warn[] = { rcsid_cspublic_h, no_unused_cspublic_h_warn };
 
 #define CS_PUBLIC
@@ -446,7 +446,10 @@
 #define CS_VERSION_150	15000
 
 #define BLK_VERSION_100 CS_VERSION_100
-#define BLK_VERSION_110 CS_VERSION_100
+#define BLK_VERSION_110 CS_VERSION_110
+#define BLK_VERSION_120 CS_VERSION_120
+#define BLK_VERSION_125 CS_VERSION_125
+#define BLK_VERSION_150 CS_VERSION_150
 
 #define CS_FORCE_EXIT	300
 #define CS_FORCE_CLOSE  301
