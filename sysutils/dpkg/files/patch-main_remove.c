--- main/remove.c.orig	Fri Dec 10 15:48:16 2004
+++ main/remove.c	Fri Dec 10 15:51:29 2004
@@ -254,7 +254,18 @@
         push_leftover(&leftover,namenode);
         continue;
       }
-      if (errno != ENOTDIR) ohshite(_("cannot remove `%.250s'"),fnvb.buf);
+      if (errno != ENOTDIR) {
+	/* XXX Hack:
+	 * dpkg includes /. in the packing list.
+	 * rmdir("/.") will return EINVAL. dpkg will
+	 * only attempt to remove /. when uninstalling
+	 * the last package on the system, which is why
+	 * Debian has never run into this issue. */
+	if (errno == EINVAL && strcmp(fnvb.buf, "/.") == 0)
+	      continue;
+	else
+	      ohshite(_("cannot remove `%.250s'"),fnvb.buf);
+      }
       debug(dbg_eachfiledetail, "removal_bulk unlinking `%s'", fnvb.buf);
       {
         /*
@@ -367,7 +378,18 @@
       push_leftover(&leftover,namenode);
       continue;
     }
-    if (errno != ENOTDIR) ohshite(_("cannot remove `%.250s'"),fnvb.buf);
+    if (errno != ENOTDIR) {
+	/* XXX Hack:
+	 * dpkg includes /. in the packing list.
+	 * rmdir("/.") will return EINVAL. dpkg will
+	 * only attempt to remove /. when uninstalling
+	 * the last package on the system, which is why
+	 * Debian has never run into this issue. */
+	if (errno == EINVAL && strcmp(fnvb.buf, "/.") == 0)
+	      continue;
+	else
+	      ohshite(_("cannot remove `%.250s'"),fnvb.buf);
+    }
 
     push_leftover(&leftover,namenode);
     continue;
