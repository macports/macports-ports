--- rdiff_backup/fs_abilities.py.orig	Wed Jun 16 22:03:30 2004
+++ rdiff_backup/fs_abilities.py	Wed Jun 16 22:05:32 2004
@@ -174,7 +174,7 @@
 					log.Log("Warning: File system no longer needs quoting, "
 							"but will retain for backwards compatibility.", 2)
 					self.chars_to_quote = old_chars
-				else: log.FatalError("""New quoting requirements
+				else: log.Log.FatalError("""New quoting requirements
 
 This may be caused when you copy an rdiff-backup directory from a
 normal file system on to a windows one that cannot support the same
@@ -291,7 +291,7 @@
 		assert rp.lstat()
 		try: import xattr
 		except ImportError:
-			log.Log("Unable to import module xattr.  EAs not "
+			log.Log("Unable to import module xattr.\nExtended attributes not "
 					"supported on filesystem at %s" % (rp.path,), 4)
 			self.eas = 0
 			return
