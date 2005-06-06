--- imcomm/snac.c.orig	2005-06-06 06:22:45.000000000 -0400
+++ imcomm/snac.c	2005-06-06 06:22:58.000000000 -0400
@@ -439,6 +439,8 @@
 		if (type == 0x0000 && name != NULL) {
 			imcomm_addtobuddylist(handle, (char *) name, id);
 		}
+
+		free(name);
 	}
 
 	pkt_freeP(pkt);
