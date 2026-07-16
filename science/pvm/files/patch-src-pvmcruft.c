--- src/pvmcruft.c	2004-03-10 18:01:27.000000000 +0100
+++ src/pvmcruft.c	2006-08-18 10:29:04.000000000 +0200
@@ -893,7 +893,21 @@
 #else
 		rd = getenv("PVM_ROOT");
 #endif
+#ifdef PVM_DEFAULT_ROOT
+		if (!rd) {
+			struct stat buf;
 
+			rd = STRALLOC(PVM_DEFAULT_ROOT);
+			if (stat(rd, &buf) == -1) {
+				pvmlogperror("Unable to default PVM_ROOT to"  PVM_DEFAULT_ROOT);
+				pvmbailout(0);
+				exit(1);                /* the other meaning of bail out */    
+			}
+			pvmputenv("PVM_ROOT=" /* */ PVM_DEFAULT_ROOT);
+/*			pvmlogerror("Defaulting PVM_ROOT to "  PVM_DEFAULT_ROOT); */
+		}
+#endif 
+		
 #ifdef WIN32
 		if (!rd)
 			rd = read_pvmregistry("PVM_ROOT");
