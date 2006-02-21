--- browser/app/profile/firefox.js~	2006-02-20 11:21:57.000000000 -0500
+++ browser/app/profile/firefox.js	2006-02-20 11:42:58.000000000 -0500
@@ -48,6 +48,9 @@
 #endif
 #endif
 
+// DarwinPorts-specific preferences
+pref("general.useragent.vendorComment", "DarwinPorts Community Edition");
+
 pref("startup.homepage_override_url","chrome://browser-region/locale/region.properties");
 pref("general.startup.browser", true);
 
