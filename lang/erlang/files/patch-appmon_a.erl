--- lib/appmon/src/appmon_a.erl.sav	Tue May  6 16:25:51 2003
+++ lib/appmon/src/appmon_a.erl	Tue May  6 16:26:07 2003
@@ -240,7 +240,7 @@
     refresh(State),
     {noreply, State};
 handle_info({gs, _, click, _, [?HELPTXT|_]}, State) ->
-    HelpFile = filename:join(code:priv_dir(appmon), "../doc/index.html"),
+    HelpFile = filename:join(code:priv_dir(appmon), "../doc/html/index.html"),
     tool_utils:open_help(gs:start(), HelpFile),
     {noreply, State};
 handle_info({gs, Id, click, {mode, Mode}, _}, State) ->
