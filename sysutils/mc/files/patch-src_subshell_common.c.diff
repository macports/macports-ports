--- src/subshell/common.c.orig	2016-05-07 15:42:52 UTC
+++ src/subshell/common.c
@@ -320,7 +320,8 @@ init_subshell_child (const char *pty_nam
 
         break;
 
-        /* TODO: Find a way to pass initfile to TCSH, ZSH and FISH */
+        /* TODO: Find a way to pass initfile to SH, TCSH, ZSH and FISH */
+    case SHELL_SH:
     case SHELL_TCSH:
     case SHELL_ZSH:
     case SHELL_FISH:
@@ -369,6 +370,7 @@ init_subshell_child (const char *pty_nam
     case SHELL_DASH:
     case SHELL_TCSH:
     case SHELL_FISH:
+    case SHELL_SH:
         execl (mc_global.shell->path, mc_global.shell->path, (char *) NULL);
         break;
 
@@ -889,6 +891,11 @@ init_subshell_precmd (char *precmd, size
                     subshell_pipe[WRITE]);
         break;
 
+    case SHELL_SH:
+        g_snprintf (precmd, buff_size,
+                    "PS1='$USER@\\h:\\w\\$ '\n", subshell_pipe[WRITE]);
+        break;
+
     default:
         break;
     }
