--- nmap_scan/nmap_scan.c.org	2006-03-14 18:26:47.000000000 -0800
+++ nmap_scan/nmap_scan.c	2006-07-15 23:58:37.000000000 -0700
@@ -1,8 +1,8 @@
 #include <signal.h>
 #include <sys/param.h>
 #include <pwd.h>
-static char *nmap_pl = "/usr/local/groundwork/monarch/bin/nmap_scan_one.pl";
-static char *trusted_env[]={"PATH=/usr/local/groundwork/bin:/usr/bin:/usr/sbin:/sbin:/bin",0};
+static char *nmap_pl = "__PREFIX__/groundwork/monarch/bin/nmap_scan_one.pl";
+static char *trusted_env[]={"PATH=__PREFIX__/groundwork/monarch/bin:__PREFIX__/bin:__PREFIX__/sbin:/usr/bin:/usr/sbin:/sbin:/bin",0};
 int main(int argc, char *argv[])
 {
     char *ip_address = argv[1];
