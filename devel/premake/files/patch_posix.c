--- Src/posix.c.org	Mon Jan 26 14:31:35 2004
+++ Src/posix.c	Mon Jan 26 14:32:35 2004
@@ -20,6 +20,8 @@
 
 #if defined(__linux__)
 const char* osIdent = "linux";
+#elif defined(__APPLE__)
+const char* osIdent = "apple";
 #else
 #error Unknown OS type.
 #endif
