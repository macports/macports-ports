--- icmpmonitor.c	2004-05-28 03:33:07.000000000 +0200
+++ icmpmonitor.c	2005-11-01 20:38:47.000000000 +0100
@@ -224,8 +224,8 @@
     
     if(!cfgfile)
     {
-        log(LOG_WARNING,"No cfg file specified. Assuming 'icmpmonitor.cfg'");
-	cfgfile="icmpmonitor.cfg";
+        log(LOG_WARNING,"No cfg file specified. Assuming '__ETCDIR__/icmpmonitor.cfg'");
+	cfgfile="__ETCDIR__/icmpmonitor.cfg";
     }
 
     read_hosts(cfgfile); /* we do this before becoming daemon,
