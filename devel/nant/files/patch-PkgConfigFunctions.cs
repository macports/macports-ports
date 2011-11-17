--- src/NAnt.Core/Functions/PkgConfigFunctions.cs.orig	2011-09-17 15:08:22.000000000 -0500
+++ src/NAnt.Core/Functions/PkgConfigFunctions.cs	2011-11-17 15:17:16.000000000 -0600
@@ -260,7 +260,7 @@
                 execTask.Execute();
                 ms.Position = 0;
                 StreamReader sr = new StreamReader(ms);
-                string output = sr.ReadLine();
+                string output = sr.ReadLine().Replace("\x00", "");
                 sr.Close();
                 return output;
             } catch (Exception ex) {
