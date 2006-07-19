--- monarch_setup.pl.org	2006-07-06 16:02:05.000000000 -0700
+++ monarch_setup.pl	2006-07-17 08:59:06.000000000 -0700
@@ -1432,6 +1432,9 @@
 	system("chown -R $web_user:$web_group $monarch_home");
 	system("chown root:$web_group $monarch_home/bin/nagios_reload");
 	system("chmod 4750 $monarch_home/bin/nagios_reload");
+	system("chown root:$web_group $monarch_home/bin/nmap_scan_one");
+	system("chmod 4750 $monarch_home/bin/nmap_scan_one");
+
 	my $errors = 0;
 	if ($set_perms =~ /yes/i) {
 		my @files = ();
