--- lib/utils.c	Sat Apr 10 12:21:03 2004
+++ lib/utils.c	Sat Apr 10 12:23:23 2004
@@ -21,6 +21,16 @@
 #include <config.h>
 #include <dpkg.h>
 
+#ifndef HAVE_STRNLEN
+size_t strnlen(const char *s, size_t n)
+{
+	int i;
+	for (i=0; s[i] && i<n; i++)
+		/* noop */ ;
+	return i;
+}
+#endif
+
 /* Reimplementation of the standard ctype.h is* functions. Since gettext
  * has overloaded the meaning of LC_CTYPE we can't use that to force C
  * locale, so use these cis* functions instead.
