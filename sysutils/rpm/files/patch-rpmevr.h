--- lib/rpmevr.h.orig	2007-05-16 12:55:05.000000000 +0200
+++ lib/rpmevr.h	2007-08-09 18:36:13.000000000 +0200
@@ -6,6 +6,10 @@
  * Structure(s) and routine(s) used for EVR parsing and comparison.
  */
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /**
  */
 /*@-exportlocal@*/
@@ -117,10 +121,6 @@
 #define	isErasePreReq(_x)	((_x) & _ERASE_ONLY_MASK)
 #endif	/* _RPMEVR_INTERNAL */
 
-#ifdef __cplusplus
-extern "C" {
-#endif
-
 /** \ingroup rpmds
  * Segmented string compare.
  * @param a		1st string
--- ./lib/rpmevr.h.orig	2007-05-16 12:55:05.000000000 +0200
+++ ./lib/rpmevr.h	2007-06-20 10:13:14.000000000 +0200
@@ -18,8 +18,6 @@
 /**
  * Dependency Attributes.
  */
-typedef	enum evrFlags_e rpmsenseFlags;
-typedef	enum evrFlags_e evrFlags;
 
 /*@-matchfields@*/
 enum evrFlags_e {
@@ -67,6 +65,9 @@
 };
 /*@=matchfields@*/
 
+typedef	enum evrFlags_e rpmsenseFlags;
+typedef	enum evrFlags_e evrFlags;
+
 #define	RPMSENSE_SENSEMASK	0x0e	 /* Mask to get senses, ie serial, */
                                          /* less, greater, equal.          */
 #define	RPMSENSE_NOTEQUAL	(RPMSENSE_EQUAL ^ RPMSENSE_SENSEMASK)
