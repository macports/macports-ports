--- lib/tv/src/tv_main.erl.sav	Tue May  6 16:35:11 2003
+++ lib/tv/src/tv_main.erl	Tue May  6 16:36:07 2003
@@ -642,14 +642,14 @@
 	    
 
 	{gs, _Id, click, help_button, _Args} ->
-	    HelpFile = filename:join(code:priv_dir(tv), "../doc/index.html"),
+	    HelpFile = filename:join(code:priv_dir(tv), "../doc/html/index.html"),
 	    tool_utils:open_help(gs:start([{kernel, true}]), HelpFile),
 	    loop(KindOfTable,CurrNode,MarkedCell,GridLines,WinSize,Tables,Shortcuts,
 		 UnreadHidden,SysTabHidden,SortKey,Children);
 
 
 	{gs, _Id, click, otp_help_button, _Args} ->
-	    IndexFile = filename:join(code:root_dir(), "doc/index.html"),
+	    IndexFile = filename:join(code:root_dir(), "doc/html/index.html"),
 	    tool_utils:open_help(gs:start([{kernel, true}]), IndexFile),
 	    loop(KindOfTable,CurrNode,MarkedCell,GridLines,WinSize,Tables,Shortcuts,
 		 UnreadHidden,SysTabHidden,SortKey,Children);
@@ -1013,7 +1013,7 @@
 
 handle_keypress(help_button,KindOfTable,CurrNode,MarkedCell,GridLines,
 		WinSize,Tables,Shortcuts,UnreadHidden,SysTabHidden,SortKey,Children) ->
-    HelpFile = filename:join(code:priv_dir(tv), "../doc/index.html"),
+    HelpFile = filename:join(code:priv_dir(tv), "../doc/html/index.html"),
     tool_utils:open_help(gs:start([{kernel, true}]), HelpFile),
     loop(KindOfTable,CurrNode,MarkedCell,GridLines,WinSize,Tables,Shortcuts,
 	 UnreadHidden,SysTabHidden,SortKey,Children);
