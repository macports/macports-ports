--- lib/pman/src/pman_shell.erl.sav	Tue May  6 16:42:06 2003
+++ lib/pman/src/pman_shell.erl	Tue May  6 16:42:36 2003
@@ -497,7 +497,7 @@
 	    end,
 	    Shell_data;
 	'Help' ->
-	    HelpFile = filename:join(code:priv_dir(pman), "../doc/index.html"),
+	    HelpFile = filename:join(code:priv_dir(pman), "../doc/html/index.html"),
 	    tool_utils:open_help(gs:start([{kernel, true}]), HelpFile),
 	    Shell_data;
 	'Kill'when pid(Shell)  ->		
