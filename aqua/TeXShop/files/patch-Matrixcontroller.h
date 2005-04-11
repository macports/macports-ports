--- Matrixcontroller.h.orig	2005-04-03 06:21:04.000000000 -0400
+++ Matrixcontroller.h	2005-04-03 06:21:06.000000000 -0400
@@ -61,7 +61,6 @@
 - (int)rowCount;
 - (int)colCount;
 - (id)objectInRow:(unsigned)row inCol:(unsigned)col;
-- (id)rowAtIndex:(unsigned)row;
 -(void)replaceObjectInRow:(unsigned)row inCol:(unsigned)col withObject:(id) anObj;
 - (void)addRow;
 - (void)insertRow:(NSMutableArray*)row atIndex:(int)ind;
