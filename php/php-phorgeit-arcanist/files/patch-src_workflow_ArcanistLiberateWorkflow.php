--- src/workflow/ArcanistLiberateWorkflow.php.orig	2021-12-10 00:42:19 UTC
+++ src/workflow/ArcanistLiberateWorkflow.php
@@ -163,7 +163,7 @@ EOTEXT
     }
 
     return phutil_passthru(
-      'php -f %R -- %Ls %R',
+      '%%PHP_CMD%% -f %R -- %Ls %R',
       $bin,
       $argv,
       $path);
