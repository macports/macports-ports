--- lib/toolbar/src/toolbar_lib.erl.sav	Tue May  6 16:39:17 2003
+++ lib/toolbar/src/toolbar_lib.erl	Tue May  6 16:40:07 2003
@@ -50,14 +50,14 @@
 % Returns the address to the toolbar help file
 %----------------------------------------
 help_file() ->
-    filename:join(code:lib_dir(toolbar),"doc/index.html").
+    filename:join(code:lib_dir(toolbar),"doc/html/index.html").
 
 %----------------------------------------
 % otp_file() => string()
 % Returns the address to the OTP documentation
 %----------------------------------------
 otp_file() ->
-    filename:join(code:root_dir(),"doc/index.html").
+    filename:join(code:root_dir(),"doc/html/index.html").
 
 %----------------------------------------
 % error_string(Reason) => string()
