--- libguile/posix.c.sav	Tue Jan 25 19:01:44 2005
+++ libguile/posix.c	Tue Jan 25 19:01:55 2005
@@ -1257,6 +1257,13 @@
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
