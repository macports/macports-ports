--- target.make.orig	2005-07-28 18:36:09.000000000 -0400
+++ target.make	2005-07-28 18:37:40.000000000 -0400
@@ -301,7 +301,7 @@
 
 INTERNAL_LDFLAGS += -flat_namespace -undefined warning
 
-SHARED_LD_PREFLAGS += -Wl,-noall_load -read_only_relocs warning
+SHARED_LD_PREFLAGS += -Wl,-noall_load -read_only_relocs warning -fgnu-runtime
 # Useful flag: -Wl,-single_module.  This flag only
 # works starting with 10.3. libs w/ffcall don't link on darwin/ix86 without it.
 ifeq ($(findstring darwin7, $(GNUSTEP_TARGET_OS)), darwin7)
@@ -327,7 +327,7 @@
           $(LN_S) $(LIB_LINK_VERSION_FILE) $(LIB_LINK_FILE))
 
 BUNDLE_LD       =  /usr/bin/ld
-BUNDLE_LDFLAGS  += -bundle /usr/lib/bundle1.o
+BUNDLE_LDFLAGS  += -bundle /usr/lib/bundle1.o -L@DP_PREFIX@/lib/gcc40 -lobjc-gnu
 
 else 
 # Apple Compiler
