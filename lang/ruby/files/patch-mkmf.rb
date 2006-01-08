--- lib/mkmf.rb.orig	2005-11-27 16:22:53.000000000 -0800
+++ lib/mkmf.rb	2006-01-08 08:38:20.000000000 -0800
@@ -50,6 +50,9 @@
 $sitedir = CONFIG["sitedir"]
 $sitelibdir = CONFIG["sitelibdir"]
 $sitearchdir = CONFIG["sitearchdir"]
+$vendordir = CONFIG["vendordir"]
+$vendorlibdir = CONFIG["vendorlibdir"]
+$vendorarchdir = CONFIG["vendorarchdir"]
 
 $mswin = /mswin/ =~ RUBY_PLATFORM
 $bccwin = /bccwin/ =~ RUBY_PLATFORM
@@ -409,7 +412,7 @@
 
 def try_func(func, libs, headers = nil, &b)
   headers = cpp_include(headers)
-  try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b)
+  try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b)
 #{headers}
 /*top*/
 int main() { return 0; }
@@ -421,6 +424,11 @@
 int main() { return 0; }
 int t() { void ((*volatile p)()); p = (void ((*)()))#{func}; return 0; }
 SRC
+int #{func}();
+/*top*/
+int main() { return 0; }
+int t() { #{func}(); return 0; }
+SRC
 end
 
 def try_var(var, headers = nil, &b)
@@ -970,6 +978,7 @@
 RUBY_SO_NAME = #{CONFIG['RUBY_SO_NAME']}
 arch = #{CONFIG['arch']}
 sitearch = #{CONFIG['sitearch']}
+vendorarch = #{CONFIG['vendorarch']}
 ruby_version = #{Config::CONFIG['ruby_version']}
 ruby = #{$ruby}
 RUBY = $(ruby#{sep})
@@ -1269,7 +1278,7 @@
   $CFLAGS = with_config("cflags", arg_config("CFLAGS", config["CFLAGS"])).dup
   $ARCH_FLAG = with_config("arch_flag", arg_config("ARCH_FLAG", config["ARCH_FLAG"])).dup
   $CPPFLAGS = with_config("cppflags", arg_config("CPPFLAGS", config["CPPFLAGS"])).dup
-  $LDFLAGS = (with_config("ldflags") || "").dup
+  $LDFLAGS = with_config("ldflags", arg_config("LDFLAGS", config["LDFLAGS"])).dup
   $INCFLAGS = "-I$(topdir)"
   $DLDFLAGS = with_config("dldflags", arg_config("DLDFLAGS", config["DLDFLAGS"])).dup
   $LIBEXT = config['LIBEXT'].dup
