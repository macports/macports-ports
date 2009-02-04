diff -ruN work/daemon-0.6.3/libslack/macros.mk work/daemon-0.6.3-orig/libslack/macros.mk
--- work/daemon-0.6.3/libslack/macros.mk	2009-02-04 07:59:53.000000000 -0800
+++ work/daemon-0.6.3-orig/libslack/macros.mk	2009-02-04 07:55:47.000000000 -0800
@@ -27,6 +27,7 @@
 # SLACK_DEFINES += -DETC_DIR=\"/etc\"
 # SLACK_DEFINES += -DROOT_PID_DIR=\"/var/run\"
 # SLACK_DEFINES += -DUSER_PID_DIR=\"/tmp\"
+SLACK_DEFINES += -DNO_POSIX_C_SOURCE=1
 
 # Uncomment this if your system doesn't have GNU getopt_long()
 #
diff -ruN work/daemon-0.6.3/macros.mk work/daemon-0.6.3-orig/macros.mk
--- work/daemon-0.6.3/macros.mk	2009-02-04 07:59:53.000000000 -0800
+++ work/daemon-0.6.3-orig/macros.mk	2009-02-04 07:55:47.000000000 -0800
@@ -56,6 +56,7 @@
 DAEMON_DEFINES += -DHAVE_PTHREAD_RWLOCK=1
 # DAEMON_DEFINES += -DNO_POSIX_SOURCE=1
 # DAEMON_DEFINES += -DNO_XOPEN_SOURCE=1
+DAEMON_DEFINES += -DNO_POSIX_C_SOURCE=1
 
 DAEMON_TARGET := $(DAEMON_SRCDIR)/$(DAEMON_NAME)
 DAEMON_MODULES := daemon
