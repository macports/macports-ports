--- rfc1035/rfc1035_res.h-old	Fri Jul 18 14:03:07 2003
+++ rfc1035/rfc1035_res.h	Fri Jul 18 14:03:54 2003
@@ -40,7 +40,7 @@
 	unsigned randptr;
 	} ;
 
-extern struct rfc1035_res rfc1035_default_resolver;
+struct rfc1035_res rfc1035_default_resolver;
 
 #ifdef  __cplusplus
 }
