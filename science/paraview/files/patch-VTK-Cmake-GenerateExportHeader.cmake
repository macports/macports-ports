--- VTK/CMake/GenerateExportHeader.cmake.orig	2016-06-01 13:33:49.000000000 -0400
+++ VTK/CMake/GenerateExportHeader.cmake	2016-06-01 13:34:26.000000000 -0400
@@ -166,12 +166,12 @@
     execute_process(COMMAND ${CMAKE_C_COMPILER} ARGS --version
       OUTPUT_VARIABLE _gcc_version_info
       ERROR_VARIABLE _gcc_version_info)
-    string(REGEX MATCH "[345]\\.[0-9]\\.[0-9]*"
+    string(REGEX MATCH "[3-7]\\.[0-9]\\.[0-9]*"
       _gcc_version "${_gcc_version_info}")
     # gcc on mac just reports: "gcc (GCC) 3.3 20030304 ..." without the
     # patch level, handle this here:
     if(NOT _gcc_version)
-      string(REGEX REPLACE ".*\\(GCC\\).*([34]\\.[0-9]).*" "\\1.0"
+      string(REGEX REPLACE ".*\\(GCC\\).*([3-7]\\.[0-9]).*" "\\1.0"
         _gcc_version "${_gcc_version_info}")
     endif()
 
