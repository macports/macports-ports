--- saslauthd/auth_pam.c.orig	Thu Feb  3 14:21:05 2005
+++ saslauthd/auth_pam.c	Thu Feb  3 14:21:18 2005
@@ -50,7 +50,7 @@
 
 # include <string.h>
 # include <syslog.h>
-# include <security/pam_appl.h>
+# include <pam/pam_appl.h>
 
 # include "auth_pam.h"
 /* END PUBLIC DEPENDENCIES */
