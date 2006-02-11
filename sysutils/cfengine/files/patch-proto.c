--- src/proto.c	2005-12-07 08:14:05.000000000 -0800
+++ src/proto.c	2006-02-10 14:48:56.000000000 -0800
@@ -33,6 +33,7 @@
 
 #include "cf.defs.h"
 #include "cf.extern.h"
+#include "netinet/in.h"
 
 /*********************************************************************/
 
@@ -120,8 +121,8 @@
    
 #else 
    
-   iaddr = &(myaddr.sin_addr); 
-   hp = gethostbyaddr((void *)iaddr,sizeof(myaddr.sin_addr),family);
+   iaddr = &(myaddr.sin6_addr); 
+   hp = gethostbyaddr((void *)iaddr,sizeof(myaddr.sin6_addr),family);
    
    if ((hp == NULL) || (hp->h_name == NULL))
       {
