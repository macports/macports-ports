--- poptint.c.varargs	2007-06-17 13:09:50.000000000 -0400
+++ poptint.c	2007-06-17 13:11:54.000000000 -0400
@@ -97,10 +97,15 @@
 {
   char *buffer = NULL;
   char c;
+  va_list apc;
+
+  va_copy(apc, ap);     /* XXX linux amd64/ppc needs a copy. */
 
   buffer = calloc (sizeof (char), vsnprintf (&c, 1, format, ap) + 1);
   vsprintf (buffer, format, ap);
 
+  va_end(apc);
+
   return buffer;
 }
 
