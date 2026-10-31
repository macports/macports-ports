--- src/moduleutils/PhutilLibraryMapBuilder.php.orig	2022-03-04 17:30:36 UTC
+++ src/moduleutils/PhutilLibraryMapBuilder.php
@@ -240,7 +240,7 @@ final class PhutilLibraryMapBuilder extends Phobject {
     $bin = dirname(__FILE__).'/../../support/lib/extract-symbols.php';
 
     return new ExecFuture(
-      'php -f %R -- --ugly %Ls -- %Ls',
+      '%%PHP_CMD%% -f %R -- --ugly %Ls -- %Ls',
       $bin,
       $flags,
       $paths);
