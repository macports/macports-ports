--- src/draw_amacro.c.orig	2005-11-09 13:37:09.000000000 +0100
+++ src/draw_amacro.c	2005-11-09 13:37:27.000000000 +0100
@@ -48,21 +48,21 @@
 typedef struct {
     double *stack;
     int sp;
-} stack_t;
+} macro_stack_t;
 
 
-static stack_t *
+static macro_stack_t *
 new_stack(unsigned int nuf_push)
 {
     const int extra_stack_size = 10;
-    stack_t *s;
+    macro_stack_t *s;
 
-    s = (stack_t *)malloc(sizeof(stack_t));
+    s = (macro_stack_t *)malloc(sizeof(macro_stack_t));
     if (!s) {
 	free(s);
 	return NULL;
     }
-    memset(s, 0, sizeof(stack_t));
+    memset(s, 0, sizeof(macro_stack_t));
 
     s->stack = (double *)malloc(sizeof(double) * (nuf_push + extra_stack_size));
     if (!s->stack) {
@@ -78,7 +78,7 @@
 
 
 static void
-free_stack(stack_t *s)
+free_stack(macro_stack_t *s)
 {
     if (s && s->stack)
 	free(s->stack);
@@ -91,7 +91,7 @@
 
 
 static void
-push(stack_t *s, double val)
+push(macro_stack_t *s, double val)
 {
     s->stack[s->sp++] = val;
     return;
@@ -99,7 +99,7 @@
 
 
 static double
-pop(stack_t *s)
+pop(macro_stack_t *s)
 {
     return s->stack[--s->sp];
 } /* pop */
@@ -140,7 +140,7 @@
  * Doesn't handle explicit x,y yet
  */
 static void
-gerbv_draw_prim1(GdkPixmap *pixmap, GdkGC *gc, stack_t *s, int scale,
+gerbv_draw_prim1(GdkPixmap *pixmap, GdkGC *gc, macro_stack_t *s, int scale,
 		 gint x, gint y)
 {
     const int exposure_idx = 0;
@@ -185,7 +185,7 @@
  *  - how thick is the outline?
  */
 static void
-gerbv_draw_prim4(GdkPixmap *pixmap, GdkGC *gc, stack_t *s, int scale,
+gerbv_draw_prim4(GdkPixmap *pixmap, GdkGC *gc, macro_stack_t *s, int scale,
 		 gint x, gint y)
 {
     const int exposure_idx = 0;
@@ -252,7 +252,7 @@
  * Doesn't handle explicit x,y yet
  */
 static void
-gerbv_draw_prim5(GdkPixmap *pixmap, GdkGC *gc, stack_t *s, int scale,
+gerbv_draw_prim5(GdkPixmap *pixmap, GdkGC *gc, macro_stack_t *s, int scale,
 		 gint x, gint y)
 {
     const int exposure_idx = 0;
@@ -308,7 +308,7 @@
  *    center of line of circle?
  */
 static void
-gerbv_draw_prim6(GdkPixmap *pixmap, GdkGC *gc, stack_t *s, int scale,
+gerbv_draw_prim6(GdkPixmap *pixmap, GdkGC *gc, macro_stack_t *s, int scale,
 		 gint x, gint y)
 {
     const int outside_dia_idx = 2;
@@ -385,7 +385,7 @@
 
 
 static void
-gerbv_draw_prim7(GdkPixmap *pixmap, GdkGC *gc, stack_t *s, int scale,
+gerbv_draw_prim7(GdkPixmap *pixmap, GdkGC *gc, macro_stack_t *s, int scale,
 		 gint x, gint y)
 {
     const int outside_dia_idx = 2;
@@ -459,7 +459,7 @@
  * Doesn't handle and explicit x,y yet
  */
 static void
-gerbv_draw_prim20(GdkPixmap *pixmap, GdkGC *gc, stack_t *s, int scale,
+gerbv_draw_prim20(GdkPixmap *pixmap, GdkGC *gc, macro_stack_t *s, int scale,
 		  gint x, gint y)
 {
     const int exposure_idx = 0;
@@ -514,7 +514,7 @@
  * Doesn't handle explicit x,y yet
  */
 static void
-gerbv_draw_prim21(GdkPixmap *pixmap, GdkGC *gc, stack_t *s, int scale,
+gerbv_draw_prim21(GdkPixmap *pixmap, GdkGC *gc, macro_stack_t *s, int scale,
 		  gint x, gint y)
 {
     const int exposure_idx = 0;
@@ -569,7 +569,7 @@
  * Doesn't handle explicit x,y yet
  */
 static void
-gerbv_draw_prim22(GdkPixmap *pixmap, GdkGC *gc, stack_t *s, int scale,
+gerbv_draw_prim22(GdkPixmap *pixmap, GdkGC *gc, macro_stack_t *s, int scale,
 		  gint x, gint y)
 {
     const int exposure_idx = 0;
@@ -627,7 +627,7 @@
 		  instruction_t *program, unsigned int nuf_push,
 		  double *parameters, int scale, gint x, gint y)
 {
-    stack_t *s = new_stack(nuf_push);
+    macro_stack_t *s = new_stack(nuf_push);
     instruction_t *ip;
     int handled = 1;
     
