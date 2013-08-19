--- src/common/logger.cpp.orig	2013-06-27 23:02:44.000000000 +0300
+++ src/common/logger.cpp	2013-07-14 10:13:25.026646733 +0300
@@ -12,6 +12,7 @@
 
 #include <chrono>
 #include <ctime>
+#include <ciso646>
 
 #include "common/logger.h"
 #include "common/fs_sys_helpers.h"
@@ -20,7 +21,11 @@
 
 logger_cptr logger_c::s_default_logger;
 
+#if defined( _LIBCPP_VERSION )
+static auto s_program_start_time = std::chrono::system_clock::now();
+#else
 static auto s_program_start_time = std::chrono::high_resolution_clock::now();
+#endif
 
 logger_c::logger_c(bfs::path const &file_name)
   : m_file_name(file_name)
@@ -41,9 +46,17 @@
     mm_text_io_c out(new mm_file_io_c(m_file_name.string(), bfs::exists(m_file_name) ? MODE_WRITE : MODE_CREATE));
     out.setFilePointer(0, seek_end);
 
-    auto now  = std::chrono::high_resolution_clock::now();
+    #if defined( _LIBCPP_VERSION )
+    auto now  = std::chrono::system_clock::now();
+    #else
+    auto now  = std::chrono::high_resolution_clock::now();
+    #endif
     auto diff = now - s_program_start_time;
+    #if defined( _LIBCPP_VERSION )
+    auto tnow = std::chrono::system_clock::to_time_t(now);
+    #else
     auto tnow = std::chrono::high_resolution_clock::to_time_t(now);
+    #endif
 
     // 2013-03-02 15:42:32
     char timestamp[30];