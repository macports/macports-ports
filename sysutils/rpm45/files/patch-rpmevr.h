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
