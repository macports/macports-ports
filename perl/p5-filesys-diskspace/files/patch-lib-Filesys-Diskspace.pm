--- /lib/Filesys/DiskSpace.pm.org       1999-09-05 22:41:22.000000000 +0000
+++ lib/Filesys/DiskSpace.pm    2005-08-03 01:38:45.000000000 +0000
@@ -89,10 +89,9 @@
     $res = syscall (&main::SYS_statfs, $dir, $fmt);
     # statfs...

-    if ($^O eq 'freebsd') {
+    if ($^O eq 'freebsd' || $^O eq 'darwin') {
       # only tested with FreeBSD 3.0. Should also work with 4.0.
-      my ($f1, $f2);
-      ($f1, $bsize, $f2, $blocks, $bfree, $bavail, $files, $ffree) =
+      (undef, $bsize, undef, $blocks, $bfree, $bavail, $files, $ffree) =
 	unpack "L8", $fmt;
       $type = 0; # read it from 'f_type' field ?
     }
