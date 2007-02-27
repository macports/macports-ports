diff -x CVS -ru ../../rdiff-backup-r1-1-9/rdiff-backup/rdiff_backup/restore.py rdiff_backup/restore.py
--- ../../rdiff-backup-r1-1-9/rdiff-backup/rdiff_backup/restore.py	2005-12-14 20:57:27.000000000 -0800
+++ rdiff_backup/restore.py	2007-02-03 09:32:27.000000000 -0800
@@ -708,7 +708,7 @@
 		"""Change permissions of directories between old_index and index"""
 		for rp in self.get_new_rp_list(old_index, index):
 			if ((rp.isreg() and not rp.readable()) or
-				(rp.isdir() and not rp.hasfullperms())):
+				(rp.isdir() and not (rp.executable() and rp.readable()))):
 				old_perms = rp.getperms()
 				self.open_index_list.insert(0, (rp.index, rp, old_perms))
 				if rp.isreg(): rp.chmod(0400 | old_perms)
