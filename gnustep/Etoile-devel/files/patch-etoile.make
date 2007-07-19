--- etoile.make.orig	2007-04-30 01:07:49.000000000 -0400
+++ etoile.make	2007-05-07 12:09:15.000000000 -0400
@@ -240,6 +240,7 @@
 # developer. For example, it's commonly equals to ./shared_obj
 
 export ADDITIONAL_LIB_DIRS += -L$(BUILD_DIR)
+export SHARED_LD_POSTFLAGS += -lobjc -lgnustep-base -lgnustep-gui
 
 # We disable warnings about #import being deprecated. They occur with old GCC
 # version (before 4.0 iirc).
