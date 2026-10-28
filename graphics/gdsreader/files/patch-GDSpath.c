--- GDSpath.c.orig	1999-04-07 22:39:45.000000000 -0700
+++ GDSpath.c	2004-11-23 10:19:08.000000000 -0800
@@ -310,7 +310,7 @@
 GDSreadPath(int gdsfildes, GDSstruct *structptr)
 {
   unsigned char *record;
-  int i, nbytes, layerno;
+  int i, nbytes, layerno, datatype;
   layer *layerptr;
   GDScell *newcell;
   pathEl *pathptr;
@@ -353,6 +353,7 @@
     fprintf(stderr, "Missing DATATYPE field in PATH element. Abort!\n");
     /* exit(1); */
   }
+  datatype = GDSreadInt2(record + 2);
   FREE(record);
 
   if(GDSreadRecord(gdsfildes, &record, &nbytes) != PATHTYPE)
@@ -411,8 +412,8 @@
   }
   FREE(record);
 
-  fprintf(stdout, "Path on layer %d of type %d with width = %d:\n",
-          layerno, pathptr->pathtype, pathptr->width);
+  fprintf(stdout, "Path on layer %d (datatype %d) of type %d with width = %d:\n",
+          layerno, datatype, pathptr->pathtype, pathptr->width);
   for(i = 0; i < pathptr->numpoints; i++)
     fprintf(stdout, "point[%d] = %d %d\n",
             i, (pathptr->points[i]).x, (pathptr->points[i]).y);
