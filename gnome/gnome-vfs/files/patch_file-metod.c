--- modules/file-method.c.org	Thu Jul 24 17:43:19 2003
+++ modules/file-method.c	Thu Jul 24 18:27:53 2003
@@ -99,7 +99,7 @@
 
 #ifdef HAVE_LSEEK64
 #define LSEEK lseek64
-#define OFF_T off64_t
+#define OFF_T off_t
 #else
 #define LSEEK lseek
 #define OFF_T off_t
