diff -urN slirp/slirp_config.h qemu-0.6.0-2/slirp/slirp_config.h
--- slirp/slirp_config.h	Sat Jul 10 20:20:09 2004
+++ qemu-0.6.0-2/slirp/slirp_config.h	Thu Jul 15 15:06:00 2004
@@ -163,6 +163,9 @@
 
 /* Define if you have <termios.h> */
 #undef HAVE_TERMIOS_H
+#ifdef __APPLE__
+#define HAVE_TERMIOS_H
+#endif
 
 /* Define if you have gethostid */
 #undef HAVE_GETHOSTID
@@ -184,3 +187,10 @@
 
 /* Define if you have <sys/type32.h> */
 #undef HAVE_SYS_TYPES32_H
+
+#undef HAVE_SYS_FILIO_H
+#ifdef __APPLE__
+#define HAVE_SYS_FILIO_H
+#endif
+
+

