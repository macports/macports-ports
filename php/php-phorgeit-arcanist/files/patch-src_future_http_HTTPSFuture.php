--- src/future/http/HTTPSFuture.php.orig	2025-12-15 18:12:56 UTC
+++ src/future/http/HTTPSFuture.php
@@ -379,31 +379,24 @@ final class HTTPSFuture extends BaseHTTPFuture {
       //   means that the user wants to override everything (also because the
       //   user might not have access to change the box's php.ini to add
       //   curl.cainfo).
-      // - Otherwise, try using curl.cainfo. If it's set explicitly, it's
-      //   probably reasonable to try using it before we fall back to what
-      //   Arcanist ships with.
-      // - Lastly, try the default that Arcanist ships with. If it doesn't
-      //   work, give up and yell at the user.
 
       if (!$this->getCABundle()) {
         $caroot = dirname(phutil_get_library_root('arcanist'));
         $caroot = $caroot.'/resources/ssl/';
-
-        $ini_val = ini_get('curl.cainfo');
         if (self::getGlobalCABundle()) {
           $this->setCABundleFromPath(self::getGlobalCABundle());
         } else if (Filesystem::pathExists($caroot.'custom.pem')) {
           $this->setCABundleFromPath($caroot.'custom.pem');
-        } else if ($ini_val) {
-          // TODO: We can probably do a pathExists() here, even.
-          $this->setCABundleFromPath($ini_val);
-        } else {
-          $this->setCABundleFromPath($caroot.'default.pem');
         }
       }
 
-      if ($this->canSetCAInfo()) {
-        curl_setopt($curl, CURLOPT_CAINFO, $this->getCABundle());
+      $ca_bundle = $this->getCABundle();
+      if ($ca_bundle && $this->canSetCAInfo()) {
+        if (is_dir($ca_bundle)) {
+          curl_setopt($curl, CURLOPT_CAPATH, $ca_bundle);
+        } else {
+          curl_setopt($curl, CURLOPT_CAINFO, $ca_bundle);
+        }
       }
 
       $verify_peer = 1;
