diff -u -r ../work-orig/hotspot/make/bsd/makefiles/vm.make ./hotspot/make/bsd/makefiles/vm.make
--- ../work-orig/hotspot/make/bsd/makefiles/vm.make	2010-11-04 19:45:35.000000000 +0800
+++ ./hotspot/make/bsd/makefiles/vm.make	2010-11-04 19:51:45.000000000 +0800
@@ -99,6 +99,11 @@
 # Extra flags from gnumake's invocation or environment
 CFLAGS += $(EXTRA_CFLAGS)
 
+# Required for <ucontext.h> and pthread_*np() functions.
+ifeq ($(OS_VENDOR), Darwin)
+  CFLAGS  += -D_XOPEN_SOURCE -D_DARWIN_C_SOURCE
+endif
+
 LIBS += -lm -pthread
 
 # By default, link the *.o into the library, not the executable.
