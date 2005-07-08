--- src/gplt_x11.c.orig	2005-06-20 20:45:43.000000000 -0700
+++ src/gplt_x11.c	2005-06-20 20:49:22.000000000 -0700
@@ -515,8 +515,8 @@
 static unsigned int dep;		/* depth */
 
 static Bool Mono = 0, Gray = 0, Rv = 0, Clear = 0;
-static char Name[64] = "gnuplot";
-static char Class[64] = "Gnuplot";
+static char X_Name[64] = "gnuplot";
+static char X_Class[64] = "Gnuplot";
 
 static int cx = 0, cy = 0;
 
@@ -3891,13 +3891,13 @@
 
     while (++Argv, --Argc > 0) {
 	if (!strcmp(*Argv, "-name") && Argc > 1) {
-	    strncpy(Name, Argv[1], sizeof(Name) - 1);
-	    strncpy(Class, Argv[1], sizeof(Class) - 1);
+	    strncpy(X_Name, Argv[1], sizeof(X_Name) - 1);
+	    strncpy(X_Class, Argv[1], sizeof(X_Class) - 1);
 	    /* just in case */
-	    Name[sizeof(Name) - 1] = NUL;
-	    Class[sizeof(Class) - 1] = NUL;
-	    if (Class[0] >= 'a' && Class[0] <= 'z')
-		Class[0] -= 0x20;
+	    X_Name[sizeof(X_Name) - 1] = NUL;
+	    X_Class[sizeof(X_Class) - 1] = NUL;
+	    if (X_Class[0] >= 'a' && X_Class[0] <= 'z')
+		X_Class[0] -= 0x20;
 	}
     }
     Argc = argc;
@@ -3906,7 +3906,7 @@
 /*---parse command line---------------------------------------------------*/
 
     XrmInitialize();
-    XrmParseCommand(&dbCmd, options, Nopt, Name, &Argc, Argv);
+    XrmParseCommand(&dbCmd, options, Nopt, X_Name, &Argc, Argv);
     if (Argc > 1) {
 #ifdef PIPE_IPC
 	if (!strcmp(Argv[1], "-noevents")) {
@@ -4129,9 +4129,9 @@
 {
     char name[128], class[128], *rc;
 
-    strcpy(name, Name);
+    strcpy(name, X_Name);
     strcat(name, resource);
-    strcpy(class, Class);
+    strcpy(class, X_Class);
     strcat(class, resource);
     rc = XrmGetResource(xrdb, name, class, type, &value)
 	? (char *) value.addr : (char *) 0;
@@ -4614,7 +4614,7 @@
 #undef TEMP_NUM_LEN
     if (!plot->titlestring) {
 	int orig_len;
-	if (!title) title = Class;
+	if (!title) title = X_Class;
 	orig_len = strlen(title);
 	/* memory for text, white space, number and terminating \0 */
 	if ((plot->titlestring = (char *) malloc(orig_len + ((orig_len && plot->plot_number) ? 1 : 0) + strlen(numstr) - strlen(ICON_TEXT) + 1))) {
