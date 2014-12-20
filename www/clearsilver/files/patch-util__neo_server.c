--- ./util/neo_server.c.orig	2005-06-30 20:52:00.000000000 +0200
+++ ./util/neo_server.c	2012-04-23 18:01:33.745912541 +0200
@@ -126,7 +126,7 @@
   NEOERR *err;
 
   if (server->req_cb == NULL)
-    return nerr_raise(NERR_ASSERT, "nserver requires a request callback");
+    return nerr_raise(NERR_ASSERT, "%s", "nserver requires a request callback");
 
   ignore_pipe();
 
@@ -162,7 +162,7 @@
 	child = fork();
 	if (child == -1)
 	{
-	  err = nerr_raise_errno(NERR_SYSTEM, "Unable to fork child");
+	  err = nerr_raise_errno(NERR_SYSTEM, "%s", "Unable to fork child");
 	  break;
 	}
 	if (!child)
@@ -202,7 +202,7 @@
 	child = fork();
 	if (child == -1)
 	{
-	  err = nerr_raise_errno(NERR_SYSTEM, "Unable to fork child");
+	  err = nerr_raise_errno(NERR_SYSTEM, "%s", "Unable to fork child");
 	  break;
 	}
 	if (!child)
