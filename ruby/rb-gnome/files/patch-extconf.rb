--- extconf.rb.orig	2008-10-23 07:24:04.000000000 -0600
+++ extconf.rb	2008-11-03 22:26:51.000000000 -0700
@@ -67,7 +67,7 @@
   dir = $topsrcdir
   dir = File.join(topdir, dir) unless Pathname.new(dir).absolute?
   srcdir = File.join(dir, subdir)
-  args = ruby_args + ["-C", subdir, File.join(srcdir, "extconf.rb"),
+  args = ruby_args + ["-rvendor-specific", "-C", subdir, File.join(srcdir, "extconf.rb"),
                       "--topsrcdir=#{dir}", "--topdir=#{topdir}",
                       "--srcdir=#{srcdir}", *extra_args]
   ret = system(ruby, *args)
