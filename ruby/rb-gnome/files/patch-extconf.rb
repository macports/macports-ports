--- extconf.rb.orig	Thu Apr 29 20:56:56 2004
+++ extconf.rb	Thu Apr 29 20:57:21 2004
@@ -44,7 +44,7 @@
   topdir = File.join(*([".."] * subdir.split(/\/+/).size))
   /^\// =~ (dir = $topsrcdir) or dir = File.join(topdir, $topsrcdir)
   srcdir = File.join(dir, subdir)
-  ret = system($ruby, "-C", subdir, File.join(srcdir, "extconf.rb"),
+  ret = system($ruby, "-rvendor-specific", "-C", subdir, File.join(srcdir, "extconf.rb"),
    "--topsrcdir=#{dir}", "--topdir=#{topdir}", "--srcdir=#{srcdir}",
    *ARGV)
   STDERR.puts("#{$0}: Leaving directory '#{subdir}'")
