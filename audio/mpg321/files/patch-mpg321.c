
$FreeBSD: /repoman/r/pcvs/ports/audio/mpg321/files/patch-mpg321.c,v 1.3 2004/01/07 20:24:23 naddy Exp $

--- mpg321.c.orig	Sun Mar 24 06:49:20 2002
+++ mpg321.c	Wed Jan  7 21:12:40 2004
@@ -188,7 +188,7 @@
             
             else
             {
-                printf(names[i]);
+                printf("%s", names[i]);
                 free(names[i]);
             }
         }
@@ -203,7 +203,7 @@
             if (!names[i])  {
                 fprintf (stderr, emptystring);
             }   else    {
-                fprintf (stderr, names[i]);
+                fprintf (stderr, "%s", names[i]);
                 free (names[i]);
             }
             if (i%2) fprintf (stderr, "\n");
@@ -410,12 +410,14 @@
             
             if(fstat(fd, &stat) == -1)
             {
+                close(fd);
                 mpg321_error(currentfile);
                 continue;
             }
             
             if (!S_ISREG(stat.st_mode))
             {
+                close(fd);
                 continue;
             }
             
@@ -432,6 +434,7 @@
             if((playbuf.buf = mmap(0, playbuf.length, PROT_READ, MAP_SHARED, fd, 0))
                                 == MAP_FAILED)
             {
+                close(fd);
                 mpg321_error(currentfile);
                 continue;
             }
@@ -509,9 +512,6 @@
 
         mad_decoder_finish(&decoder);
 
-        if (quit_now)
-            break;
-
         if (playbuf.frames)
              free(playbuf.frames);
 
@@ -521,6 +521,7 @@
         if (playbuf.fd == -1)
         {
             munmap(playbuf.buf, playbuf.length);
+            close(fd);
         }
 
         else
@@ -535,10 +536,6 @@
         ao_close(playdevice);
 
     ao_shutdown();
-
-#if defined(RAW_SUPPORT) || defined(HTTP_SUPPORT) || defined(FTP_SUPPORT) 
-    if(fd) close(fd);
-#endif
 
     return(0);
 }
