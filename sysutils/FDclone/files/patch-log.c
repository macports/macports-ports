--- ../old/FD-2.08f/log.c	Tue Aug  8 00:00:00 2006
+++ ./log.c	Wed Aug  9 00:43:17 2006
@@ -109,6 +109,7 @@
 char *buf;
 int len;
 {
+	static int logging = 0;
 	lockbuf_t *lck;
 	struct tm *tm;
 	char hbuf[MAXLOGLEN + 1];
@@ -116,6 +117,7 @@
 	u_char uc;
 	int n;
 
+	if (logging) return;
 #ifndef	NOUID
 	if (!getuid()) {
 		n = rootloglevel;
@@ -126,6 +128,7 @@
 	n = loglevel;
 	if (!n || n < lvl) return;
 
+	logging = 1;
 	if ((lck = openlogfile())) {
 		t = time(NULL);
 		tm = localtime(&t);
@@ -148,6 +151,7 @@
 		VOID_C write(lck -> fd, &uc, sizeof(uc));
 		lockclose(lck);
 	}
+	logging = 0;
 #ifndef	NOSYSLOG
 	if (usesyslog && syslogged >= 0) {
 		if (!syslogged) {
