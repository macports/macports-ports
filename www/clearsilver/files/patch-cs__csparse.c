--- ./cs/csparse.c.orig	2012-04-23 17:45:37.010509629 +0200
+++ ./cs/csparse.c	2012-04-23 17:49:26.478510015 +0200
@@ -262,7 +262,7 @@
   *node = NULL;
   my_node = (CSTREE *) calloc (1, sizeof (CSTREE));
   if (my_node == NULL)
-    return nerr_raise (NERR_NOMEM, "Unable to allocate memory for node");
+    return nerr_raise (NERR_NOMEM, "%s", "Unable to allocate memory for node");
 
   my_node->cmd = 0;
   my_node->node_num = NodeNumber++;
@@ -375,7 +375,7 @@
   node = (CS_ERROR *) calloc(1, sizeof(CS_ERROR));
   if (node == NULL) 
   {
-    return nerr_raise (NERR_NOMEM,
+    return nerr_raise (NERR_NOMEM, "%s",
         "Unable to allocate memory for error entry");
   }
 
@@ -406,7 +406,7 @@
   CS_POSITION pos;
 
   if (path == NULL)
-    return nerr_raise (NERR_ASSERT, "path is NULL");
+    return nerr_raise (NERR_ASSERT, "%s", "path is NULL");
 
   if (parse->fileload)
   {
@@ -791,7 +791,7 @@
             NEOERR *err;
             char *mapped_name = sprintf_alloc("%s%s", map->s, c);
             if (mapped_name == NULL)
-              return nerr_raise(NERR_NOMEM, "Unable to allocate memory to create mapped name");
+              return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory to create mapped name");
             err = hdf_set_value(parse->hdf, mapped_name, value);
             free(mapped_name);
             return nerr_pass(err);
@@ -814,7 +814,7 @@
 	  map->s = strdup(value);
 	  if (tmp != NULL) free(tmp);
 	  if (map->s == NULL && value != NULL)
-	    return nerr_raise(NERR_NOMEM,
+	    return nerr_raise(NERR_NOMEM, "%s",
 		"Unable to allocate memory to set var");
 
 	  return STATUS_OK;
@@ -2120,9 +2120,9 @@
   NEOERR *err;
 
   if (expr == NULL)
-    return nerr_raise (NERR_ASSERT, "expr is NULL");
+    return nerr_raise (NERR_ASSERT, "%s", "expr is NULL");
   if (result == NULL)
-    return nerr_raise (NERR_ASSERT, "result is NULL");
+    return nerr_raise (NERR_ASSERT, "%s", "result is NULL");
 
 #if DEBUG_EXPR_EVAL
   _depth++;
@@ -2200,7 +2200,7 @@
           result->n = arg_eval_num (parse, &arg1);
           break;
         case CS_OP_LPAREN:
-          return nerr_raise(NERR_ASSERT, "LPAREN should be handled above");
+          return nerr_raise(NERR_ASSERT, "%s", "LPAREN should be handled above");
         default:
           result->n = 0;
           ne_warn ("Unsupported op %s in eval_expr", expand_token_type(expr->op_type, 1));
@@ -2421,7 +2421,7 @@
 	s = strdup(s);
 	if (s == NULL)
 	{
-	  return nerr_raise(NERR_NOMEM, "Unable to allocate memory for lvar_eval");
+	  return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory for lvar_eval");
 	}
       }
 
@@ -3442,7 +3442,7 @@
   memset(&each_map, 0, sizeof(each_map));
 
   carg = node->vargs;
-  if (carg == NULL) return nerr_raise (NERR_ASSERT, "No arguments in loop eval?");
+  if (carg == NULL) return nerr_raise (NERR_ASSERT, "%s", "No arguments in loop eval?");
   err = eval_expr(parse, carg, &val);
   if (err) return nerr_pass(err);
   end = arg_eval_num(parse, &val);
@@ -3532,7 +3532,7 @@
   CSTREE *node;
 
   if (parse->tree == NULL)
-    return nerr_raise (NERR_ASSERT, "No parse tree exists");
+    return nerr_raise (NERR_ASSERT, "%s", "No parse tree exists");
 
   parse->output_ctx = ctx;
   parse->output_cb = cb;
@@ -3605,7 +3605,7 @@
 	s = va_arg(ap, char **);
 	if (s == NULL)
 	{
-	  err = nerr_raise(NERR_ASSERT,
+	  err = nerr_raise(NERR_ASSERT, "%s",
 	      "Invalid number of arguments in call to cs_arg_parse");
 	  break;
 	}
@@ -3615,7 +3615,7 @@
 	i = va_arg(ap, long int *);
 	if (i == NULL)
 	{
-	  err = nerr_raise(NERR_ASSERT,
+	  err = nerr_raise(NERR_ASSERT, "%s",
 	      "Invalid number of arguments in call to cs_arg_parse");
 	  break;
 	}
@@ -3938,7 +3938,7 @@
   }
   slice = (char *) malloc (sizeof(char) * (e-b+1));
   if (slice == NULL)
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory for string slice");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory for string slice");
   strncpy(slice, s + b, e-b);
   free(s);
   slice[e-b] = '\0';
@@ -4052,7 +4052,7 @@
 
   my_parse = (CSPARSE *) calloc (1, sizeof (CSPARSE));
   if (my_parse == NULL)
-    return nerr_raise (NERR_NOMEM, "Unable to allocate memory for CSPARSE");
+    return nerr_raise (NERR_NOMEM, "%s", "Unable to allocate memory for CSPARSE");
 
   err = uListInit (&(my_parse->stack), 10, 0);
   if (err != STATUS_OK)
@@ -4079,7 +4079,7 @@
   if (entry == NULL)
   {
     cs_destroy (&my_parse);
-    return nerr_raise (NERR_NOMEM,
+    return nerr_raise (NERR_NOMEM, "%s",
 	"Unable to allocate memory for stack entry");
   }
   entry->state = ST_GLOBAL;
@@ -4325,7 +4325,7 @@
   char buf[4096];
 
   if (parse->tree == NULL)
-    return nerr_raise (NERR_ASSERT, "No parse tree exists");
+    return nerr_raise (NERR_ASSERT, "%s", "No parse tree exists");
 
   node = parse->tree;
   return nerr_pass (dump_node (parse, node, 0, ctx, cb, buf, sizeof(buf)));
--- cs/csparse.c.orig	2014-12-20 17:50:47.000000000 +1100
+++ cs/csparse.c	2014-12-20 17:52:04.000000000 +1100
@@ -3717,7 +3717,7 @@ static NEOERR * _builtin_str_crc(CSPARSE
   if (val.op_type & (CS_TYPE_VAR | CS_TYPE_STRING))
   {
     char *s = arg_eval(parse, &val);
-    if (s) result->n = ne_crc((unsigned char *)s, strlen(s));
+    if (s) result->n = (INT32) ne_crc((unsigned char *)s, strlen(s));
   }
   if (val.alloc) free(val.s);
   return STATUS_OK;
