--- src/backend/utils/mb/conversion_procs/proc.mk.orig	Wed Mar 19 17:51:05 2003
+++ src/backend/utils/mb/conversion_procs/proc.mk	Wed Mar 19 17:51:45 2003
@@ -3,7 +3,8 @@
 
 SHLIB_LINK 	:= $(BE_DLLLIBS)
 
-SO_MAJOR_VERSION := 0
+# for Darwin -dylib_compatibility_version
+SO_MAJOR_VERSION := 1
 SO_MINOR_VERSION := 0
 rpath =
 
