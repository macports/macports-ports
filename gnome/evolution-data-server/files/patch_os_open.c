--- libdb/os/os_open.c.org	Fri Sep 17 22:56:14 2004
+++ libdb/os/os_open.c	Fri Sep 17 22:56:39 2004
@@ -106,11 +106,6 @@
 	if ((ret = __os_openhandle(dbenv, name, oflags, mode, fhp)) != 0)
 		return (ret);
 
-#ifdef HAVE_DIRECTIO
-	if (LF_ISSET(DB_OSO_DIRECT))
-		(void)directio(fhp->fd, DIRECTIO_ON);
-#endif
-
 	/*
 	 * Delete any temporary file.
 	 *
