--- sysdeps/common/mountlist.c.org	Mon Apr  5 22:13:56 2004
+++ sysdeps/common/mountlist.c	Mon Apr  5 22:14:20 2004
@@ -45,8 +45,9 @@
 #endif
 
 #if defined (MOUNTED_GETFSSTAT)	/* __alpha running OSF_1 */
-#  include <sys/mount.h>
-#  include <sys/fs_types.h>
+#include <sys/param.h>
+#include <sys/ucred.h>
+#include <sys/mount.h>
 #endif /* MOUNTED_GETFSSTAT */
 
 #ifdef MOUNTED_GETMNTENT1	/* 4.3BSD, SunOS, HP-UX, Dynix, Irix.  */
@@ -410,7 +411,7 @@
 	me = (struct mount_entry *) g_malloc (sizeof (struct mount_entry));
 	me->me_devname = g_strdup (stats[counter].f_mntfromname);
 	me->me_mountdir = g_strdup (stats[counter].f_mntonname);
-	me->me_type = g_strdup (mnt_names[stats[counter].f_type]);
+	me->me_type = g_strdup (stats[counter].f_type);
 	me->me_dev = (dev_t) -1;	/* Magic; means not known yet. */
 	me->me_next = NULL;
 
