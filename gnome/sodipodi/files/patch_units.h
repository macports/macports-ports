--- src/helper/units.h	Thu Nov 28 21:18:50 2002
+++ src/helper/units.h	Sun Jul 13 16:34:36 2003
@@ -44,7 +44,7 @@
  * The base absolute unit is 1/72th of an inch (we are gnome PRINT, so sorry SI)
  */
 
-enum {
+typedef enum {
 	SP_UNIT_DIMENSIONLESS = (1 << 0), /* For percentages and like */
 	SP_UNIT_ABSOLUTE = (1 << 1), /* Real world distances - i.e. mm, cm... */
 	SP_UNIT_DEVICE = (1 << 2), /* Semi-real device-dependent distances i.e. pixels */
