--- Source/util.h.orig	Thu Mar  3 19:16:54 2005
+++ Source/util.h	Thu Mar  3 19:22:44 2005
@@ -36,15 +36,18 @@
 size_t my_strftime(char *s, size_t max, const char  *fmt, const struct tm *tm);
 
 #ifndef __BIG_ENDIAN__
-# define FIX_ENDIAN_INT32_INPLACE(x) (x)
+# define SWAP_ENDIAN_INT32(x) (x)
+# define SWAP_ENDIAN_INT16(x) (x)
 #else
-# define FIX_ENDIAN_INT32_INPLACE(x) ((x) = SWAP_ENDIAN_INT32(x))
-#endif
 #define SWAP_ENDIAN_INT32(x) ( \
   (((x)&0xFF000000) >> 24) | \
   (((x)&0x00FF0000) >>  8) | \
   (((x)&0x0000FF00) <<  8) | \
   (((x)&0x000000FF) << 24) )
+#define SWAP_ENDIAN_INT16(x) ( \
+  ((x << 8) & 0xFF00) | \
+  ((x >> 8) & 0xFF) )
+#endif
 
 std::string get_full_path(const std::string &path);
 std::string get_dir_name(const std::string& path);
