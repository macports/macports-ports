--- parser.c.org	2002-03-13 04:34:22.000000000 -0800
+++ parser.c	2006-05-30 18:30:12.000000000 -0700
@@ -74,8 +74,10 @@
 		} 
 		fclose(conf);
 
-		/* Always add the 127.0.0.1/255.0.0.0 subnet to local */
-		handle_local(config, 0, "127.0.0.0/255.0.0.0");
+               if (!config->localnets) {
+                       /* Use 127.0.0.1/255.0.0.0 by default */
+                       handle_local(config, 0, "127.0.0.0/255.0.0.0");
+               }
 
 		/* Check default server */
 		check_server(&(config->defaultserver));
