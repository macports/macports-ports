--- source/nan_compile.mk	Sat Dec 27 18:29:25 2003
+++ ../../blender/source/nan_compile.mk	Sun Feb  8 21:17:21 2004
@@ -38,7 +38,7 @@
 # common parts ---------------------------------------------------
 
 # Uncomment next line to enable integrated game engine
-#CFLAGS += -DGAMEBLENDER=1
+CFLAGS += -DGAMEBLENDER=1
 
 ifdef NAN_DEBUG
     CFLAGS += $(NAN_DEBUG)
