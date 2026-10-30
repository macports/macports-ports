--- src/toolset/workflow/ArcanistVersionWorkflow.php.orig	2020-05-14 16:16:36 UTC
+++ src/toolset/workflow/ArcanistVersionWorkflow.php
@@ -36,6 +36,12 @@ EOTEXT
 
     $console = PhutilConsole::getConsole();
 
+    $versions = array("%%PKGNAME%% %%PKGVERSION%% (%%PKGORIGIN%%)");
+    foreach ($versions as $pkg) {
+      $console->writeOut($pkg."\n");
+    }
+    return;
+
     if (!Filesystem::binaryExists('git')) {
       throw new ArcanistUsageException(
         pht(
