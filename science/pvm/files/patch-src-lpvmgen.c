--- src/lpvmgen.c	2004-02-17 19:01:29.000000000 +0100
+++ src/lpvmgen.c	2006-08-18 10:28:57.000000000 +0200
@@ -674,6 +674,8 @@
 
 struct pmsg *midtobuf();
 
+char *pvmnametag(int tag, int *found);
+
 
 /***************
  **  Private  **
