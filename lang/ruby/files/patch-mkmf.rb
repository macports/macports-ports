--- lib/mkmf.rb.orig	2006-08-16 22:47:50.000000000 -0700
+++ lib/mkmf.rb	2006-09-20 16:54:17.000000000 -0700
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
 #{headers}
 /*top*/
 int main() { return 0; }
@@ -422,6 +425,11 @@
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
@@ -1080,6 +1088,7 @@
 RUBY_SO_NAME = #{CONFIG['RUBY_SO_NAME']}
 arch = #{CONFIG['arch']}
 sitearch = #{CONFIG['sitearch']}
+vendorarch = #{CONFIG['vendorarch']}
 ruby_version = #{Config::CONFIG['ruby_version']}
 ruby = #{$ruby}
 RUBY = $(ruby#{sep})
@@ -1400,7 +1409,7 @@
   $CFLAGS = with_config("cflags", arg_config("CFLAGS", config["CFLAGS"])).dup
   $ARCH_FLAG = with_config("arch_flag", arg_config("ARCH_FLAG", config["ARCH_FLAG"])).dup
   $CPPFLAGS = with_config("cppflags", arg_config("CPPFLAGS", config["CPPFLAGS"])).dup
-  $LDFLAGS = (with_config("ldflags") || "").dup
+  $LDFLAGS = with_config("ldflags", arg_config("LDFLAGS", config["LDFLAGS"])).dup
   $INCFLAGS = "-I$(topdir) -I$(hdrdir) -I$(srcdir)"
   $DLDFLAGS = with_config("dldflags", arg_config("DLDFLAGS", config["DLDFLAGS"])).dup
   $LIBEXT = config['LIBEXT'].dup
