--- references/scoped_update.m.sav	Fri Aug 13 15:57:47 2004
+++ references/scoped_update.m	Fri Aug 13 15:58:23 2004
@@ -90,7 +90,7 @@
 
 #ifdef ME_DEBUG_SCOPE
   #define ME_show_handle(msg, handle)				\
-	printf(""%s <%5d, in: %5d, out: %5d\n"", (msg),		\
+	printf(""%s <%5d, in: %5d, out: %5d\\n"", (msg),	\
 			*(int *) (handle)->var,			\
 			(int) (handle)->insideval,		\
 			(int) (handle)->outsideval)
@@ -112,7 +112,7 @@
 		case MR_undo:
 		case MR_retry:
 			ME_untrail_msg(""ME_enter_scope_failing: ""
-					""exception/undo/retry\n"");
+					""exception/undo/retry\\n"");
 			ME_show_handle(""=> fail back into scope.  old:  "",
 					handle);
 			handle->outsideval = *handle->var;
@@ -122,7 +122,7 @@
 			break;
 
 		default:
-			ME_untrail_msg(""ME_enter_scope_failing: default\n"");
+			ME_untrail_msg(""ME_enter_scope_failing: default\\n"");
 			break;
 	}
 }
@@ -135,7 +135,7 @@
 		case MR_undo:
 		case MR_retry:
 			ME_untrail_msg(""ME_exit_scope_failing: ""
-					""exception/undo/retry\n"");
+					""exception/undo/retry\\n"");
 			ME_show_handle(""<= fail back out of scope.  old:  "",
 					handle);
 			*handle->var = handle->outsideval;
@@ -146,14 +146,14 @@
 		case MR_commit:
 		case MR_solve:
 			ME_untrail_msg(""ME_exit_scope_failing: ""
-					""commit/solve\n"");
+					""commit/solve\\n"");
 			/* This *may* help GC collect more garbage */
 			handle->var = (MR_Word *) 0;
 			handle->outsideval = handle->insideval = (MR_Word) 0;
 			break;
 
 		default:
-			ME_untrail_msg(""ME_exit_scope_failing: default\n"");
+			ME_untrail_msg(""ME_exit_scope_failing: default\\n"");
 			/* we may need to do something if reason == MR_gc */
 			break;
 	}
