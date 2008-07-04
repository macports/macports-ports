--- extconf.rb.orig	2008-06-11 13:25:38.000000000 -0400
+++ extconf.rb	2008-06-10 19:18:56.000000000 -0400
@@ -31,20 +31,20 @@
 EOL
 end
 
-unless have_library('iconv','iconv_open') or
-    have_library('c','iconv_open') or
-    have_library('recode','iconv_open')
-  crash(<<EOL)
-need libiconv.
-
-	Install libiconv or try passing some of the following options
-	to extconf.rb:
-
-        --with-iconv-dir=/path/to/iconv
-        --with-iconv-lib=/path/to/iconv/lib
-        --with-iconv-include=/path/to/iconv/include
-EOL
-end
+# unless have_library('iconv','iconv_open') or
+#     have_library('c','iconv_open') or
+#     have_library('recode','iconv_open')
+#   crash(<<EOL)
+# need libiconv.
+# 
+# 	Install libiconv or try passing some of the following options
+# 	to extconf.rb:
+# 
+#         --with-iconv-dir=/path/to/iconv
+#         --with-iconv-lib=/path/to/iconv/lib
+#         --with-iconv-include=/path/to/iconv/include
+# EOL
+# end
 
 unless have_header('GeoIP.h') and
     have_header('GeoIPUpdate.h') and
@@ -66,7 +66,7 @@
 EOL
 end
 
-$CFLAGS = '-g -Wall' + $CFLAGS
+$CFLAGS = '-g -Wall ' + $CFLAGS
 
 create_header()
 create_makefile('net/geoip')
