--- execute.c.orig	2005-04-15 01:47:43.000000000 -0400
+++ execute.c	2005-04-15 01:48:20.000000000 -0400
@@ -22,6 +22,8 @@
 #define EVAL_WRAP	/* empty */
 #define RETURN_WRAP(t, l, r, v)	display_return(t, l, r, v);
 
+static value cupl_eval(node *tree);
+
 static node *data;	/* pointer to *DATA item to be grabbed next */
 static jmp_buf endbuf;	/* termination handling */
 
@@ -141,8 +143,6 @@
 static void cupl_assign(node *to, value from)
 /* assign result of the expression at the cdr to the identifier at the cdr */
 {
-    static value cupl_eval(node *);
-
     deallocate_value(&(to->syminf->value));
     to->syminf->value = from;
     if (to->syminf->watchcount && to->syminf->watchcount--)
