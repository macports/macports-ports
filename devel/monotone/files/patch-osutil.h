--- netxx/osutil.h.orig	2005-04-06 21:34:59.000000000 -0700
+++ netxx/osutil.h	2005-04-06 21:35:43.000000000 -0700
@@ -82,7 +82,7 @@
     error_type get_last_error (void);
 
 
-#if defined(WIN32) || defined(__APPLE__) || defined (__CYGWIN__)
+#if defined(WIN32) || defined (__CYGWIN__)
     typedef int  os_socklen_type;
     typedef int* os_socklen_ptr_type;
 #   define get_socklen_ptr(x) reinterpret_cast<int*>(&x)
