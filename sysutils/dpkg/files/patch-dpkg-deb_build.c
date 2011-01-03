--- dpkg-deb/build.c.orig	2010-10-31 05:14:40.000000000 -0500
+++ dpkg-deb/build.c	2010-12-20 02:18:56.000000000 -0600
@@ -350,8 +350,8 @@
     m_dup2(p1[1],1); close(p1[0]); close(p1[1]);
     if (chdir(directory)) ohshite(_("failed to chdir to `%.255s'"),directory);
     if (chdir(BUILDCONTROLDIR)) ohshite(_("failed to chdir to .../DEBIAN"));
-    execlp(TAR, "tar", "-cf", "-", "--format=gnu", ".", NULL);
-    ohshite(_("failed to exec tar -cf"));
+    execlp(TAR, "gnutar", "-cf", "-", "--format=gnu", ".", NULL);
+    ohshite(_("failed to exec gnutar -cf"));
   }
   close(p1[1]);
   /* Create a temporary file to store the control data in. Immediately unlink
@@ -373,7 +373,7 @@
   }
   close(p1[0]);
   waitsubproc(c2,"gzip -9c",0);
-  waitsubproc(c1,"tar -cf",0);
+  waitsubproc(c1,"gnutar -cf",0);
   if (fstat(gzfd,&controlstab)) ohshite(_("failed to fstat tmpfile (control)"));
   /* We have our first file for the ar-archive. Write a header for it to the
    * package and insert it.
@@ -423,8 +423,8 @@
     m_dup2(p1[0],0); close(p1[0]); close(p1[1]);
     m_dup2(p2[1],1); close(p2[0]); close(p2[1]);
     if (chdir(directory)) ohshite(_("failed to chdir to `%.255s'"),directory);
-    execlp(TAR, "tar", "-cf", "-", "--format=gnu", "--null", "-T", "-", "--no-recursion", NULL);
-    ohshite(_("failed to exec tar -cf"));
+    execlp(TAR, "gnutar", "-cf", "-", "--format=gnu", "--null", "-T", "-", "--no-recursion", NULL);
+    ohshite(_("failed to exec gnutar -cf"));
   }
   close(p1[0]);
   close(p2[1]);
@@ -457,19 +457,19 @@
       add_to_filist(fi,&symlist,&symlist_end);
     else {
       if (write(p1[1], fi->fn, strlen(fi->fn)+1) ==- 1)
-	ohshite(_("failed to write filename to tar pipe (data)"));
+	ohshite(_("failed to write filename to gnutar pipe (data)"));
     }
   close(p3[0]);
   waitsubproc(c3,"find",0);
 
   for (fi= symlist;fi;fi= fi->next)
     if (write(p1[1], fi->fn, strlen(fi->fn)+1) == -1)
-      ohshite(_("failed to write filename to tar pipe (data)"));
+      ohshite(_("failed to write filename to gnutar pipe (data)"));
   /* All done, clean up wait for tar and gzip to finish their job */
   close(p1[1]);
   free_filist(symlist);
-  waitsubproc(c2,"<compress> from tar -cf",0);
-  waitsubproc(c1,"tar -cf",0);
+  waitsubproc(c2,"<compress> from gnutar -cf",0);
+  waitsubproc(c1,"gnutar -cf",0);
   /* Okay, we have data.tar.gz as well now, add it to the ar wrapper */
   if (!oldformatflag) {
     const char *datamember;
