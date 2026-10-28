--- auth_pam.c.orig	2003-09-27 09:33:57.000000000 -0600
+++ auth_pam.c	2005-10-17 17:17:20.000000000 -0600
@@ -24,7 +24,7 @@
 #include <syslog.h>
 #include <unistd.h>
 
-#include <security/pam_appl.h>
+#include <pam/pam_appl.h>
 
 #include "auth_pam.h"
 #include "authswitch.h"
