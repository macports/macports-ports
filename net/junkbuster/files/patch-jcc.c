--- ../ijb-zlib-11.orig/jcc.c	Wed Jun 12 23:16:29 2002
+++ jcc.c	Fri Jan  7 09:48:06 2005
@@ -32,18 +32,23 @@
 #include <OS.h>		/* declarations for threads and stuff. */
 #endif
 
+#ifdef HAVE_POLL
+#include <sys/poll.h>
+#else
 #ifndef FD_ZERO
 #include <select.h>
 #endif
+#endif
 
 #endif
 
 #ifdef REGEX
-#include <gnu_regex.h>
+#include <gnuregex.h>
 #endif
 
 #include "jcc.h"
-#include "zutil.h"
+#include <zlib.h>
+#define DEF_MEM_LEVEL 8
 
 char *prog;
 
@@ -99,10 +104,29 @@
 	"(copyright_or_otherwise)_applying_to_any_cookie._";
 
 char DEFAULT_USER_AGENT[] ="User-Agent: Mozilla/3.01Gold (Macintosh; I; 68K)";
+char DEFAULT_TINYGIF_REGEX[] = ".*(\\.gif|\\.jpe?g|\\.png|gif$|jpe?g$|png$)";
+
+char BLANKGIF[] = "HTTP/1.0 200 OK\r\n" 
+                  "Content-type: image/gif\r\n\r\n" 
+                  "GIF89a\001\000\001\000\200\000\000\377\377\377\000\000" 
+                  "\000!\371\004\001\000\000\000\000,\000\000\000\000\001" 
+                  "\000\001\000\000\002\002D\001\000;"; 
+
+char JBGIF[] = "HTTP/1.0 200 OK\r\n"
+                  "Content-type: image/gif\r\n\r\n"
+                  "GIF89aD\000\013\000\360\000\000\000\000\000\377\377\377!"
+                  "\371\004\001\000\000\001\000,\000\000\000\000D\000\013\000"
+                  "\000\002a\214\217\251\313\355\277\000\200G&K\025\316hC\037"
+                  "\200\234\230Y\2309\235S\230\266\206\372J\253<\3131\253\271"
+                  "\270\215\342\254\013\203\371\202\264\334P\207\332\020o\266"
+                  "N\215I\332=\211\312\3513\266:\026AK)\364\370\365aobr\305"
+                  "\372\003S\275\274k2\354\254z\347?\335\274x\306^9\374\276"
+                  "\037Q\000\000;";
 
 int debug           = 0;
 int multi_threaded  = 1;
 int hideConsole     = 0;
+int tinygif         = 0;
 
 char *logfile = NULL;
 FILE *logfp;
@@ -120,6 +144,8 @@
 char *uagent     = NULL;
 char *from       = NULL;
 
+char *tinygif_regexp = NULL;
+
 int suppress_vanilla_wafer = 0;
 int add_forwarded      = 0;
 int auto_compress      = 0;
@@ -351,6 +377,9 @@
 	struct http_request *http;
 	char *iob_buf;
 	int iob_len;
+ 	char *my_image_regexp = DEFAULT_TINYGIF_REGEX;
+ 	regex_t my_regexp;
+ 	int errcode;
 
 
 	http = csp->http;
@@ -502,7 +531,22 @@
 				prog, http->hostport, http->path);
 		}
 
-		write_socket(csp->cfd, p, strlen(p));
+		if(tinygif_regexp) my_image_regexp = strdup(tinygif_regexp);
+		if (tinygif > 0) {
+		  errcode = regcomp(&my_regexp, my_image_regexp,
+				    (REG_EXTENDED|REG_NOSUB|REG_ICASE));
+		  
+		  if (regexec( &my_regexp, http->path, 0, NULL, 0) == 0) {
+		    if (tinygif == 1)
+		      write_socket(csp->cfd, BLANKGIF, sizeof(BLANKGIF)-1);
+		    else
+		      write_socket(csp->cfd, JBGIF, sizeof(JBGIF)-1);
+		  } else {
+		    write_socket(csp->cfd, p, strlen(p));
+		  }
+		  regfree( &my_regexp );
+		} else
+		  write_socket(csp->cfd, p, strlen(p));
 
 		if(DEBUG(LOG)) fwrite(p, strlen(p), 1, logfp);
 
@@ -614,7 +658,26 @@
 
 	server_body = 0;
 
+#ifdef HAVE_POLL
+	fds[0].fd = csp->cfd;
+	fds[0].events = POLLIN|POLLHUP;
+	fds[1].fd = csp->sfd;
+	fds[1].events = POLLIN|POLLHUP;
+#endif
+
 	for(;;) {
+#ifdef HAVE_POLL
+		n = poll(fds, 2, -1);
+
+		if (n < 0) {
+			fprintf(logfp, "%s: poll() failed!: ", prog);
+			fperror(logfp, "");
+			return;
+		}
+
+#define IS_CLIENT()	(fds[0].revents & POLLIN)
+#define IS_SERVER()	(fds[1].revents & POLLIN)
+#else
 		FD_ZERO(&rfds);
 
 		FD_SET(csp->cfd, &rfds);
@@ -627,12 +690,14 @@
 			fperror(logfp, "");
 			return;
 		}
-
+#define IS_CLIENT()	FD_ISSET(csp->cfd, &rfds)
+#define IS_SERVER()	FD_ISSET(csp->sfd, &rfds)
+#endif
 		/* this is the body of the browser's request
 		 * just read it and write it.
 		 */
 
-		if(FD_ISSET(csp->cfd, &rfds)) {
+		if(IS_CLIENT()) {
 
 			n = read_socket(csp->cfd, buf, sizeof(buf));
 
@@ -653,7 +718,7 @@
 		 * otherwise it's the body
 		 */
 
-		if(FD_ISSET(csp->sfd, &rfds)) {
+		if(IS_SERVER()) {
 
 			n = read_socket(csp->sfd, buf, sizeof(buf));
 
@@ -935,6 +1000,16 @@
 
 			if(strcmp(cmd, "debug") == 0) {
 				debug |= atoi(arg);
+				continue;
+			}
+
+			if(strcmp(cmd, "tinygif") == 0) {
+				tinygif = atoi(arg);
+				continue;
+			}
+
+			if(strcmp(cmd, "tinygif-regexp") == 0) {
+				tinygif_regexp = strdup(arg);
 				continue;
 			}
 
