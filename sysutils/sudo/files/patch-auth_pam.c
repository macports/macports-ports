--- auth/pam.c.orig	Tue Apr 15 18:39:15 2003
+++ auth/pam.c	Sat Jan 17 19:03:43 2004
@@ -64,7 +64,11 @@
 #endif /* HAVE_UNISTD_H */
 #include <pwd.h>
 
+#ifdef HAVE_SECURITY_PAM_APPL_H
 #include <security/pam_appl.h>
+#else
+#include <pam/pam_appl.h>
+#endif /* HAVE_SECURITY_PAM_APPL_H */
 
 #include "sudo.h"
 #include "sudo_auth.h"
