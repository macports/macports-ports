--- ../ruby-1.8.1.orig/ruby.c	Thu Dec 18 00:08:50 2003
+++ ruby.c	Thu Apr  1 15:31:57 2004
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
