--- lib/tv/src/tv_pc_menu_handling.erl.sav	Tue May  6 16:35:27 2003
+++ lib/tv/src/tv_pc_menu_handling.erl	Tue May  6 16:36:27 2003
@@ -138,7 +138,7 @@
 
 
 help_button(ProcVars) ->
-    HelpFile = filename:join(code:priv_dir(tv), "../doc/index.html"),
+    HelpFile = filename:join(code:priv_dir(tv), "../doc/html/index.html"),
     tool_utils:open_help(gs:start([{kernel, true}]), HelpFile),
     ProcVars.
 
@@ -146,7 +146,7 @@
 
 
 otp_help_button(ProcVars) ->
-    IndexFile = filename:join(code:root_dir(), "doc/index.html"),
+    IndexFile = filename:join(code:root_dir(), "doc/html/index.html"),
     tool_utils:open_help(gs:start([{kernel, true}]), IndexFile),
     ProcVars.
 
