--- src/phage/bootloader/PhagePHPAgentBootloader.php.orig	2020-05-19 10:37:09 UTC
+++ src/phage/bootloader/PhagePHPAgentBootloader.php
@@ -27,7 +27,7 @@ final class PhagePHPAgentBootloader extends PhageAgent
     // reads and evaluates the main agent program.
 
     return csprintf(
-      'php -r %s',
+      '%%PHP_CMD%% -r %s',
       "eval(fread(\$I=fopen('php://stdin', 'r'), {$len})); /* phage! */");
   }
 
