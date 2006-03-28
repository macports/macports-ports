--- target.make.orig	2006-03-09 20:10:59.000000000 +0100
+++ target.make	2006-03-23 15:22:32.000000000 +0100
@@ -333,8 +333,9 @@
           fi; \
           $(LN_S) $(LIB_LINK_VERSION_FILE) $(LIB_LINK_FILE))
 
-BUNDLE_LD       =  /usr/bin/ld
-BUNDLE_LDFLAGS  += -bundle /usr/lib/bundle1.o
+BUNDLE_LD       =  $(CC)
+# NB FSF gcc complains if -bundle is the *first* command line argument
+BUNDLE_LDFLAGS  += -fgnu-runtime -bundle
 
 else 
 # Apple Compiler
