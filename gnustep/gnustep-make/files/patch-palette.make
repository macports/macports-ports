--- Instance/palette.make.orig	2006-04-17 14:14:15.000000000 -0400
+++ Instance/palette.make	2006-04-17 23:21:01.000000000 -0400
@@ -62,7 +62,7 @@
 
 # On Apple, two-level namespaces require all symbols in bundles
 # to be resolved at link time.
-ifeq ($(FOUNDATION_LIB), apple)
+ifeq ($(CC_BUNDLE), yes)
   LINK_PALETTE_AGAINST_ALL_LIBS = yes
 endif
 
