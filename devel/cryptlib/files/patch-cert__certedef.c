--- cert/certedef.c.orig	2005-04-04 05:28:40.000000000 -0400
+++ cert/certedef.c	2005-04-04 05:30:02.000000000 -0400
@@ -109,9 +109,9 @@
    tables.  These are declared in a somewhat peculiar manner because there's
    no clean way in C to forward declare a static array */
 
-extern const ATTRIBUTE_INFO FAR_BSS generalNameInfo[];
-extern const ATTRIBUTE_INFO FAR_BSS holdInstructionInfo[];
-extern const ATTRIBUTE_INFO FAR_BSS contentTypeInfo[];
+static const ATTRIBUTE_INFO FAR_BSS generalNameInfo[];
+static const ATTRIBUTE_INFO FAR_BSS holdInstructionInfo[];
+static const ATTRIBUTE_INFO FAR_BSS contentTypeInfo[];
 
 /****************************************************************************
 *																			*
