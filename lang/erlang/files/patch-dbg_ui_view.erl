--- lib/debugger/src/dbg_ui_view.erl.sav	Tue May  6 16:30:14 2003
+++ lib/debugger/src/dbg_ui_view.erl	Tue May  6 16:32:01 2003
@@ -165,7 +165,7 @@
 
 %% Help menu
 gui_cmd('Debugger', State) ->
-    HelpFile = filename:join([code:lib_dir(debugger),"doc","index.html"]),
+    HelpFile = filename:join([code:lib_dir(debugger),"doc","html","index.html"]),
     tool_utils:open_help(State#state.gs, HelpFile),
     State.
 
