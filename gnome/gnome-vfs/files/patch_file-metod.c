--- modules/file-method.c.org	Tue Sep 16 18:07:20 2003
+++ modules/file-method.c	Tue Sep 16 18:08:26 2003
@@ -91,19 +91,9 @@
 }
 #endif
 
-#ifdef HAVE_OPEN64
-#define OPEN open64
-#else
 #define OPEN open
-#endif
-
-#ifdef HAVE_LSEEK64
-#define LSEEK lseek64
-#define OFF_T off64_t
-#else
 #define LSEEK lseek
 #define OFF_T off_t
-#endif
 
 static gchar *
 get_path_from_uri (GnomeVFSURI const *uri)
