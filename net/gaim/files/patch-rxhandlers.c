--- src/protocols/oscar/rxhandlers.c	13 Dec 2002 22:34:13 -0000	1.6
+++ src/protocols/oscar/rxhandlers.c	9 Jan 2003 00:30:20 -0000
@@ -467,7 +467,7 @@
 			return cur->handler;
 	}
 
-	if (type == AIM_CB_SPECIAL_DEFAULT) {
+	if ((type - (short)AIM_CB_SPECIAL_DEFAULT) == 0) {
 		faimdprintf(sess, 1, "aim_callhandler: no default handler for family 0x%04x\n", family);
 		return NULL; /* prevent infinite recursion */
 	}
