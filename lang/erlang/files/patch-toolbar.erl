--- lib/toolbar/src/toolbar.erl.sav	Fri Feb 11 13:09:09 2005
+++ lib/toolbar/src/toolbar.erl	Fri Feb 11 13:09:41 2005
@@ -43,7 +43,7 @@
 -export([init/1,start_tool/3]). % spawn
 
 %
--define (STARTUP_TIMEOUT, 20000).
+-define (STARTUP_TIMEOUT, 40000).
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
@@ -236,8 +236,8 @@
 		
 		%% About help
 		about_help ->
-		    tool_utils:notify(S,["Help text is on HTML format",
-		                  "Requires Netscape to be up and running"]),
+		    tool_utils:notify(S,["Help text is in HTML format and",
+		                  "will be displayed in your default browser."]),
 		    loop(S,Window,LoopData,TimerRef);
 
 		%% Window has been resized, redraw it
