--- src/eval.c.orig	Tue Feb 13 16:38:05 2001
+++ src/eval.c	Thu Feb 19 16:25:53 2004
@@ -565,7 +565,7 @@
 	case CONST_NINF:
 	case CONST_NAN:
 	  p->type = TYP_FLT;
-	  p->Float = (byte == CONST_INF) ? __plinf : ((byte == CONST_NINF) ? __neinf : __nan);
+	  p->Float = (byte == CONST_INF) ? __plinf : ((byte == CONST_NINF) ? __neinf : __o_nan);
 	  break;
 
 	case VAR:
