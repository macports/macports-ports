--- AppController.m	2007-01-25 15:11:40.000000000 -0500
+++ AppController.m	2007-02-01 15:20:50.000000000 -0500
@@ -70,8 +70,7 @@
   // setup for task
   NSString *askPassPath = [[NSBundle mainBundle] pathForResource:@"askpass"
                                                           ofType:@""];
-  NSString *sshfsPath = [[NSBundle mainBundle] pathForResource:@"sshfs-static"
-                                                        ofType:@""];
+  NSString *sshfsPath = @"##PREFIX##/bin/sshfs";
   NSDictionary *sshfsEnv = [NSDictionary dictionaryWithObjectsAndKeys:
     @"NONE", @"DISPLAY", // I know "NONE" is bogus; I just need something
     askPassPath, @"SSH_ASKPASS",
