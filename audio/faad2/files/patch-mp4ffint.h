--- common/mp4ff/mp4ffint.h.orig        2005-02-12 23:38:28.828890793 -0500
+++ common/mp4ff/mp4ffint.h     2005-02-12 23:41:01.618473068 -0500
@@ -301,7 +301,7 @@
 mp4ff_t *mp4ff_open_edit(mp4ff_callback_t *f);
 #endif
 void mp4ff_close(mp4ff_t *ff);
-void mp4ff_track_add(mp4ff_t *f);
+static void mp4ff_track_add(mp4ff_t *f);
 int32_t parse_sub_atoms(mp4ff_t *f, const uint64_t total_size);
 int32_t parse_atoms(mp4ff_t *f);
