--- VTK/CMake/vtkCompilerExtras.cmake.orig	2016-06-01 13:32:16.000000000 -0400
+++ VTK/CMake/vtkCompilerExtras.cmake	2016-06-01 13:35:31.000000000 -0400
@@ -32,10 +32,10 @@
     OUTPUT_VARIABLE _gcc_version_info
     ERROR_VARIABLE _gcc_version_info)
 
-  string (REGEX MATCH "[345]\\.[0-9]\\.[0-9]*"
+  string (REGEX MATCH "[3-7]\\.[0-9]\\.[0-9]*"
     _gcc_version "${_gcc_version_info}")
   if(NOT _gcc_version)
-    string (REGEX REPLACE ".*\\(GCC\\).*([34]\\.[0-9]).*" "\\1.0"
+    string (REGEX REPLACE ".*\\(GCC\\).*([3-7]\\.[0-9]).*" "\\1.0"
       _gcc_version "${_gcc_version_info}")
   endif()
 
