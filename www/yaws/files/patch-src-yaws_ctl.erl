--- src/yaws_ctl.erl.orig	Sun Feb  8 12:01:14 2004
+++ src/yaws_ctl.erl	Sun Feb  8 12:01:17 2004
@@ -18,7 +18,7 @@
 -include("yaws_debug.hrl").
 
 ctl_file("0") ->
-    "/var/run/yaws.ctl";
+    "__PREFIX/var/run/yaws.ctl";
 ctl_file(Id) ->
     Tmp = yaws:tmp_dir_fstr(),
     io_lib:format(Tmp ++ "/yaws.ctl.~s",[Id]).
