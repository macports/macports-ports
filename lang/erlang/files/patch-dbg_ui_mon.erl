--- lib/debugger/src/dbg_ui_mon.erl.sav	Tue May  6 16:29:49 2003
+++ lib/debugger/src/dbg_ui_mon.erl	Tue May  6 16:31:26 2003
@@ -379,7 +379,7 @@
 
 %% Help Menu
 gui_cmd('Debugger', State) ->
-    HelpFile = filename:join([code:lib_dir(debugger),"doc","index.html"]),
+    HelpFile = filename:join([code:lib_dir(debugger),"doc","html","index.html"]),
     tool_utils:open_help(State#state.gs, HelpFile),
     State;
 
