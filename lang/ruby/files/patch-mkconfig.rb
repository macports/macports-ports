--- lib/mkmf.rb.orig	2008-05-29 20:23:36.000000000 +0900
+++ lib/mkmf.rb	2008-06-21 14:00:40.000000000 +0900
@@ -54,6 +54,13 @@
 $vendordir = CONFIG["vendordir"]
 $vendorlibdir = CONFIG["vendorlibdir"]
 $vendorarchdir = CONFIG["vendorarchdir"]
+# macports -rvendor-specific support
+if defined?(VENDOR_SPECIFIC) && VENDOR_SPECIFIC
+  CONFIG["sitearch"] = CONFIG["vendorarch"]
+  CONFIG["sitedir"] = CONFIG["vendordir"]
+  CONFIG["sitelibdir"] = CONFIG["vendorlibdir"]
+  CONFIG["sitearchdir"] = CONFIG["vendorarchdir"]
+end
 
 $mswin = /mswin/ =~ RUBY_PLATFORM
 $bccwin = /bccwin/ =~ RUBY_PLATFORM
