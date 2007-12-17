--- config.c.orig	2007-09-10 22:39:48.000000000 +0200
+++ config.c	2007-12-17 12:26:10.000000000 +0100
@@ -267,7 +267,7 @@
 
 static const char *config_def_script(void)
 {
-	return "/etc/vpnc/vpnc-script";
+	return "__ETCDIR__/vpnc/vpnc-script";
 }
 
 static const char *config_def_pid_file(void)
@@ -538,7 +538,7 @@
 {
 	char *realname;
 	
-	asprintf(&realname, "%s%s%s", index(name, '/') ? "" : "/etc/vpnc/", name, add_dot_conf ? ".conf" : "");
+	asprintf(&realname, "%s%s%s", index(name, '/') ? "" : "__ETCDIR__/vpnc/", name, add_dot_conf ? ".conf" : "");
 	return realname;
 }
 
@@ -757,8 +757,8 @@
 	}
 	
 	if (!got_conffile) {
-		read_config_file("/etc/vpnc/default.conf", config, 1);
-		read_config_file("/etc/vpnc.conf", config, 1);
+		read_config_file("__ETCDIR__/vpnc/default.conf", config, 1);
+		read_config_file("__ETCDIR__/vpnc.conf", config, 1);
 	}
 	
 	if (!print_config) {
