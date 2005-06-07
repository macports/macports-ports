--- data/yacc.c.orig	2005-06-07 05:17:52.000000000 -0400
+++ data/yacc.c	2005-06-07 05:18:04.000000000 -0400
@@ -908,7 +908,9 @@
       goto yyoverflowlab;
 # else
       /* Extend the stack our own way.  */
+#if YYMAXDEPTH > 0
       if (YYMAXDEPTH <= yystacksize)
+#endif
 	goto yyoverflowlab;
       yystacksize *= 2;
       if (YYMAXDEPTH < yystacksize)
