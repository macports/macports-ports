--- support/stdio.c.orig	2006-08-27 19:53:55.000000000 -0700
+++ support/stdio.c	2006-08-27 19:53:58.000000000 -0700
@@ -25,7 +25,11 @@
 gint32
 Mono_Posix_Syscall_L_cuserid (void)
 {
+#ifdef L_cuserid
 	return L_cuserid;
+#else
+	return 128;
+#endif
 }
 #endif /* ndef PLATFORM_WIN32 */
 
