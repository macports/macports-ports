--- sysdeps/common/mountlist.c.org	Tue Aug 26 20:40:57 2003
+++ sysdeps/common/mountlist.c	Tue Aug 26 20:42:18 2003
@@ -54,8 +54,9 @@
 #endif
 
 #if defined (MOUNTED_GETFSSTAT)	/* __alpha running OSF_1 */
-#  include <sys/mount.h>
-#  include <sys/fs_types.h>
+#include <sys/param.h>
+#include <sys/ucred.h>
+#include <sys/mount.h>
 #endif /* MOUNTED_GETFSSTAT */
 
 #ifdef MOUNTED_GETMNTENT1	/* 4.3BSD, SunOS, HP-UX, Dynix, Irix.  */
@@ -419,7 +420,7 @@
 	me = (struct mount_entry *) xmalloc (sizeof (struct mount_entry));
 	me->me_devname = xstrdup (stats[counter].f_mntfromname);
 	me->me_mountdir = xstrdup (stats[counter].f_mntonname);
-	me->me_type = xstrdup (mnt_names[stats[counter].f_type]);
+	me->me_type = xstrdup (stats[counter].f_type);
 	me->me_dev = (dev_t) -1;	/* Magic; means not known yet. */
 	me->me_next = NULL;
 
