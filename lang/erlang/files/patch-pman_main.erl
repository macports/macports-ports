--- lib/pman/src/pman_main.erl.sav	Tue May  6 16:41:58 2003
+++ lib/pman/src/pman_main.erl	Tue May  6 16:42:25 2003
@@ -414,7 +414,7 @@
 %% Start Help window
 
 execute_cmd('Help',Pman_data,Data,Args)  ->
-    HelpFile = filename:join(code:priv_dir(pman), "../doc/index.html"),
+    HelpFile = filename:join(code:priv_dir(pman), "../doc/html/index.html"),
     tool_utils:open_help(gse:start([{kernel, true}]), HelpFile),
     Pman_data;
 
