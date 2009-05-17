Only in jdk.orig/src/solaris/javavm/include: .typedefs_md.h.swp
diff -ru jdk.orig/src/solaris/javavm/include/typedefs_md.h jdk/src/solaris/javavm/include/typedefs_md.h
--- jdk.orig/src/solaris/javavm/include/typedefs_md.h	2009-05-15 01:02:42.000000000 -0700
+++ jdk/src/solaris/javavm/include/typedefs_md.h	2009-05-15 01:06:26.000000000 -0700
@@ -62,11 +62,11 @@
 
 #ifndef HAVE_INTPTR_T
 #ifdef LONG_IS_64
-typedef long intptr_t;
-typedef unsigned long uintptr_t;
+//typedef long intptr_t;
+//typedef unsigned long uintptr_t;
 #else
-typedef int intptr_t;
-typedef unsigned int uintptr_t;
+//typedef int intptr_t;
+//typedef unsigned int uintptr_t;
 #endif  /* LONG_IS_64 */
 #endif /* don't HAVE_INTPTR_T */
 
