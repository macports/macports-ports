--- lib/mkmf.rb.orig	2005-08-14 17:03:02.000000000 +0900
+++ lib/mkmf.rb	2005-08-14 17:03:36.000000000 +0900
@@ -47,6 +47,9 @@
 $sitedir = CONFIG["sitedir"]
 $sitelibdir = CONFIG["sitelibdir"]
 $sitearchdir = CONFIG["sitearchdir"]
+$vendordir = CONFIG["vendordir"]
+$vendorlibdir = CONFIG["vendorlibdir"]
+$vendorarchdir = CONFIG["vendorarchdir"]
 
 $mswin = /mswin/ =~ RUBY_PLATFORM
 $bccwin = /bccwin/ =~ RUBY_PLATFORM
@@ -347,7 +350,7 @@
 
 def try_func(func, libs, headers = nil, &b)
   headers = cpp_include(headers)
-  try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b)
+  try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b) or try_link(<<"SRC", libs, &b)
 #{headers}
 /*top*/
 int main() { return 0; }
@@ -359,6 +362,11 @@
 int main() { return 0; }
 int t() { void ((*volatile p)()); p = (void ((*)()))#{func}; return 0; }
 SRC
+int #{func}();
+/*top*/
+int main() { return 0; }
+int t() { #{func}(); return 0; }
+SRC
 end
 
 def egrep_cpp(pat, src, opt = "", &b)
@@ -751,6 +759,7 @@
 RUBY_SO_NAME = #{CONFIG['RUBY_SO_NAME']}
 arch = #{CONFIG['arch']}
 sitearch = #{CONFIG['sitearch']}
+vendorarch = #{CONFIG['vendorarch']}
 ruby_version = #{Config::CONFIG['ruby_version']}
 ruby = #{$ruby}
 RUBY = #{($nmake && !$extmk && !$configure_args.has_key?('--ruby')) ? '$(ruby:/=\)' : '$(ruby)'}
@@ -962,7 +971,7 @@
   $CFLAGS = with_config("cflags", arg_config("CFLAGS", config["CFLAGS"])).dup
   $ARCH_FLAG = with_config("arch_flag", arg_config("ARCH_FLAG", config["ARCH_FLAG"])).dup
   $CPPFLAGS = with_config("cppflags", arg_config("CPPFLAGS", config["CPPFLAGS"])).dup
-  $LDFLAGS = (with_config("ldflags") || "").dup
+  $LDFLAGS = with_config("ldflags", arg_config("LDFLAGS", config["LDFLAGS"])).dup
   $INCFLAGS = "-I$(topdir)"
   $DLDFLAGS = with_config("dldflags", arg_config("DLDFLAGS", config["DLDFLAGS"])).dup
   $LIBEXT = config['LIBEXT'].dup
