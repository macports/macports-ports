--- lib/gs/src/tool_utils.erl.sav	Tue May  6 22:09:46 2003
+++ lib/gs/src/tool_utils.erl	Tue May  6 22:14:00 2003
@@ -51,7 +51,7 @@
 	local ->
 	    Cmd = case os:type() of
 		      {unix,_AnyType} ->
-			  "netscape -remote \"openURL(file:" ++ File ++ ")\"";
+			  "open " ++ File;
 
 		      {win32,_AnyType} ->
 			  "start " ++ filename:nativename(File)
@@ -62,7 +62,7 @@
 	remote ->
 	    Cmd = case os:type() of
 		      {unix,_AnyType} ->
-			  "netscape -remote \"openURL(" ++ File ++ ")\"";
+			  "open " ++ File;
 
 		      {win32,_AnyType} ->
 			  "netscape.exe -h " ++ regexp:gsub(File,"\\\\","/")
