--- rdiff_backup/Main.py.orig	Sun Aug 29 15:59:41 2004
+++ rdiff_backup/Main.py	Sun Aug 29 16:02:31 2004
@@ -397,10 +397,10 @@
 			rpout.conn.Globals.set_local(conn_attr, 1)
 
 	src_fsa = rpin.conn.fs_abilities.get_fsabilities_readonly('source', rpin)
-	Log(str(src_fsa), 3)
+	Log(str(src_fsa), 7)
 	dest_fsa = rpout.conn.fs_abilities.get_fsabilities_readwrite(
 		'destination', Globals.rbdir, 1, Globals.chars_to_quote)
-	Log(str(dest_fsa), 3)
+	Log(str(dest_fsa), 7)
 
 	update_triple(src_fsa.eas, dest_fsa.eas,
 				  ('eas_active', 'eas_write', 'eas_conn'))
@@ -502,11 +502,11 @@
 		if src_support: Globals.rbdir.conn.Globals.set_local(conn_attr, 1)
 
 	target_fsa = target.conn.fs_abilities.get_fsabilities_readwrite(
-		'destination', target, 0)
-	Log(str(target_fsa), 3)
+		'destination', target, 0, Globals.chars_to_quote)
+	Log(str(target_fsa), 7)
 	mirror_fsa = Globals.rbdir.conn.fs_abilities.get_fsabilities_restoresource(
 		Globals.rbdir)
-	Log(str(mirror_fsa), 3)
+	Log(str(mirror_fsa), 7)
 
 	update_triple(mirror_fsa.eas, target_fsa.eas,
 				  ('eas_active', 'eas_write', 'eas_conn'))
@@ -687,8 +687,8 @@
 		SetConnections.UpdateGlobal(write_attr, 1)
 		rbdir.conn.Globals.set_local(conn_attr, 1)
 
-	fsa = rbdir.conn.fs_abilities.get_fsabilities_readwrite('archive', rbdir)
-	Log(str(fsa), 3)
+	fsa = rbdir.conn.fs_abilities.get_fsabilities_readwrite('archive', rbdir, 1, Globals.chars_to_quote)
+	Log(str(fsa), 7)
 
 	update_triple(fsa.eas, ('eas_active', 'eas_write', 'eas_conn'))
 	update_triple(fsa.acls, ('acls_active', 'acls_write', 'acls_conn'))
