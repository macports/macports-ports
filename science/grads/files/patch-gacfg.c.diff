--- src/gacfg.c.orig	2007-03-14 17:38:56.000000000 +0900
+++ src/gacfg.c	2007-03-14 18:15:48.000000000 +0900
@@ -50,13 +50,13 @@
 
 /* Config: v1.7b2,32-bit,little-endian,readline,NetCDF,sdf/xdf,lats,athena */
 
-sprintf(cmd,"Config: v%s",GRADS_VERSION);
+sprintf(cmd,"Config: v%s %2d-bit",GRADS_VERSION,sizeof(off_t)*8);
 
-if(GRADS_CRAY)  strcat(cmd," 64-bit,cray");
+/*if(GRADS_CRAY)  strcat(cmd," 64-bit,cray");*/
 /*kk 020624 --- s */
-else if (GRADS_HP64) strcat(cmd," 64-bit,hpux11");
+/*else if (GRADS_HP64) strcat(cmd," 64-bit,hpux11");*/
 /*kk 020624 --- e */
-else            strcat(cmd," 32-bit");
+/*else            strcat(cmd," 32-bit");*/
 
 if(BYTEORDER)   strcat(cmd," big-endian");
 else            strcat(cmd," little-endian");
