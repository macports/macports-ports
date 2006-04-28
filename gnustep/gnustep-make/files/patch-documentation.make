--- Instance/documentation.make.orig	2006-03-14 00:21:40.000000000 -0500
+++ Instance/documentation.make	2006-03-14 00:22:06.000000000 -0500
@@ -124,7 +124,7 @@
 endif
 
 ifneq ($(LATEX_FILES),)
-  include $(GNUSTEP_MAKEFILES)/Instance/Documentation/latex.make
+#  include $(GNUSTEP_MAKEFILES)/Instance/Documentation/latex.make
 endif
 
 ifneq ($(JAVADOC_FILES),)
