--- ../ruby-1.8.2.orig/ruby.c	Fri Jul 23 00:52:38 2004
+++ ruby.c	Tue Dec 28 21:52:47 2004
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
