--- src/term.h.orig	Sat Feb  7 11:32:49 2004
+++ src/term.h	Sat Feb  7 11:32:59 2004
@@ -141,7 +141,7 @@
 
 /* Apple MacOs X Server (Openstep Unix) */
 #if defined(__APPLE__) && defined(__MACH__)
-# include "openstep.trm"
+# include "aquaTerm.trm"
 #endif 
 
 /* OS/2 */
