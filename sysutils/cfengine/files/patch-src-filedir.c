--- src/filedir.c.orig	Wed Feb  4 14:59:48 2004
+++ src/filedir.c	Wed Feb  4 15:00:02 2004
@@ -554,7 +554,7 @@
    return;
    }
 #else
-if (((newperm & 07777) == (dstat->st_mode & 07777) && (action != touch))    /* file okay */
+if (((newperm & 07777) == (dstat->st_mode & 07777)) && (action != touch))    /* file okay */
    {
    Debug("File okay, newperm = %o, stat = %o\n",(newperm & 07777),(dstat->st_mode & 07777));
    fixmode = false;
