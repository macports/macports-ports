--- lib/appmon/src/appmon.erl.sav	Tue Aug 19 14:59:19 2003
+++ lib/appmon/src/appmon.erl	Tue Aug 19 15:00:03 2003
@@ -432,7 +432,7 @@
         %% Help menu = Help button
 	help ->
 	    HelpFile = filename:join(code:priv_dir(appmon),
-				     "../doc/index.html"),
+				     "../doc/html/index.html"),
 	    tool_utils:open_help(State#state.gs, HelpFile),
 	    {noreply, State};
 		
