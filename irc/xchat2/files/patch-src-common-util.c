--- src/common/util.c.orig	Mon Jun  7 16:16:50 2004
+++ src/common/util.c	Mon Jun  7 16:19:08 2004
@@ -580,7 +580,7 @@
 {
 #if defined (USING_LINUX) || defined (USING_FREEBSD)
 	double mhz;
-	int cpus = 1;
+	int cpus;
 #endif
 	struct utsname un;
 	static char *buf = NULL;
@@ -604,9 +604,7 @@
 					cpuspeed, cpuspeedstr);
 	} else
 #endif
-		snprintf (buf, 128,
-					(cpus == 1) ? "%s %s [%s]" : "%s %s [%s/SMP]",
-					un.sysname, un.release, un.machine);
+		snprintf (buf, 128, "%s %s [%s]", un.sysname, un.release, un.machine);
 
 	return buf;
 }
