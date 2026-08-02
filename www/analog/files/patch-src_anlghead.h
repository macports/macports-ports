--- src/anlghead.h.orig	Sun Dec 19 06:51:30 2004
+++ src/anlghead.h	Thu Dec 23 00:25:34 2004
@@ -47,7 +47,7 @@
 #endif
 
 #ifndef IMAGEDIR
-#define IMAGEDIR "images/"
+#define IMAGEDIR "@@PREFIX@@/share/analog/images/"
 /* URL of the directory where the images for the graphical reports live.
    The URL can be absolute, or relative to the output page: e.g., just the
    empty string "" for the same directory as the output page. */
@@ -93,41 +93,41 @@
    directory. This may or may not work, so it's better to specify a location
    explicitly here if you know where the files will be kept. */
 #ifndef LANGDIR
-#define LANGDIR NULL
+#define LANGDIR "@@PREFIX@@/share/analog/lang/"
 #endif
 /* Directory where the language files live. Actually, if this one is defined
    to be NULL, they will be looked for inside the "lang" subdirectory of the
    directory containing the analog binary. */
 #ifndef CONFIGDIR
-#define CONFIGDIR NULL
+#define CONFIGDIR ""
 #endif
 /* Directory containing configuration files. */
 #ifndef LOGSDIR
-#define LOGSDIR NULL
+#define LOGSDIR ""
 #endif
 /* Directory containing logfiles. */
 #ifndef CACHEDIR
-#define CACHEDIR NULL
+#define CACHEDIR ""
 #endif
 /* Directory containing cache files. */
 #ifndef OUTDIR
-#define OUTDIR NULL
+#define OUTDIR ""
 #endif
 /* Directory for writing output files: must already exist. */
 #ifndef HEADERDIR
-#define HEADERDIR NULL
+#define HEADERDIR ""
 #endif
 /* Directory containing header and footer files. */
 #ifndef DNSDIR
-#define DNSDIR NULL
+#define DNSDIR ""
 #endif
 /* Directory containing DNS files. */
 #ifndef LOCKDIR
-#define LOCKDIR NULL
+#define LOCKDIR ""
 #endif
 /* Directory containing the DNS lock file. */
 #ifndef ERRDIR
-#define ERRDIR NULL
+#define ERRDIR ""
 #endif
 /* Directory containing the ERRFILE. */
 
