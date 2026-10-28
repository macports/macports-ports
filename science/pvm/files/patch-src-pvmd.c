--- src/pvmd.c	2004-09-08 21:35:36.000000000 +0200
+++ src/pvmd.c	2006-08-18 10:29:13.000000000 +0200
@@ -1712,6 +1712,7 @@
 	gettimeofday(&tnow, (struct timezone*)0);
 	if (pvmdebmask || myhostpart) {
 		PVM_TIMET time_temp;
+		char retbuf[32];
 		pvmlogprintf("%s (%s) %s %s\n",
 				hosts->ht_hosts[hosts->ht_local]->hd_name,
 				inadport_decimal(&hosts->ht_hosts[hosts->ht_local]->hd_sad),
@@ -1719,7 +1720,8 @@
 				PVM_VER);
 		pvmlogprintf("ready ");
 		time_temp = (PVM_TIMET) tnow.tv_sec;
-		pvmlogprintf(ctime(&time_temp));
+		ctime_r(&time_temp, retbuf);
+		pvmlogprintf(retbuf);
 	}
 
 	/*
