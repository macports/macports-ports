--- rpmio/rpmsq.c.orig	Thu Mar 29 23:30:45 2007
+++ rpmio/rpmsq.c	Thu Jun 28 15:30:35 2007
@@ -7,6 +7,7 @@
 #if defined(__LCLINT__)
 #define	_BITS_SIGTHREAD_H	/* XXX avoid __sigset_t heartburn. */
 
+#ifndef __FreeBSD__
 /*@-incondefs -protoparammatch@*/
 /*@-exportheader@*/
 /*@constant int SA_SIGINFO@*/
@@ -20,6 +21,7 @@
 	/*@globals errno, systemState @*/;
 extern void (*sigset(int sig, void (*disp)(int)))(int)
 	/*@globals errno, systemState @*/;
+#endif
 
 struct qelem;
 extern	void insque(struct qelem * __elem, struct qelem * __prev)
@@ -121,6 +123,43 @@
 #include <sys/signal.h>
 #include <sys/wait.h>
 #include <search.h>
+
+#ifdef __FreeBSD__
+/* backported from updated rpm5 code by rse: */
+
+/* portability fallback for sighold(3) */
+static int sighold(int sig)
+{
+    sigset_t set;
+    if (sigprocmask(SIG_SETMASK, NULL, &set) < 0)
+        return -1;
+    if (sigaddset(&set, sig) < 0)
+        return -1;
+    return sigprocmask(SIG_SETMASK, &set, NULL);
+}
+
+/* portability fallback for sigrelse(3) */
+static int sigrelse(int sig)
+{
+    sigset_t set;
+    if (sigprocmask(SIG_SETMASK, NULL, &set) < 0)
+        return -1;
+    if (sigdelset(&set, sig) < 0)
+        return -1;
+    return sigprocmask(SIG_SETMASK, &set, NULL);
+}
+
+/* portability fallback for sigpause(3) */
+static int sigpause(int sig)
+{
+    sigset_t set;
+    if (sigemptyset(&set) < 0)
+        return -1;
+    if (sigaddset(&set, sig) < 0)
+        return -1;
+    return sigsuspend(&set);
+}
+#endif
 
 #if defined(HAVE_PTHREAD_H)
 
