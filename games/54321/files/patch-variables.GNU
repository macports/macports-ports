--- archs/Darwin/variables.GNU.old	Tue Feb 10 19:52:43 2004
+++ archs/Darwin/variables.GNU	Tue Feb 10 19:52:50 2004
@@ -1,5 +1,5 @@
 ############################################################
-CXX := CC
+CXX := g++
 STRIP := strip
 ############################################################
 MKDIR_CMD = test -d $(@D) || mkdir -p $(@D)
