diff -x CVS -ru ../../rdiff-backup-r1-1-9/rdiff-backup/rdiff_backup/fs_abilities.py rdiff_backup/fs_abilities.py
--- ../../rdiff-backup-r1-1-9/rdiff-backup/rdiff_backup/fs_abilities.py	2007-01-29 10:42:49.000000000 -0800
+++ rdiff_backup/fs_abilities.py	2007-01-31 08:12:02.000000000 -0800
@@ -603,13 +603,16 @@
 
 	def set_must_escape_dos_devices(self, rbdir):
 		"""If local edd or src edd, then must escape """
+		if getattr(self, "src_fsa", None) is not None:
+			src_edd = self.src_fsa.escape_dos_devices
+		else: src_edd = 0
 		device_rp = rbdir.append("aux")
 		if device_rp.lstat(): local_edd = 1
 		else: local_edd = 0
 		SetConnections.UpdateGlobal('must_escape_dos_devices', \
-			self.src_fsa.escape_dos_devices or local_edd)
+			src_edd or local_edd)
 		log.Log("Restore: must_escape_dos_devices = %d" % \
-				(self.src_fsa.escape_dos_devices or local_edd), 4)
+				(src_edd or local_edd), 4)
 
 	def set_chars_to_quote(self, rbdir):
 		"""Set chars_to_quote from rdiff-backup-data dir"""
