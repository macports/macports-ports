--- inc/Module/Install/PRIVATE/Net/SSLeay.pm.org	2008-07-24 15:09:34.000000000 -0700
+++ inc/Module/Install/PRIVATE/Net/SSLeay.pm	2008-08-06 12:30:34.000000000 -0700
@@ -126,7 +126,7 @@
     }
 
     my %guesses = (
-            '/usr/bin/openssl'               => '/usr',
+            '/usr/bin/openssl'               => '/opt/local',
             '/usr/sbin/openssl'              => '/usr',
             '/opt/ssl/bin/openssl'           => '/opt/ssl',
             '/opt/ssl/sbin/openssl'          => '/opt/ssl',
