--- splt.h.orig	2004-07-17 08:16:05.000000000 -0600
+++ splt.h	2005-07-26 01:14:36.000000000 -0600
@@ -96,7 +96,7 @@
 
 char *zero_pad_float (float f, char *out);
 
-int parse_outformat(char *s, char format[][], int cddboption);
+int parse_outformat(char *s, char format[OUTNUM][MAXOLEN], int cddboption);
 
 unsigned char *cleanstring (unsigned char *s);
 
