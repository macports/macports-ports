--- src/system.H	2008-02-27 14:26:31.000000000 +0100
+++ src/system.H.patched	2009-09-10 17:17:35.000000000 +0200
@@ -284,7 +284,7 @@
 #define PRESTD_RESCAN_LIMIT 0x100
 #endif
 #ifndef NBUFF
-#define NBUFF               0x10000     /* Must be NWORK <= NBUFF   */
+#define NBUFF               0x40000     /* Must be NWORK <= NBUFF   */
 #endif
 #ifndef NWORK
 #define NWORK               NBUFF       /* 0x1000, 0x4000, 0x10000, ..  */
