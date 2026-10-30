--- src/runtime/ArcanistRuntime.php.orig	2021-12-10 00:42:19 UTC
+++ src/runtime/ArcanistRuntime.php
@@ -208,7 +208,7 @@ final class ArcanistRuntime {
     $bin = $arcanist_root.'/scripts/arcanist.php';
 
     $err = phutil_passthru(
-      'php -f %R -- %Ls',
+      '%%PHP_CMD%% -f %R -- %Ls',
       $bin,
       array_slice($argv, 1));
 
