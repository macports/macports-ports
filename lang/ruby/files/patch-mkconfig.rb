--- ../ruby-1.8.2.orig/mkconfig.rb	Tue Aug  5 02:27:20 2003
+++ mkconfig.rb	Tue Dec 28 21:52:28 2004
@@ -111,6 +111,14 @@
   CONFIG["archdir"] = "$(rubylibdir)/$(arch)"
   CONFIG["sitelibdir"] = "$(sitedir)/$(ruby_version)"
   CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
+  CONFIG["vendorlibdir"] = "$(vendordir)/$(ruby_version)"
+  CONFIG["vendorarchdir"] = "$(vendorlibdir)/$(vendorarch)"
+  if defined?(VENDOR_SPECIFIC) && VENDOR_SPECIFIC
+	CONFIG["sitearch"] = CONFIG["vendorarch"]
+	CONFIG["sitedir"] = CONFIG["vendordir"]
+	CONFIG["sitelibdir"] = CONFIG["vendorlibdir"]
+	CONFIG["sitearchdir"] = CONFIG["vendorarchdir"]
+  end
   CONFIG["compile_dir"] = "#{Dir.pwd}"
   MAKEFILE_CONFIG = {}
   CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}
