--- rdiff_backup/Main.py.orig	Wed Jun 16 21:01:27 2004
+++ rdiff_backup/Main.py	Wed Jun 16 21:00:42 2004
@@ -502,7 +502,7 @@
 		if src_support: Globals.rbdir.conn.Globals.set_local(conn_attr, 1)
 
 	target_fsa = target.conn.fs_abilities.get_fsabilities_readwrite(
-		'destination', target, 0)
+		'destination', target, 0, Globals.chars_to_quote)
 	Log(str(target_fsa), 3)
 	mirror_fsa = Globals.rbdir.conn.fs_abilities.get_fsabilities_restoresource(
 		Globals.rbdir)
@@ -687,7 +687,7 @@
 		SetConnections.UpdateGlobal(write_attr, 1)
 		rbdir.conn.Globals.set_local(conn_attr, 1)
 
-	fsa = rbdir.conn.fs_abilities.get_fsabilities_readwrite('archive', rbdir)
+	fsa = rbdir.conn.fs_abilities.get_fsabilities_readwrite('archive', rbdir, 1, Globals.chars_to_quote)
 	Log(str(fsa), 3)
 
 	update_triple(fsa.eas, ('eas_active', 'eas_write', 'eas_conn'))
