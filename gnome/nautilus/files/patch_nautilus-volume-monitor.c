--- libnautilus-private/nautilus-volume-monitor.c.org	Fri Nov 28 16:14:58 2003
+++ libnautilus-private/nautilus-volume-monitor.c	Fri Nov 28 16:28:16 2003
@@ -121,6 +121,11 @@
 #define MNTOPT_RO "ro"
 #endif
 
+#ifdef __APPLE__
+#define setmntent(f,m) fopen(f,m)
+#define endmntent(f) fclose(f)
+#endif
+
 #ifndef HAVE_SETMNTENT
 #define setmntent(f,m) fopen(f,m)
 #endif
@@ -589,15 +594,6 @@
 static gboolean
 has_removable_mntent_options (MountTableEntry *ent)
 {
-#ifdef HAVE_HASMNTOPT
-	/* Use "owner" or "user" or "users" as our way of determining a removable volume */
-	if (hasmntopt (ent, "user") != NULL
-	    || hasmntopt (ent, "users") != NULL
-	    || hasmntopt (ent, "owner") != NULL
-	    || eel_strcmp("supermount", MOUNT_TABLE_ENTRY_TYPE (ent)) == 0) {
-		return TRUE;
-	}
-#endif
 
 #ifdef SOLARIS_MNT
 	if (eel_str_has_prefix (ent->mnt_special, "/vol/")) {
@@ -794,16 +790,6 @@
 #elif defined (HAVE_MNTENT_H)
 	while ((ent = getmntent (file)) != NULL) {
 		if (has_removable_mntent_options (ent)) {
-#if defined (HAVE_HASMNTOPT)
-
-			if (eel_strcmp("supermount", ent->mnt_type) == 0) {
-				fs_opt = eel_str_strip_substring_and_after (hasmntopt (ent, "dev="),
-									    ",");
-				volume = create_volume (fs_opt+strlen("dev="), ent->mnt_dir);
-				g_free (fs_opt);
-
-			} else {
-#endif
 				volume = create_volume (ent->mnt_fsname, ent->mnt_dir);
 #if defined (HAVE_HASMNTOPT)
 			}
@@ -831,16 +817,6 @@
 entry_is_supermounted_volume (const MountTableEntry *ent, const NautilusVolume *volume)
 {
       gboolean result = FALSE;
-#ifdef HAVE_HASMNTOPT
-      char * fs_opt;
-
-      if (strcmp (MOUNT_TABLE_ENTRY_TYPE (ent), "supermount") == 0) {
-              fs_opt = eel_str_strip_substring_and_after (hasmntopt (ent, "dev="),
-                                                          ",");
-              result = strcmp (volume->device_path, fs_opt + strlen ("dev=")) == 0;
-              g_free (fs_opt);
-      }
-#endif
       return result;
 }
 
