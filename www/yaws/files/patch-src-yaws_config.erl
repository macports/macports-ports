--- src/yaws_config.erl.orig	Sun Feb  8 12:04:16 2004
+++ src/yaws_config.erl	Sun Feb  8 12:04:32 2004
@@ -29,11 +29,11 @@
 paths() ->
     case yaws:getuid() of
 	{ok, "0"} ->    %% root 
-	    ["/etc/yaws.conf"];
+	    ["__PREFIX/etc/yaws.conf"];
 	_ -> %% developer
 	    [filename:join([os:getenv("HOME"), "yaws.conf"]),
 	     "./yaws.conf", 
-	     "/etc/yaws.conf"]
+	     "__PREFIX/etc/yaws.conf"]
     end.
 
 
