--- src/motifutils.c.orig	2011-08-04 11:11:51.000000000 +0200
+++ src/motifutils.c	2011-08-04 10:57:01.000000000 +0200
@@ -121,7 +121,7 @@
 
     i = 0;
     va_start(var, nchoices);
-    while ((s = va_arg(var, char *)) != NULL) {
+    while ((s = va_arg(var, char *)) != NULL && i<nchoices) {
 	retval[i + 2] = XmCreatePushButton(retval[1], s, NULL, 0);
 	i++;
     }
@@ -169,7 +169,7 @@
     i = 0;
 
     va_start(var, nchoices);
-    while ((s = va_arg(var, char *)) != NULL) {
+    while ((s = va_arg(var, char *)) != NULL && i<nchoices) {
 	retval[i + 2] = XmCreatePushButton(retval[1], s, NULL, 0);
 	i++;
     }
@@ -1294,7 +1294,7 @@
     	XmNlabelString, str, 
     	XmNmnemonic, mnemonic,
     	XmNsubMenuId, menu, 
-    	0);
+    	(char *)NULL);
     XmStringFree(str);
     if (help_anchor) {
      	XtAddCallback(menu, XmNhelpCallback, (XtCallbackProc) HelpCB,
