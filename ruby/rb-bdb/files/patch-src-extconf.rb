--- src/extconf.rb.orig	2011-04-06 19:35:39 UTC
+++ src/extconf.rb
@@ -36,16 +36,16 @@ if unknown = enable_config("unknown")
 
 if unknown = enable_config("unknown")
    libs = if CONFIG.key?("LIBRUBYARG_STATIC")
-	     Config::expand(CONFIG["LIBRUBYARG_STATIC"].dup).sub(/^-l/, '')
+	     RbConfig::expand(CONFIG["LIBRUBYARG_STATIC"].dup).sub(/^-l/, '')
 	  else
-	     Config::expand(CONFIG["LIBRUBYARG"].dup).sub(/lib([^.]*).*/, '\\1')
+	     RbConfig::expand(CONFIG["LIBRUBYARG"].dup).sub(/lib([^.]*).*/, '\\1')
 	  end
    unknown = find_library(libs, "ruby_init", 
-			  Config::expand(CONFIG["archdir"].dup))
+			  RbConfig::expand(CONFIG["archdir"].dup))
 end
 
 inc_dir, lib_dir = dir_config("db", "/usr/include", "/usr/lib")
-case Config::CONFIG["arch"]
+case RbConfig::CONFIG["arch"]
 when /solaris2/
    $DLDFLAGS ||= ""
    $DLDFLAGS += " -R#{lib_dir}"
@@ -53,6 +53,7 @@ $CFLAGS += " -DBDB_NO_THREAD_COMPILE" if enable_config
 $bdb_libdir = lib_dir
 
 $CFLAGS += " -DBDB_NO_THREAD_COMPILE" if enable_config("thread") == false
+$CFLAGS += " -Wno-int-conversion"
 
 unique = with_config("db-uniquename") || ''
 
@@ -63,10 +64,12 @@ if csv = with_config('db-version')
 if csv = with_config('db-version')
    version = csv.split(',', -1)
    version << '' if version.empty?
-elsif m = lib_dir.match(%r{/db(?:([2-9])|([2-9])([0-9])|-([2-9]).([0-9]))(?:$|/)}) ||
-          inc_dir.match(%r{/db(?:([2-9])|([2-9])([0-9])|-([2-9]).([0-9]))(?:$|/)})
+elsif m = lib_dir.match(%r{/db(?:([2-9])|([2-9])([0-9])|-([2-9]).([0-9]))|([1-9][0-9]+)(?:$|/)}) ||
+          inc_dir.match(%r{/db(?:([2-9])|([2-9])([0-9])|-([2-9]).([0-9]))(|([1-9][0-9]+)?:$|/)})
    if m[1]
       version = [m[1], '']
+   elsif m[6]
+      version = [m[6], '']
    else
       if m[2]
          major, minor = m[2], m[3]
@@ -94,7 +97,7 @@ catch(:done) do
          end
          next if with_ver.empty?
          if !unique.is_a?(String) || unique.empty?
-            m = with_ver.match(/^[^0-9]*([2-9])\.?([0-9]{0,3})/)
+            m = with_ver.match(/^[^0-9]*([1-9][0-9]*)\.?([0-9]{0,3})/)
             major = m[1].to_i
             minor = m[2].to_i
             db_version = "db_version_" + (1000 * major + minor).to_s
