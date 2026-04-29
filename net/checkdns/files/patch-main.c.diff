--- main.c	2005-03-02 09:29:40.000000000 +0100
+++ main.c	2005-11-24 21:44:21.000000000 +0100
@@ -20,7 +20,7 @@
 	FILE *fd;
 	char *tmp, *tmp1;
 
-	(void) strncpy(conf_file, "/usr/local/etc/checkdns.conf", TINYBUFSIZE-1);
+	(void) strncpy(conf_file, "__PREFIX__/etc/checkdns/checkdns.conf", TINYBUFSIZE-1);
 
 	while((c = getopt(argc, argv, "c:hv")) != -1) {
 		switch(c) {
