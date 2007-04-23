--- ../sshfs-gui.old/AppController.m	2007-04-23 18:37:41.000000000 -0400
+++ AppController.m	2007-04-23 18:38:39.000000000 -0400
@@ -75,8 +75,7 @@
   // setup for task
   NSString *askPassPath = [[NSBundle mainBundle] pathForResource:@"askpass"
                                                           ofType:@""];
-  NSString *sshfsPath = [[NSBundle mainBundle] pathForResource:@"sshfs-static"
-                                                        ofType:@""];
+  NSString *sshfsPath = @"##PREFIX##/bin/sshfs";
   NSDictionary *sshfsEnv = [NSDictionary dictionaryWithObjectsAndKeys:
     @"NONE", @"DISPLAY", // I know "NONE" is bogus; I just need something
     askPassPath, @"SSH_ASKPASS",
