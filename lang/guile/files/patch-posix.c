--- libguile/posix.c.sav	Fri Feb 21 17:09:20 2003
+++ libguile/posix.c	Fri Feb 21 17:10:33 2003
@@ -1213,6 +1213,13 @@
     SCM_MEMORY_ERROR;
   strncpy (ptr, SCM_STRING_CHARS (str), SCM_STRING_LENGTH (str));
   ptr[SCM_STRING_LENGTH (str)] = 0;
+#if defined(macosx)
+  if (!strchr(ptr, '=')) {
+    unsetenv(ptr);
+    rv = 0;
+  }
+  else
+#endif
   rv = putenv (ptr);
   if (rv < 0)
     SCM_SYSERROR;
