--- target.make.orig	2006-04-02 00:01:02.000000000 -0500
+++ target.make	2006-04-02 00:03:59.000000000 -0500
@@ -299,7 +299,7 @@
 DYLIB_DEF_FRAMEWORKS += -framework Foundation
 endif
 
-ifeq ($(CC_BUNDLE), no)
+ifeq ($(OBJC_RUNTIME_LIB), gnu)
 # GNU compiler
 
 INTERNAL_LDFLAGS += -flat_namespace -undefined warning
@@ -333,8 +333,8 @@
           fi; \
           $(LN_S) $(LIB_LINK_VERSION_FILE) $(LIB_LINK_FILE))
 
-BUNDLE_LD       =  /usr/bin/ld
-BUNDLE_LDFLAGS  += -bundle /usr/lib/bundle1.o
+BUNDLE_LD       =  $(CC)
+BUNDLE_LDFLAGS  += -fgnu-runtime -bundle
 
 else 
 # Apple Compiler
