--- src/workflow/ArcanistAnoidWorkflow.php.orig	2025-12-15 18:12:56 UTC
+++ src/workflow/ArcanistAnoidWorkflow.php
@@ -24,10 +24,10 @@ EOTEXT
   }
 
   protected function runWorkflow() {
-    if (!Filesystem::binaryExists('python3')) {
+    if (!Filesystem::binaryExists('%%PYTHON_CMD%%')) {
       throw new PhutilArgumentUsageException(
         pht(
-          'The "arc anoid" workflow requires "python3" to be available '.
+          'The "arc anoid" workflow requires "%%PYTHON_CMD%%" to be available '.
           'in your $PATH.'));
     }
 
