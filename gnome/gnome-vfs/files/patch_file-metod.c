--- modules/file-method.c.org	Sun Nov 23 16:51:15 2003
+++ modules/file-method.c	Sun Nov 23 16:51:53 2003
@@ -91,19 +91,10 @@
 }
 #endif
 
-#ifdef HAVE_OPEN64
-#define OPEN open64
-#else
 #define OPEN open
-#endif
-
-#if defined(HAVE_LSEEK64) && defined(HAVE_OFF64_T)
 #define LSEEK lseek64
-#define OFF_T off64_t
-#else
 #define LSEEK lseek
 #define OFF_T off_t
-#endif
 
 static gchar *
 get_path_from_uri (GnomeVFSURI const *uri)
