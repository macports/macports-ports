--- rdiff_backup/fs_abilities.py.orig	Sun Aug 29 16:31:30 2004
+++ rdiff_backup/fs_abilities.py	Sun Aug 29 16:33:14 2004
@@ -174,7 +174,7 @@
 					log.Log("Warning: File system no longer needs quoting, "
 							"but will retain for backwards compatibility.", 2)
 					self.chars_to_quote = old_chars
-				else: log.FatalError("""New quoting requirements
+				else: log.Log.FatalError("""New quoting requirements
 
 This may be caused when you copy an rdiff-backup directory from a
 normal file system on to a windows one that cannot support the same
@@ -218,7 +218,7 @@
 		try: testdir.fsync()
 		except (IOError, OSError), exc:
 			log.Log("Directories on file system at %s are not fsyncable.\n"
-					"Assuming it's unnecessary." % (testdir.path,), 4)
+					"Assuming it's unnecessary." % (testdir.path,), 8)
 			self.fsync_dirs = 0
 		else: self.fsync_dirs = 1
 
@@ -274,14 +274,14 @@
 		except ImportError:
 			log.Log("Unable to import module posix1e from pylibacl "
 					"package.\nACLs not supported on filesystem at %s" %
-					(rp.path,), 4)
+					(rp.path,), 8)
 			self.acls = 0
 			return
 
 		try: posix1e.ACL(file=rp.path)
 		except IOError, exc:
 			log.Log("ACLs appear not to be supported by "
-					"filesystem at %s" % (rp.path,), 4)
+					"filesystem at %s" % (rp.path,), 8)
 			self.acls = 0
 		else: self.acls = 1
 		
@@ -291,8 +291,8 @@
 		assert rp.lstat()
 		try: import xattr
 		except ImportError:
-			log.Log("Unable to import module xattr.  EAs not "
-					"supported on filesystem at %s" % (rp.path,), 4)
+			log.Log("Unable to import module xattr.\nExtended attributes not "
+					"supported on filesystem at %s" % (rp.path,), 8)
 			self.eas = 0
 			return
 
@@ -303,7 +303,7 @@
 				assert xattr.getxattr(rp.path, "user.test") == "test val"
 		except IOError, exc:
 			log.Log("Extended attributes not supported by "
-					"filesystem at %s" % (rp.path,), 4)
+					"filesystem at %s" % (rp.path,), 8)
 			self.eas = 0
 		else: self.eas = 1
 
