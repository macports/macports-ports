--- freeradius-0.8.1.old/src/include/sysutmp.h	Thu Mar  6 02:24:40 2003
+++ freeradius-0.8.1/src/include/sysutmp.h	Thu Mar  6 02:26:01 2003
@@ -4,6 +4,8 @@
  * Version:	$Id: patch-sysutmp.h,v 1.1 2003/03/06 01:43:35 fkr Exp $
  */
 
+#undef HAVE_UTMP_H
+
 #ifndef SYSUTMP_H_INCLUDED
 #define SYSUTMP_H_INCLUDED
 
