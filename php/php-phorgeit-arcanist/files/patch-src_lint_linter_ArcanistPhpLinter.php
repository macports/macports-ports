--- src/lint/linter/ArcanistPhpLinter.php.orig	2020-05-19 10:39:38 UTC
+++ src/lint/linter/ArcanistPhpLinter.php
@@ -44,7 +44,7 @@ final class ArcanistPhpLinter extends ArcanistExternal
   }
 
   public function getDefaultBinary() {
-    return 'php';
+    return '%%PHP_CMD%%';
   }
 
   public function getVersion() {
