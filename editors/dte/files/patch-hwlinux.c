--- hwlinux.c	2000-02-13 03:07:04.000000000 +0100
+++ hwlinux.c	2005-10-27 23:36:45.000000000 +0200
@@ -636,7 +636,7 @@
      *  keep track of which version is being used where.
      * Once "dte" becomes more stable, this may not be useful.
      */
-    printf("\n\ndte version %s for Linux\n", VERSION);
+    printf("\n\ndte version %s for Darwin\n", VERSION);
 }
 
 /*
@@ -1778,7 +1778,7 @@
      *  the save file name unique for each user...
      */
     if (strcmp(name, RECOVERY) == 0) {
-        strcpy(cp, (id = cuserid(NULL)) ? id : "");
+        strcpy(cp, (id = getlogin()) ? id : "");
         cp += strlen(cp);
     }
 
