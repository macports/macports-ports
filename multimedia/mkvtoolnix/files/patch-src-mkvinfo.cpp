--- src/mkvinfo.cpp	Thu Aug 19 22:16:02 2004
+++ src/mkvinfo.cpp	Mon Sep 27 17:48:09 2004
@@ -1841,8 +1841,8 @@
             *static_cast<KaxEditionFlagDefault *>(l3);
           show_element(l3, 3, "Default: %u", uint8(fdefault));
 
-        } else if (is_id(l3, KaxEditionManaged)) {
-          KaxEditionManaged &managed = *static_cast<KaxEditionManaged *>(l3);
+        } else if (is_id(l3, KaxEditionProcessed)) {
+          KaxEditionProcessed &managed = *static_cast<KaxEditionProcessed *>(l3);
           show_element(l3, 3, "Managed: %llu", uint64(managed));
 
         } else if (!parse_chapter_atom(es, l3, 3) &&
@@ -2869,6 +2869,13 @@
 }
 
 #elif defined(SYS_UNIX) || defined(SYS_APPLE)
+
+#if defined(__WXMAC__)
+    // wxMac seems to have a specific wxEntry prototype
+	extern int wxEntry( int argc, char **argv, bool enterLoop = TRUE );
+#else
+	extern int wxEntry( int argc, char **argv );
+#endif
 
 int
 main(int argc,
