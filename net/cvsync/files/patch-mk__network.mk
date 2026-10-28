--- mk/network.mk.orig	2005-04-19 05:42:38.000000000 -0400
+++ mk/network.mk	2005-04-19 05:43:29.000000000 -0400
@@ -47,8 +47,10 @@
 endif # CYGWIN
 
 ifeq (${HOST_OS}, Darwin)
+ifeq ($(shell ${TEST} ${OSVER} -lt 8 && ${ECHO} yes), yes) # 3.5-RELEASE
 CFLAGS += -Dsocklen_t=int
 USE_POLL       ?= no
+endif # Mac OS X 10.4/Darwin 8
 endif # Darwin
 
 ifeq (${HOST_OS}, FreeBSD)
