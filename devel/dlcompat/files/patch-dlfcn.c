--- dlfcn.c.orig	2005-06-08 17:01:15.000000000 -0400
+++ dlfcn.c	2005-06-08 17:01:34.000000000 -0400
@@ -157,7 +157,7 @@
 static NSSymbol *search_linked_libs(const struct mach_header *mh, const char *symbol);
 static const char *get_lib_name(const struct mach_header *mh);
 static const struct mach_header *get_mach_header_from_NSModule(NSModule * mod);
-static void dlcompat_init_func(void);
+static void dlcompat_init_func(void) __attribute__ ((constructor));
 static inline void dolock(void);
 static inline void dounlock(void);
 static void dlerrorfree(void *data);
@@ -816,8 +816,6 @@
 	}
 }
 
-#pragma CALL_ON_LOAD dlcompat_init_func
-
 static void dlcompat_cleanup(void)
 {
 	struct dlstatus *dls;
