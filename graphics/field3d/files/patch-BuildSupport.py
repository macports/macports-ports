--- BuildSupport.py.FCS	2010-11-12 09:35:52.000000000 -0800
+++ BuildSupport.py	2011-08-09 10:06:05.000000000 -0700
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
@@ -213,17 +209,10 @@
     if isDebugBuild():
         env.Append(CCFLAGS = ["-g"])
     else:
-        env.Append(CCFLAGS = ["-O3"])
+        env.Append(CCFLAGS = ["-g", "-O3"])
     env.Append(CCFLAGS = ["-Wall"])
     # Set number of jobs to use
     env.SetOption('num_jobs', numCPUs())
-    # 64 bit setup
-    if architectureStr() == arch64:
-        env.Append(CCFLAGS = ["-m64"])
-        env.Append(LINKFLAGS = ["-m64"])
-    else:
-        env.Append(CCFLAGS = ["-m32"])
-        env.Append(LINKFLAGS = ["-m32"])
 
 # ------------------------------------------------------------------------------
 
