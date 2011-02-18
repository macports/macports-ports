--- src/cppcomp.h.orig	2009-06-21 10:10:39.000000000 -0500
+++ src/cppcomp.h	2011-02-17 17:11:47.000000000 -0600
@@ -244,7 +244,7 @@
 static inline void strncpy_s(char * de, size_t de_size, const char *  so, size_t count)   {
 	const size_t sourcelen = strlen(so);
 	size_t tobecopied = sourcelen < count ? sourcelen : count;
-	if ( tobecopied < de_size ) {
+	if ( tobecopied <= de_size ) {
 		while (so && *so && (tobecopied > 0) ) {
 			*de = *so; ++de; ++so; --tobecopied;
 		} // does not copy final 0
