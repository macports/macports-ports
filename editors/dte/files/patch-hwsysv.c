--- hwsysv.c	2000-02-13 03:15:43.000000000 +0100
+++ hwsysv.c	2005-10-27 23:35:53.000000000 +0200
@@ -1755,7 +1755,7 @@
      *  the save file name unique for each user...
      */
     if (strcmp(name, RECOVERY) == 0) {
-        strcpy(cp, (id = cuserid(NULL)) ? id : "");
+        strcpy(cp, (id = getlogin()) ? id : "");
         cp += strlen(cp);
     }
 
