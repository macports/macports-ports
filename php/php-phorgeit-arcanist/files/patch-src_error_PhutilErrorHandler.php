--- src/error/PhutilErrorHandler.php.orig	2025-12-15 18:12:56 UTC
+++ src/error/PhutilErrorHandler.php
@@ -185,6 +185,11 @@ final class PhutilErrorHandler extends Phobject {
    * @task internal
    */
   public static function handleError($num, $str, $file, $line, $ctx = null) {
+    // work around PHP 8.1+ null argument deprecation error
+    if ($num === E_DEPRECATED && preg_match('/Passing null to parameter #.* of type .* is deprecated/', $str)) {
+      return true;
+    }
+
     foreach (self::$traps as $trap) {
       $trap->addError($num, $str, $file, $line);
     }
