--- src/rebuild.cc.orig	2005-10-05 21:43:35.000000000 -0700
+++ src/rebuild.cc	2005-10-05 21:43:36.000000000 -0700
@@ -1003,7 +1003,7 @@
         buf->pubseekoff(0, ios::end, ios::out);
 #else
         buf = new __gnu_cxx::stdio_filebuf<char> (seg->fd(), ios::out,
-						  false /* close */, default_segment_size);
+						  default_segment_size);
         buf->pubseekoff(0, ios::end, ios::out);
 #endif
 	os = new ostream(buf);
