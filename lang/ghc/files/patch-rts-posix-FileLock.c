--- rts/posix/FileLock.c.sav	2008-03-03 11:40:14.000000000 -0500
+++ rts/posix/FileLock.c	2008-03-03 11:43:40.000000000 -0500
@@ -88,6 +88,17 @@
         if (for_writing || lock->readers < 0) {
             return -1;
         }
+
+	// have we seen this fd before?
+	if (lookupHashTable(fd_hash, fd) == NULL) {
+		insertHashTable(fd_hash, fd, lock);
+	}
+	else
+	{
+		errorBelch("fd %d tries to lock the same file twice", fd);
+		return -1;
+	}
+
         lock->readers++;
         return 0;
     }
