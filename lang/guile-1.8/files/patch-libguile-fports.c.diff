--- libguile/fports.c~	2007-05-09 16:22:03.000000000 -0400
+++ libguile/fports.c	2007-12-17 20:09:21.000000000 -0500
@@ -674,7 +674,7 @@
 static off_t
 fport_seek (SCM port, off_t offset, int whence)
 {
-  off64_t rv = fport_seek_or_seek64 (port, (off64_t) offset, whence);
+  off_t_or_off64_t rv = fport_seek_or_seek64 (port, (off_t_or_off64_t) offset, whence);
   if (rv > OFF_T_MAX || rv < OFF_T_MIN)
     {
       errno = EOVERFLOW;
