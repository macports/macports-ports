--- authlib/authpam.c-old	Mon Apr 28 10:20:12 2003
+++ authlib/authpam.c	Mon Apr 28 10:21:15 2003
@@ -27,6 +27,10 @@
 #include	<Pam/pam_appl.h>
 #endif
 
+#if HAVE_PAM_SETCRED
+#include <pam/pam_appl.h>
+#endif
+
 static const char rcsid[]="$Id: patch-authpam.c,v 1.1 2003/07/19 20:39:47 fkr Exp $";
 
 static const char *pam_username, *pam_password, *pam_service;
