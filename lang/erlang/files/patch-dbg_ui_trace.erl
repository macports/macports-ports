--- lib/debugger/src/dbg_ui_trace.erl.sav	Tue May  6 16:30:05 2003
+++ lib/debugger/src/dbg_ui_trace.erl	Tue May  6 16:31:41 2003
@@ -352,7 +352,7 @@
 
 %% Help menu
 gui_cmd('Debugger', State) ->
-    HelpFile = filename:join([code:lib_dir(debugger),"doc","index.html"]),
+    HelpFile = filename:join([code:lib_dir(debugger),"doc","html","index.html"]),
     tool_utils:open_help(State#state.gs, HelpFile),
     State;
 
