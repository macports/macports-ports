--- src/yaws_config.erl.orig	Fri May 28 13:38:11 2004
+++ src/yaws_config.erl	Wed Sep 29 13:16:40 2004
@@ -30,11 +30,11 @@
 paths() ->
     case yaws:getuid() of
 	{ok, "0"} ->    %% root 
-	    ["/etc/yaws.conf"];
+	    ["/Volumes/Medias/opt/local/etc/yaws.conf"];
 	_ -> %% developer
 	    [filename:join([os:getenv("HOME"), "yaws.conf"]),
 	     "./yaws.conf", 
-	     "/etc/yaws.conf"]
+	     "/Volumes/Medias/opt/local/etc/yaws.conf"]
     end.
 
 
