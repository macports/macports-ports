--- GDSmain.c.orig	Tue Nov 23 13:32:47 2004
+++ GDSmain.c	Tue Nov 23 13:33:24 2004
@@ -52,7 +52,7 @@
   fprintf(stderr, "                         No PS/HPGL file are generated\n");
 }
 
-void
+int
 main(argc, argv)
   int argc;
   char **argv;
@@ -165,4 +165,5 @@
     GDStoPS(libptr, psfile, configfile, structname);
     GDStoHPGL(libptr, hpglfile, structname);
   }
+  exit(0);
 }
