--- src/prcserror.cc.orig	Wed Dec 22 21:43:40 2004
+++ src/prcserror.cc	Wed Dec 22 21:43:47 2004
@@ -50,13 +50,8 @@
 int return_if_fail_if_ne_val;
 #endif
 
-#if defined(__APPLE__)
- stdiobuf stdout_stream(STDOUT_FILENO);
- stdiobuf stderr_stream(STDERR_FILENO);
-#else
  __gnu_cxx::stdio_filebuf<char> stdout_stream(stdout, ios::out);
  __gnu_cxx::stdio_filebuf<char> stderr_stream(stderr, ios::out);
-#endif /* if defined(__APPLE__) */
 strstreambuf query_stream;
 
 static PrettyStreambuf pretty_stdout_stream(&stdout_stream, NULL);
