Index: perl/RPM_Files.xs
===================================================================
RCS file: /v/rpm/cvs/rpm/perl/RPM_Files.xs,v
retrieving revision 1.4
diff -u -r1.4 RPM_Files.xs
--- perl/RPM_Files.xs	14 Aug 2007 00:28:27 -0000	1.4
+++ perl/RPM_Files.xs	21 Aug 2007 13:05:56 -0000
@@ -6,7 +6,7 @@
 #undef Mkdir
 #undef Stat
 
-#if 0
+#if 1
 #include "../config.h"
 #ifdef HAVE_BEECRYPT_API_H
 #include <beecrypt/api.h>
