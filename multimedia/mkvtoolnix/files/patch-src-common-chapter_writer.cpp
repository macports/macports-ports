--- src/common/chapter_writer.cpp	Thu Aug 19 22:16:02 2004
+++ src/common/chapter_writer.cpp	Mon Sep 27 17:13:49 2004
@@ -377,7 +377,7 @@
           o->printf("%u</EditionFlagHidden>\n",
                     uint8(*static_cast<EbmlUInteger *>(e)));
 
-        } else if (is_id(e, KaxEditionManaged)) {
+        } else if (is_id(e, KaxEditionProcessed)) {
           pt(2, "<EditionManaged>");
           o->printf("%u</EditionManaged>\n",
                     uint8(*static_cast<EbmlUInteger *>(e)));
