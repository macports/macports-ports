--- src/conf.c.orig	2006-07-26 00:04:39.000000000 +0900
+++ src/conf.c	2006-07-26 00:06:07.000000000 +0900
@@ -26,6 +26,13 @@
 #include "utils.h"
 #include "cmds.h"
 
+char* strndup(const char* ptr, size_t n)
+{
+	char* result = (char*) malloc(n);
+	strncpy(result, ptr, n-1);
+	result[n] = 0;
+	return result;
+}
 
 char * get_next_char(char ch, char *ptr)
 {
