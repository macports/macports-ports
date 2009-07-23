--- src/cppcomp.h.orig	2007-07-22 04:27:40.000000000 -0700
+++ src/cppcomp.h	2009-07-22 19:43:48.000000000 -0700
@@ -235,7 +235,7 @@
 static inline void strncpy_s(char * de, size_t de_size, const char *  so, size_t count)   {
 	const size_t sourcelen = strlen(so);
 	size_t tobecopied = sourcelen < count ? sourcelen : count;
-	if ( tobecopied < de_size ) {
+	if ( tobecopied <= de_size ) {
 		while (so && *so && (tobecopied > 0) ) {
 			*de = *so; ++de; ++so; --tobecopied;
 		} // does not copy final 0
