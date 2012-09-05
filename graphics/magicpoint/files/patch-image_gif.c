--- image/gif.c.orig	2000-03-07 17:59:56.000000000 +1100
+++ image/gif.c	2012-09-06 06:12:57.000000000 +1000
@@ -32,6 +32,18 @@ static int InterlacedOffset[] = { 0, 4, 
 /* be read - offsets and jumps... */
 static int InterlacedJumps[] = { 8, 8, 4, 2 };
 
+#if defined(GIFLIB_MAJOR) && defined(GIFLIB_MINOR) && \
+    ((GIFLIB_MAJOR == 4 && GIFLIB_MINOR >= 2) || GIFLIB_MAJOR > 4)
+void
+PrintGifError(void) {
+    char *Err = GifErrorString();
+    if (Err != NULL)
+        fprintf(stderr, "\nGIF-LIB error: %s.\n", Err);
+    else
+        fprintf(stderr, "\nGIF-LIB undefined error %d.\n", GifError());
+}
+#endif
+
 Image *
 gifLoad(fullname, name, verbose)
 	char *fullname, *name;
