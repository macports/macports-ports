--- PrefHandler.m.orig	Tue May 18 17:21:22 2004
+++ PrefHandler.m	Tue May 18 17:21:40 2004
@@ -29,7 +29,7 @@
     defaults = [NSUserDefaults standardUserDefaults];
 	
 	//setup some defaults
-    [appDefaults setObject:@"./Modules" forKey:@"moduleLocation"];
+    [appDefaults setObject:@"__PREFIX/share/sword" forKey:@"moduleLocation"];
 	[appDefaults setObject:@"YES" forKey:@"cache lexicons"];
 	[appDefaults setObject:@"NO" forKey:@"descriptions"];
 	[appDefaults setObject:@"YES" forKey:@"tool tips"];
