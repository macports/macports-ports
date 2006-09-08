--- src/pic16/pcode.c.orig	2006-07-24 07:33:20.000000000 +0200
+++ src/pic16/pcode.c	2006-07-24 07:33:42.000000000 +0200
@@ -9911,18 +9911,18 @@
   struct stack_s *next;
 } stackitem_t;
 
-typedef stackitem_t *stack_t;
+typedef stackitem_t *sdcc_stack_t;
 static stackitem_t *free_stackitems = NULL;
 
 /* Create a stack with one item. */
-static stack_t *newStack () {
-  stack_t *s = (stack_t *) Safe_malloc (sizeof (stack_t));
+static sdcc_stack_t *newStack () {
+  sdcc_stack_t *s = (sdcc_stack_t *) Safe_malloc (sizeof (sdcc_stack_t));
   *s = NULL;
   return s;
 }
 
 /* Remove a stack -- its items are only marked free. */
-static void deleteStack (stack_t *s) {
+static void deleteStack (sdcc_stack_t *s) {
   stackitem_t *i;
 
   while (*s) {
@@ -9945,7 +9945,7 @@
   } // while
 }
 
-static void stackPush (stack_t *stack, void *data) {
+static void stackPush (sdcc_stack_t *stack, void *data) {
   stackitem_t *i;
   
   if (free_stackitems) {
@@ -9959,7 +9959,7 @@
   *stack = i;
 }
 
-static void *stackPop (stack_t *stack) {
+static void *stackPop (sdcc_stack_t *stack) {
   void *data;
   stackitem_t *i;
   
@@ -9976,7 +9976,7 @@
 }
 
 #if 0
-static int stackContains (stack_t *s, void *data) {
+static int stackContains (sdcc_stack_t *s, void *data) {
   stackitem_t *i;
   if (!s) return 0;
   i = *s;
@@ -9990,7 +9990,7 @@
 }
 #endif
 
-static int stackIsEmpty (stack_t *s) {
+static int stackIsEmpty (sdcc_stack_t *s) {
   return (*s == NULL);
 }
 
@@ -10011,7 +10011,7 @@
   Safe_free (s);
 }
 
-static int stateIsNew (state_t *state, stack_t *todo, stack_t *done) {
+static int stateIsNew (state_t *state, sdcc_stack_t *todo, sdcc_stack_t *done) {
   stackitem_t *i;
 
   /* scan working list for state */
@@ -10098,8 +10098,8 @@
   pCodeFlow *curr;
   pCodeFlowLink *succ;
   state_t *state;
-  stack_t *todo;	/** stack of state_t */
-  stack_t *done;	/** stack of state_t */
+  sdcc_stack_t *todo;	/** stack of state_t */
+  sdcc_stack_t *done;	/** stack of state_t */
 
   int firstState, n_defs;
   
@@ -10453,7 +10453,7 @@
 static int pic16_isAlive (symbol_t sym, pCode *pc) {
   int mask, visit;
   defmap_t *map;
-  stack_t *todo, *done;
+  sdcc_stack_t *todo, *done;
   state_t *state;
   pCodeFlow *pcfl;
   pCodeFlowLink *succ;
