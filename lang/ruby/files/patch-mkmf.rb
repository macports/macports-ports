--- lib/mkmf.rb.orig	2008-05-29 13:23:36.000000000 +0200
+++ lib/mkmf.rb	2008-06-15 11:08:36.000000000 +0200
@@ -461,7 +461,7 @@
 
 def try_func(func, libs, headers = nil, &b)
   headers = cpp_include(headers)
-  try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b)
+  try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b)
 #{COMMON_HEADERS}
 #{headers}
 /*top*/
@@ -473,6 +473,11 @@
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
@@ -1307,6 +1312,7 @@
 RUBY_SO_NAME = #{CONFIG['RUBY_SO_NAME']}
 arch = #{CONFIG['arch']}
 sitearch = #{CONFIG['sitearch']}
+vendorarch = #{CONFIG['vendorarch']}
 ruby_version = #{Config::CONFIG['ruby_version']}
 ruby = #{$ruby}
 RUBY = $(ruby#{sep})
