--- GDSboundary.c.orig	1999-04-07 22:39:45.000000000 -0700
+++ GDSboundary.c	2004-11-23 10:19:27.000000000 -0800
@@ -306,7 +306,7 @@
 GDSreadBoundary(int gdsfildes, GDSstruct *structptr)
 {
   unsigned char *record;
-  int i, nbytes, layerno;
+  int i, nbytes, layerno, datatype;
   layer *layerptr;
   GDScell *newcell;
   boundaryEl *boundaryptr;
@@ -349,6 +349,7 @@
     fprintf(stderr, "Missing DATATYPE field in BOUNDARY element. Abort!\n");
     /* exit(1); */
   }
+  datatype = GDSreadInt2(record + 2);
   FREE(record);
 
   if(GDSreadRecord(gdsfildes, &record, &nbytes) != XY)
@@ -373,7 +374,7 @@
   }
   FREE(record);
 
-  fprintf(stdout, "Boundary on layer %d:\n", layerno);
+  fprintf(stdout, "Boundary on layer %d (datatype %d):\n", layerno, datatype);
   for(i = 0; i < boundaryptr->numpoints; i++)
     fprintf(stdout, "point[%d] = %d %d\n",
             i, (boundaryptr->points[i]).x, (boundaryptr->points[i]).y);
