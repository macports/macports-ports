--- src/term.h	Wed Dec  4 19:35:27 2002
+++ src/term.h.mod	Wed Dec  4 19:35:41 2002
@@ -138,9 +138,9 @@
 #endif
 
 /* Apple MacOs X Server (Openstep Unix) */
-#if defined(__APPLE__) && defined(__MACH__)
+/*#if defined(__APPLE__) && defined(__MACH__)
 # include "openstep.trm"
-#endif 
+#endif */
 
 /* OS/2 */
 #ifdef OS2
