--- lib/mkmf.rb.orig	Fri Jan 21 10:59:57 2005
+++ lib/mkmf.rb	Fri Jan 21 11:00:57 2005
@@ -47,6 +47,9 @@
 $sitedir = CONFIG["sitedir"]
 $sitelibdir = CONFIG["sitelibdir"]
 $sitearchdir = CONFIG["sitearchdir"]
+$vendordir = CONFIG["vendordir"]
+$vendorlibdir = CONFIG["vendorlibdir"]
+$vendorarchdir = CONFIG["vendorarchdir"]
 
 $mswin = /mswin/ =~ RUBY_PLATFORM
 $bccwin = /bccwin/ =~ RUBY_PLATFORM
@@ -751,6 +754,7 @@
 RUBY_SO_NAME = #{CONFIG['RUBY_SO_NAME']}
 arch = #{CONFIG['arch']}
 sitearch = #{CONFIG['sitearch']}
+vendorarch = #{CONFIG['vendorarch']}
 ruby_version = #{Config::CONFIG['ruby_version']}
 ruby = #{$ruby}
 RUBY = #{($nmake && !$extmk && !$configure_args.has_key?('--ruby')) ? '$(ruby:/=\)' : '$(ruby)'}
@@ -962,7 +966,7 @@
   $CFLAGS = with_config("cflags", arg_config("CFLAGS", config["CFLAGS"])).dup
   $ARCH_FLAG = with_config("arch_flag", arg_config("ARCH_FLAG", config["ARCH_FLAG"])).dup
   $CPPFLAGS = with_config("cppflags", arg_config("CPPFLAGS", config["CPPFLAGS"])).dup
-  $LDFLAGS = (with_config("ldflags") || "").dup
+  $LDFLAGS = with_config("ldflags", arg_config("LDFLAGS", config["LDFLAGS"])).dup
   $INCFLAGS = "-I$(topdir)"
   $DLDFLAGS = with_config("dldflags", arg_config("DLDFLAGS", config["DLDFLAGS"])).dup
   $LIBEXT = config['LIBEXT'].dup
