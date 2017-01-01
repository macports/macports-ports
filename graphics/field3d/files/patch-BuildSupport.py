--- BuildSupport.py.orig	2016-12-17 16:53:58.000000000 -0700
+++ BuildSupport.py	2016-12-17 16:53:31.000000000 -0700
@@ -70,19 +70,15 @@
 # ------------------------------------------------------------------------------
 
 systemIncludePaths = {
-    "darwin" : { arch32 : ["/usr/local/include",
-                           "/opt/local/include"],
-                 arch64 : ["/usr/local/include",
-                           "/opt/local/include"]},
+    "darwin" : { arch32 : ["@PREFIX@/include"],
+                 arch64 : ["@PREFIX@/include"]},
     "linux2" : { arch32 : ["/usr/local/include"],
                  arch64 : ["/usr/local64/include"]}
 }
 
 systemLibPaths = {
-    "darwin" : { arch32 : ["/usr/local/lib",
-                           "/opt/local/lib"],
-                 arch64 : ["/usr/local/lib",
-                           "/opt/local/lib"]},
+    "darwin" : { arch32 : ["@PREFIX@/lib"],
+                 arch64 : ["@PREFIX@/lib"]},
     "linux2" : { arch32 : ["/usr/local/lib"],
                  arch64 : ["/usr/local64/lib"]}
 }
@@ -221,6 +217,8 @@
         env.Append(LIBS = [Site.boostThreadLib])
     else:
         env.Append(LIBS = ["boost_thread-mt"])
+    # Boost system
+    env.Append(LIBS = ["boost_system-mt"])
     # Compile flags
     if isDebugBuild():
         env.Append(CCFLAGS = ["-g"])
@@ -231,13 +229,6 @@
     env.Append(CCFLAGS = ["-Wno-unused-local-typedef"])
     # Set number of jobs to use
     env.SetOption('num_jobs', numCPUs())
-    # 64 bit setup
-    if architectureStr() == arch64:
-        env.Append(CCFLAGS = ["-m64"])
-        env.Append(LINKFLAGS = ["-m64"])
-    else:
-        env.Append(CCFLAGS = ["-m32"])
-        env.Append(LINKFLAGS = ["-m32"])
     # Prettify SCons output
     if ARGUMENTS.get("verbose", 0) != "1":
         env["ARCOMSTR"] = "AR $TARGET"
