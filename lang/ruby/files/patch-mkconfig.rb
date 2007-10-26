--- mkconfig.rb.orig	2005-11-10 15:22:03.000000000 -0800
+++ mkconfig.rb	2006-01-08 08:36:13.000000000 -0800
@@ -143,6 +143,14 @@
   CONFIG["archdir"] = "$(rubylibdir)/$(arch)"
   CONFIG["sitelibdir"] = "$(sitedir)/$(ruby_version)"
   CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
+  CONFIG["vendorlibdir"] = "$(vendordir)/$(ruby_version)"
+  CONFIG["vendorarchdir"] = "$(vendorlibdir)/$(vendorarch)"
+  if defined?(VENDOR_SPECIFIC) && VENDOR_SPECIFIC
+ 	CONFIG["sitearch"] = CONFIG["vendorarch"]
+ 	CONFIG["sitedir"] = CONFIG["vendordir"]
+ 	CONFIG["sitelibdir"] = CONFIG["vendorlibdir"]
+ 	CONFIG["sitearchdir"] = CONFIG["vendorarchdir"]
+  end
   CONFIG["topdir"] = File.dirname(__FILE__)
   MAKEFILE_CONFIG = {}
   CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}
