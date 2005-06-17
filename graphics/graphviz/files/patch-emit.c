--- dotneato/common/emit.c.org	Wed Apr  6 16:30:25 2005
+++ dotneato/common/emit.c	Wed Apr  6 17:58:03 2005
@@ -1396,9 +1396,11 @@
 	    next_cg->info = next_component;
 
 	    /* get four chars of extension, trim and convert to lower case */
-	    char extension[5];
-	    GraphicsExportGetDefaultFileNameExtension((GraphicsExportComponent) next_component, (OSType *) & extension);
-	    extension[4] = '\0';
+	    /* prepend "qt_" */
+	    char extension[8];
+	    extension[0] = 'q'; extension[1] = 't'; extension[2] = '_';
+	    GraphicsExportGetDefaultFileNameExtension((GraphicsExportComponent) next_component, (OSType *) & (extension[3]));
+	    extension[7] = '\0';
 
 	    char *extension_ptr;
 	    for (extension_ptr = extension; *extension_ptr;
@@ -1467,7 +1469,11 @@
     }
     if (warn) {
 	agerr(AGWARN, "language %s not recognized, use one of:", str);
-	agerr(AGPREV, "%s\n", gvconfig_list_plugins(gvc, "renderer"));
+/*	agerr(AGPREV, "%s\n", gvconfig_list_plugins(gvc, "renderer")); */
+    for (p = first_codegen(); p->name; p = next_codegen(p)) {
+	agerr(AGPREV, "%s ", p->name);
+    }
+	agerr(AGPREV, "\n");
     }
     return ATTRIBUTED_DOT;
 }
