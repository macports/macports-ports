--- ruby.c.orig	2005-12-11 16:36:52.000000000 -0800
+++ ruby.c	2006-02-02 12:38:41.000000000 -0800
@@ -298,6 +298,13 @@
     ruby_incpush(RUBY_RELATIVE(RUBY_SITE_ARCHLIB));
     ruby_incpush(RUBY_RELATIVE(RUBY_SITE_LIB));
 
+    ruby_incpush(RUBY_RELATIVE(RUBY_VENDOR_LIB2));
+#ifdef RUBY_VENDOR_THIN_ARCHLIB
+    ruby_incpush(RUBY_RELATIVE(RUBY_VENDOR_THIN_ARCHLIB));
+#endif
+    ruby_incpush(RUBY_RELATIVE(RUBY_VENDOR_ARCHLIB));
+    ruby_incpush(RUBY_RELATIVE(RUBY_VENDOR_LIB));
+
     ruby_incpush(RUBY_RELATIVE(RUBY_LIB));
 #ifdef RUBY_THIN_ARCHLIB
     ruby_incpush(RUBY_RELATIVE(RUBY_THIN_ARCHLIB));
@@ -1033,43 +1033,47 @@
     rb_progname = rb_tainted_str_new(s, i);
 #else
     if (len == 0) {
-	char *s = origargv[0];
-	int i;
+	char *s1 = origargv[0];
+	int j;
 
-	s += strlen(s);
+	s1 += strlen(s1);
 	/* See if all the arguments are contiguous in memory */
-	for (i = 1; i < origargc; i++) {
-	    if (origargv[i] == s + 1) {
-		s++;
-		s += strlen(s);	/* this one is ok too */
+	for (j = 1; j < origargc; j++) {
+	    if (origargv[j] == s1 + 1) {
+		s1++;
+		s1 += strlen(s1);	/* this one is ok too */
 	    }
 	    else {
 		break;
 	    }
 	}
 #ifndef DOSISH
-	if (s + 1 == envspace.begin) {
-	    s = envspace.end;
+	if (s1 + 1 == envspace.begin) {
+	    s1 = envspace.end;
 	    ruby_setenv("", NULL); /* duplicate environ vars */
 	}
 #endif
-	len = s - origargv[0];
+	len = s1 - origargv[0];
     }
 
     if (i >= len) {
 	i = len;
-	memcpy(origargv[0], s, i);
-	origargv[0][i] = '\0';
     }
-    else {
-	memcpy(origargv[0], s, i);
-	s = origargv[0]+i;
-	*s++ = '\0';
-	while (++i < len)
-	    *s++ = ' ';
-	for (i = 1; i < origargc; i++)
-	    origargv[i] = 0;
+    memcpy(origargv[0], s, i);
+    memset(origargv[0] + i, '\0', len - i + 1);
+
+    /* If the new program name is longer than the original one, then
+     * have any command line arguments that were written over be
+     * empty strings. */
+    s = origargv[0] + i;
+    for (i = 1; i < origargc; ++i) {
+	if (origargv[i] < s ) {
+	    origargv[i] = s;
+	} else {
+	    break;
+	}
     }
+
     rb_progname = rb_tainted_str_new2(origargv[0]);
 #endif
 }
