--- lib/mkmf.rb.orig	2007-02-28 22:23:42.000000000 +0900
+++ lib/mkmf.rb	2007-03-15 13:39:26.000000000 +0900
@@ -51,6 +51,9 @@
 $sitedir = CONFIG["sitedir"]
 $sitelibdir = CONFIG["sitelibdir"]
 $sitearchdir = CONFIG["sitearchdir"]
+$vendordir = CONFIG["vendordir"]
+$vendorlibdir = CONFIG["vendorlibdir"]
+$vendorarchdir = CONFIG["vendorarchdir"]
 
 $mswin = /mswin/ =~ RUBY_PLATFORM
 $bccwin = /bccwin/ =~ RUBY_PLATFORM
@@ -410,7 +413,7 @@
 
 def try_func(func, libs, headers = nil, &b)
   headers = cpp_include(headers)
-  try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b)
+  try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b)
 #{COMMON_HEADERS}
 #{headers}
 /*top*/
@@ -422,6 +425,11 @@
 int main() { return 0; }
 int t() { #{func}(); return 0; }
 SRC
+int #{func}();
+/*top*/
+int main() { return 0; }
+int t() { #{func}(); return 0; }
+SRC
 end
 
 def try_var(var, headers = nil, &b)
@@ -1087,6 +1095,7 @@
 RUBY_SO_NAME = #{CONFIG['RUBY_SO_NAME']}
 arch = #{CONFIG['arch']}
 sitearch = #{CONFIG['sitearch']}
+vendorarch = #{CONFIG['vendorarch']}
 ruby_version = #{Config::CONFIG['ruby_version']}
 ruby = #{$ruby}
 RUBY = $(ruby#{sep})
