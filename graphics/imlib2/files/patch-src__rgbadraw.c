--- src/rgbadraw.c.orig	2003-07-12 21:21:23.000000000 -0400
+++ src/rgbadraw.c	2005-05-01 03:00:05.000000000 -0400
@@ -2358,6 +2358,7 @@
                        if (ps)
                           ps->next = s;
                      nospans:
+		       ;
                     }
                }
              if (i == y2)
@@ -2365,6 +2366,7 @@
              i += step;
           }
       nolines:
+	;
      }
    for (i = 0; i < h; i++)
      {
