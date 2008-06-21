--- mkconfig.rb.orig	2008-06-21 17:22:11.000000000 +0900
+++ mkconfig.rb	2008-06-21 17:23:00.000000000 +0900
@@ -147,6 +147,13 @@
   CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
   CONFIG["vendorlibdir"] = "$(vendordir)/$(ruby_version)"
   CONFIG["vendorarchdir"] = "$(vendorlibdir)/$(sitearch)"
+  # macports -rvendor-specific support
+  if defined?(VENDOR_SPECIFIC) && VENDOR_SPECIFIC
+    CONFIG["sitearch"] = CONFIG["vendorarch"]
+    CONFIG["sitedir"] = CONFIG["vendordir"]
+    CONFIG["sitelibdir"] = CONFIG["vendorlibdir"]
+    CONFIG["sitearchdir"] = CONFIG["vendorarchdir"]
+  end
   CONFIG["topdir"] = File.dirname(__FILE__)
   MAKEFILE_CONFIG = {}
   CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}
