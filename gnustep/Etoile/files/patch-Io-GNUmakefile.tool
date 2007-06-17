--- Languages/Io/GNUmakefile.tool.orig	2007-05-07 09:22:47.000000000 -0400
+++ Languages/Io/GNUmakefile.tool	2007-05-07 09:23:04.000000000 -0400
@@ -1,4 +1,4 @@
-ifeq ($(FOUNDATION_LIB), apple)
+ifeq ($(findstring darwin, $(GNUSTEP_TARGET_OS)), darwin)
   # For Vector
   ADDITIONAL_LDFLAGS += -framework Accelerate -faltivec
   # Only for Darwin 
